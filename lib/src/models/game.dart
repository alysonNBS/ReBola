import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rebola/src/models/championship.dart';
import 'package:rebola/src/models/team.dart';

class Game {
  String? id;
  Team? team1, team2;
  Championship? championship;
  String? date;

  Game();

  Game.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    team1 = Team();
    team2 = Team();
    championship = Championship();
    id = documentSnapshot.id;
    team1!.id = documentSnapshot.data()['idTeam1'] as String;
    team2!.id = documentSnapshot.data()['idTeam2'] as String;
    championship!.id = documentSnapshot.data()['idChampionship'] as String;
    championship!.name = documentSnapshot.data()['nameChampionship'] as String;
    team1!.name = documentSnapshot.data()['nameTeam1'] as String;
    team2!.name = documentSnapshot.data()['nameTeam2'] as String;
    date = documentSnapshot.data()['date'] as String;
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['idTeam1'] = team1!.id;
    data['idTeam2'] = team2!.id;
    data['idChampionship'] = championship!.id;
    data['nameChampionship'] = championship!.name;
    data['nameTeam1'] = team1!.name;
    data['nameTeam2'] = team2!.name;
    data['date'] = date;

    return data;
  }

  Future<void> set() {
    final doc = FirebaseFirestore.instance.collection('games').doc(id);
    return doc.set(toMap());
  }
}
