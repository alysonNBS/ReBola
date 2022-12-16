import 'package:flutter/material.dart';
import 'package:rebola/src/admin/championship_page.dart';
import 'package:rebola/src/admin/game_page.dart';
import 'package:rebola/src/admin/player_admin_page.dart';
import 'package:rebola/src/admin/team_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  static const bodyList = <Widget>[
    PlayerAdminPage(),
    TeamPage(),
    ChampionshipPage(),
    GamePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Jogadores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Times',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            activeIcon: Icon(Icons.assessment),
            label: 'Campeonatos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer_outlined),
            activeIcon: Icon(Icons.sports_soccer),
            label: 'Jogos',
          ),
        ],
      ),
    );
  }
}
