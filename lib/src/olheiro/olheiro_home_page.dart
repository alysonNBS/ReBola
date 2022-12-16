import 'package:flutter/material.dart';
import 'package:rebola/src/olheiro/player_olheiro_page.dart';

class OlheiroHomePage extends StatefulWidget {
  const OlheiroHomePage({super.key});

  @override
  State<OlheiroHomePage> createState() => _OlheiroHomePageState();
}

class _OlheiroHomePageState extends State<OlheiroHomePage> {
  int _selectedIndex = 0;
  static const bodyList = <Widget>[PlayerOlheiroPage(), Scaffold()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyList[_selectedIndex],
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) => setState(() => _selectedIndex = index),
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home_outlined),
      //       activeIcon: Icon(Icons.home),
      //       label: 'Feed',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.favorite_outline),
      //       activeIcon: Icon(Icons.favorite),
      //       label: 'Favoritos',
      //     )
      //   ],
      // ),
    );
  }
}
