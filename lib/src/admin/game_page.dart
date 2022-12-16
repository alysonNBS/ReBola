import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebola/src/admin/move_page.dart';
import 'package:rebola/src/models/championship.dart';
import 'package:rebola/src/models/game.dart';
import 'package:rebola/src/models/team.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('games').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Algo deu errado!"));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final game = Game.fromSnapshot(snapshot.data!.docs[index]);

                    return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovePage(game),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.green[600],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${game.team1!.name!} x ${game.team2!.name!}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GameEditPage(game: game))),
                                    icon: const Icon(Icons.edit)),
                              ],
                            ),
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
            context, MaterialPageRoute(builder: (context) => GameEditPage())),
      ),
    );
  }
}

class GameEditPage extends StatefulWidget {
  Game? game;
  GameEditPage({super.key, this.game}) {
    game ??= Game();
  }

  @override
  State<StatefulWidget> createState() => _GameEditPageState();
}

class _GameEditPageState extends State<GameEditPage> {
  final _dateController = TextEditingController();
  final _team1Controller = TextEditingController();
  final _team2Controller = TextEditingController();
  final _championshipController = TextEditingController();

  @override
  void initState() {
    if (widget.game!.date != null) _dateController.text = widget.game!.date!;
    if (widget.game!.team1 != null)
      _team1Controller.text = widget.game!.team1!.name!;
    if (widget.game!.team2 != null)
      _team2Controller.text = widget.game!.team2!.name!;
    if (widget.game!.championship != null)
      _championshipController.text = widget.game!.championship!.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = TextFormField(
      keyboardType: TextInputType.datetime,
      controller: _dateController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Data',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final team1 = TextFormField(
      keyboardType: TextInputType.text,
      controller: _team1Controller,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '1º time',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final team2 = TextFormField(
      keyboardType: TextInputType.text,
      controller: _team2Controller,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '2º time',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final championship = TextFormField(
      keyboardType: TextInputType.text,
      controller: _championshipController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Campeonato',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Jogo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              widget.game!.date = _dateController.text;
              final docTeam1 = (await FirebaseFirestore.instance
                      .collection('teams')
                      .where('name', isEqualTo: _team1Controller.text)
                      .get())
                  .docs;
              final docTeam2 = (await FirebaseFirestore.instance
                      .collection('teams')
                      .where('name', isEqualTo: _team2Controller.text)
                      .get())
                  .docs;
              final docChampionship = (await FirebaseFirestore.instance
                      .collection('champs')
                      .where('name', isEqualTo: _championshipController.text)
                      .get())
                  .docs;
              if (docTeam1.isEmpty ||
                  docTeam2.isEmpty ||
                  docChampionship.isEmpty) {
                Navigator.pop(context);
                return;
              }
              widget.game!.team1 = Team.fromSnapshot(docTeam1.first);
              widget.game!.team2 = Team.fromSnapshot(docTeam2.first);
              widget.game!.championship =
                  Championship.fromSnapshot(docChampionship.first);
              widget.game!.set();
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
              date,
              const SizedBox(height: 8.0),
              team1,
              const SizedBox(height: 8.0),
              team2,
              const SizedBox(height: 8.0),
              championship,
              const SizedBox(height: 8.0),
            ]),
      ),
    );
  }
}
