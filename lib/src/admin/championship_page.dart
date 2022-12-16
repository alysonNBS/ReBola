import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebola/src/models/championship.dart';

class ChampionshipPage extends StatefulWidget {
  const ChampionshipPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChampionshipPageState();
}

class _ChampionshipPageState extends State<ChampionshipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('champs').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Algo deu errado!"));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final champ =
                        Championship.fromSnapshot(snapshot.data!.docs[index]);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.green[600],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                champ.name!,
                                style: const TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChampionshipEditPage(
                                                  champ: champ))),
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChampionshipEditPage())),
      ),
    );
  }
}

class ChampionshipEditPage extends StatefulWidget {
  Championship? champ;
  ChampionshipEditPage({super.key, this.champ}) {
    champ ??= Championship();
  }

  @override
  State<StatefulWidget> createState() => _ChampionshipEditPageState();
}

class _ChampionshipEditPageState extends State<ChampionshipEditPage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    if (widget.champ!.name != null) _nameController.text = widget.champ!.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final name = TextFormField(
      keyboardType: TextInputType.name,
      controller: _nameController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Nome',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Campeonato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.champ!.name = _nameController.text;

              widget.champ!.set();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: ListView(
            // shrinkWrap: true,
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              const SizedBox(height: 8.0),
              name,
              const SizedBox(height: 8.0),
            ]),
      ),
    );
  }
}
