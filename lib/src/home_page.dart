import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rebola/src/admin/admin_home_page.dart';
import 'package:rebola/src/app.dart';
import 'package:rebola/src/olheiro/olheiro_home_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReBola'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              })
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .doc('users/${FirebaseAuth.instance.currentUser!.uid}')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.data()!['olheiro']
                ? const OlheiroHomePage()
                : const AdminHomePage();
          }
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
