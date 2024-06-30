import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/feature/game/presenter/view/game_screen.dart';
import 'package:tic_tac_toe/domain/domain.dart';

class StartGame extends StatefulWidget {
  const StartGame({super.key});

  @override
  State<StartGame> createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
  List<GameDescriptor>? activeGames;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Start a new game'),
            ),
            const Spacer(),
            const Divider(),
            const Text('Active Games'),
            if (isLoading) const CircularProgressIndicator(),
            if (activeGames == null)
              const Text('Games are loading')
            else
              ListView.builder(
                itemCount: activeGames!.length,
                itemBuilder: (context, index) {
                  return OpenGameButton(
                    game: activeGames![index],
                    onTap: () {
                      //TODO! pass gameID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class OpenGameButton extends StatelessWidget {
  const OpenGameButton({
    super.key,
    required this.game,
    required this.onTap,
  });

  final GameDescriptor game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        title: Text(game.name),
      ),
    );
  }
}
