import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebola/src/models/game.dart';
import 'package:rebola/src/models/move.dart';
import 'package:rebola/src/models/player.dart';

class MovePage extends StatefulWidget {
  final Game game;
  const MovePage(this.game, {super.key});

  @override
  State<StatefulWidget> createState() => _MovePageState();
}

class _MovePageState extends State<MovePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lances do Jogo")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('games/${widget.game.id}/moves')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Algo deu errado!"));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final move = Move.fromSnapshot(snapshot.data!.docs[index]);

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
                                '${move.type!} - ${move.player!.name!}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MoveEditPage(move: move))),
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
            context,
            MaterialPageRoute(
                builder: (context) => MoveEditPage(move: Move(widget.game)))),
      ),
    );
  }
}

class MoveEditPage extends StatefulWidget {
  Move move;
  MoveEditPage({super.key, required this.move});

  @override
  State<StatefulWidget> createState() => _MoveEditPageState();
}

class _MoveEditPageState extends State<MoveEditPage> {
  final _timeController = TextEditingController();
  final _playerController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void initState() {
    if (widget.move.time != null) _timeController.text = widget.move.time!;
    if (widget.move.player != null)
      _playerController.text = widget.move.player!.name!;
    if (widget.move.type != null) _typeController.text = widget.move.type!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final type = TextFormField(
      keyboardType: TextInputType.text,
      controller: _typeController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Tipo',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final time = TextFormField(
      keyboardType: TextInputType.datetime,
      controller: _timeController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Tempo',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final player = TextFormField(
      keyboardType: TextInputType.text,
      controller: _playerController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Jogador',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Jogada'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              widget.move.time = _timeController.text;
              widget.move.type = _typeController.text;
              final docPlayer = (await FirebaseFirestore.instance
                      .collection('players')
                      .where('name', isEqualTo: _playerController.text)
                      .get())
                  .docs;
              if (docPlayer.isEmpty) {
                Navigator.pop(context);
                return;
              }
              widget.move.player = Player.fromSnapshot(docPlayer.first);
              widget.move.set();
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
              type,
              const SizedBox(height: 8.0),
              time,
              const SizedBox(height: 8.0),
              player,
              const SizedBox(height: 8.0),
            ]),
      ),
    );
  }
}
