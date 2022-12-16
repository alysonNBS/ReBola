import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rebola/src/models/game.dart';
import 'package:rebola/src/models/player.dart';

class Move {
  String? id;
  String? type;
  String? time;
  Player? player;
  Game? game;

  Move(this.game);

  Move.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.id;
    game = Game();
    player = Player();
    game!.id = documentSnapshot.data()['gameId'] as String;
    type = documentSnapshot.data()['type'] as String;
    time = documentSnapshot.data()['time'] as String;
    player!.id = documentSnapshot.data()['playerId'] as String;
    player!.name = documentSnapshot.data()['playerName'] as String;
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['gameId'] = game!.id;
    data['type'] = type;
    data['time'] = time;
    data['playerId'] = player!.id;
    data['playerName'] = player!.name;

    return data;
  }

  Future<void> set() {
    final doc = FirebaseFirestore.instance
        .collection('games/${game!.id}/moves')
        .doc(id);
    final playerDoc =
        FirebaseFirestore.instance.collection('players').doc(player!.id);
    if (type!.toLowerCase() == 'gol') {
      playerDoc.update({'goals': FieldValue.increment(1)});
    }
    if (type!.toLowerCase() == 'defesa') {
      playerDoc.update({'defesas': FieldValue.increment(1)});
    }
    if (type!.toLowerCase() == 'defesa de penalti') {
      playerDoc.update({'defesasDePenalti': FieldValue.increment(1)});
    }
    return doc.set(toMap());
  }
}
