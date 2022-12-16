import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebola/src/models/player.dart';

class PlayerAdminPage extends StatefulWidget {
  const PlayerAdminPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerAdminPageState();
}

class _PlayerAdminPageState extends State<PlayerAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('players').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final player =
                        Player.fromSnapshot(snapshot.data!.docs[index]);

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
                                player.name!,
                                style: const TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlayerEditPage(player: player))),
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
            context, MaterialPageRoute(builder: (context) => PlayerEditPage())),
      ),
    );
  }
}

class PlayerEditPage extends StatefulWidget {
  Player? player;
  PlayerEditPage({super.key, this.player}) {
    player ??= Player();
  }

  @override
  State<StatefulWidget> createState() => _PlayerEditPageState();
}

class _PlayerEditPageState extends State<PlayerEditPage> {
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();

  @override
  void initState() {
    if (widget.player!.birthday != null)
      _birthdayController.text = widget.player!.birthday!;
    if (widget.player!.name != null)
      _nameController.text = widget.player!.name!;
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

    final birthday = TextFormField(
      keyboardType: TextInputType.datetime,
      controller: _birthdayController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Nascimento',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Jogador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.player!.name = _nameController.text;
              widget.player!.birthday = _birthdayController.text;
              widget.player!.goals = 0;
              widget.player!.defesas = 0;
              widget.player!.defesasDePenalti = 0;

              widget.player!.set();
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
              birthday,
              const SizedBox(height: 8.0),
            ]),
      ),
    );
  }
}
