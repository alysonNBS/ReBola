import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  String? id;
  String? name;

  Team();

  Team.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.id;
    name = documentSnapshot.data()['name'] as String;
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['name'] = name;

    return data;
  }

  Future<void> set() {
    final doc = FirebaseFirestore.instance.collection('teams').doc(id);
    return doc.set(toMap());
  }
}
