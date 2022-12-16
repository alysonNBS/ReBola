import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:rebola/src/models/player.dart';

class PlayerOlheiroPage extends StatefulWidget {
  const PlayerOlheiroPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerOlheiroPageState();
}

class _PlayerOlheiroPageState extends State<PlayerOlheiroPage> {
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

                    return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerView(player),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.green[600],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      player.name!,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Nascimento: ${player.birthday!}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
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

class PlayerView extends StatefulWidget {
  final Player player;
  const PlayerView(this.player, {super.key});

  @override
  State<StatefulWidget> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    return Scaffold(
      appBar: AppBar(title: Text(player.name!)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.green[600],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          player.name!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Nascimento: ${player.birthday!}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Gols: ${player.goals!}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Defesas: ${player.defesas!}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Penalidades defendidas: ${player.defesasDePenalti!}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
            child: const Text(
              "Solicitar Contato",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onPressed: () async {
              final Email email = Email(
                body:
                    'Gostaria de receber informações do Jogador:\nNome: ${player.name}\nID: ${player.id}\n',
                subject: 'Solicitação de Contato',
                recipients: ['contato@rebola.com'],
                isHTML: false,
              );

              await FlutterEmailSender.send(email);
            },
          )
        ],
      ),
    );
  }
}
