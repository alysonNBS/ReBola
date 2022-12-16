import 'package:cloud_firestore/cloud_firestore.dart';

class Championship {
  String? id;
  String? name;

  Championship();

  Championship.fromSnapshot(
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
    final doc = FirebaseFirestore.instance.collection('champs').doc(id);
    return doc.set(toMap());
  }
}
