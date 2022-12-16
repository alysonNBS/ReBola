import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String? id;
  String? name;
  String? birthday;
  int? goals;
  int? defesas;
  int? defesasDePenalti;

  Player();

  Player.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.id;
    name = documentSnapshot.data()['name'] as String;
    birthday = documentSnapshot.data()['birthday'] as String;
    goals = documentSnapshot.data()['goals'] as int;
    defesas = documentSnapshot.data()['defesas'] as int;
    defesasDePenalti = documentSnapshot.data()['defesasDePenalti'] as int;
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['birthday'] = birthday;
    data['goals'] = goals;
    data['defesas'] = defesas;
    data['defesasDePenalti'] = defesasDePenalti;

    return data;
  }

  Future<void> set() {
    final doc = FirebaseFirestore.instance.collection('players').doc(id);
    return doc.set(toMap());
  }
}
