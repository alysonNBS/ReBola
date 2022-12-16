import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rebola/src/auth_page.dart';
import 'package:rebola/src/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rebola',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: FirebaseAuth.instance.currentUser == null
          ? const AuthPage()
          : const MyHomePage(),
      //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
