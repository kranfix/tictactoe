import 'package:flutter/material.dart';
import 'package:tic_tac_toe/domain/domain.dart';

class GameSearchScreen extends StatefulWidget {
  const GameSearchScreen({super.key});

  @override
  State<GameSearchScreen> createState() => _GameSearchScreenState();
}

class _GameSearchScreenState extends State<GameSearchScreen> {
  List<GameDescriptor>? activeGames;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading) const CircularProgressIndicator(),
        if (activeGames == null)
          const Text('Games are loading')
        else
          ...activeGames!.map((g) => OpenGameButton(game: g))
      ],
    );
  }
}

class OpenGameButton extends StatelessWidget {
  const OpenGameButton({super.key, required this.game});

  final GameDescriptor game;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigato to game
      },
      child: Text(game.name),
    );
  }
}
