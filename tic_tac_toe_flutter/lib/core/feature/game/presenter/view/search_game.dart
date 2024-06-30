import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/core/feature/game/presenter/view/game_screen.dart';
import 'package:tic_tac_toe/domain/domain.dart';
import 'package:tic_tac_toe/lib.dart';

class StartGame extends StatefulWidget {
  const StartGame({super.key});

  @override
  State<StartGame> createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
  List<GameDescriptor>? activeGames;
  bool isLoading = false;

  Token myToken = Token.circle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Checkbox(
                  value: myToken == Token.circle,
                  onChanged: (value) {
                    if (value == true) {
                      setState(() {
                        myToken = Token.circle;
                      });
                    }
                  },
                ),
                Checkbox(
                    value: myToken == Token.cross,
                    onChanged: (value) {
                      if (value == true) {
                        setState(() {
                          myToken = Token.cross;
                        });
                      }
                    }),
              ],
            ),
            const Divider(),
            const Spacer(),
            const Text('Play stand-alone'),
            ElevatedButton(
              onPressed: () {
                final gameScreen = GameScreen.standAlone();
              },
              child: const Text('Stand-alone game'),
            ),
            const Divider(),
            const Text('Play vs Machine'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final gameScreen =
                        GameScreen.vsMachine(myToken: Token.circle);
                  },
                  child: const Text('Start vs Machine'),
                ),
              ],
            ),
            const Divider(),
            const Text('Play vs Machine'),
            TextField(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final gameRepo = context.watch<GameRepo>();
                    final game = await gameRepo.createGame("dummy game");
                    final gameScreen = GameScreen.playWithRemote(
                        gameId: game.id, myToken: myToken, gameRepo: gameRepo);
                  },
                  child: const Text('Start vs Machine'),
                ),
              ],
            ),
            const Divider(),
            const Text('Play vs remote player'),
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
                    myToken: myToken,
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
    required this.myToken,
  });

  final GameDescriptor game;
  final Token myToken;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final gameRepo = context.read<GameRepo>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen.playWithRemote(
              gameId: game.id,
              myToken: myToken,
              gameRepo: gameRepo,
            ),
          ),
        );
      },
      child: ListTile(
        title: Text(game.name),
      ),
    );
  }
}
