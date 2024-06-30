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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('O'),
                Switch(
                  value: myToken == Token.cross,
                  onChanged: (val) {
                    setState(
                      () {
                        myToken = myToken.other;
                      },
                    );
                  },
                ),
                const Text('X')
              ],
            ),
            const Divider(),
            const Text('Play stand-alone'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen.standAlone(),
                  ),
                );
              },
              child: const Text('Stand-alone game'),
            ),
            const Divider(),
            const Text('Play vs Machine'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GameScreen.vsMachine(myToken: myToken),
                      ),
                    );
                  },
                  child: const Text('Start vs Machine'),
                ),
              ],
            ),
            const Divider(),
            const Text('Play with Remote Player'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Do Something',
                      hintStyle: TextStyle(
                        color: Colors.grey[350],
                      )),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final gameRepo = context.read<GameRepo>();
                    final game = await gameRepo.createGame("dummy game");
                    if (!context.mounted) return;
                    await Navigator.push(
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
                  child: const Text('Create Game'),
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
