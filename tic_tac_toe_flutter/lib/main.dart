import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/core/feature/game/presenter/view/game_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tic Tact Toe',
      home: GameScreen(),
    );
  }
}
