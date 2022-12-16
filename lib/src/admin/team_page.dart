import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebola/src/models/team.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<StatefulWidget> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('teams').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Algo deu errado!"));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final team = Team.fromSnapshot(snapshot.data!.docs[index]);

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
                                team.name!,
                                style: const TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TeamEditPage(team: team))),
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
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => TeamEditPage())),
      ),
    );
  }
}

class TeamEditPage extends StatefulWidget {
  Team? team;
  TeamEditPage({super.key, this.team}) {
    team ??= Team();
  }

  @override
  State<StatefulWidget> createState() => _TeamEditPageState();
}

class _TeamEditPageState extends State<TeamEditPage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    if (widget.team!.name != null) _nameController.text = widget.team!.name!;
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
        title: const Text('Cadastro de Time'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.team!.name = _nameController.text;

              widget.team!.set();
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
