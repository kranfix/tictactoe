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
  List<GameDescriptor>? gamesWatingForAnotherPlayer;
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
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final repo = context.read<GameRepo>();
                final games = await repo.listWaitingForCrossPlayerGames();

                setState(() {
                  gamesWatingForAnotherPlayer = games;
                  isLoading = false;
                });
              },
              child: const Text('Refresh'),
            ),
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
            CreateRemoteGame(myToken: myToken),
            const Divider(),
            const Text('Play vs remote player'),
            const Divider(),
            Text('Active Games ${gamesWatingForAnotherPlayer?.length}'),
            if (isLoading) const CircularProgressIndicator(),
            if (gamesWatingForAnotherPlayer == null)
              const Text('Games are loading')
            else
              ...gamesWatingForAnotherPlayer!.map(
                (g) => OpenGameButton(game: g),
              ),
            //  ListView.builder(
            //       itemCount: gamesWatingForAnotherPlayer!.length,
            //       itemBuilder: (context, index) {
            //         return OpenGameButton(
            //           game: gamesWatingForAnotherPlayer![index],
            //           myToken: myToken,
            //         );
            //       },
            //     ),

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
  });

  final GameDescriptor game;

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
              myToken: game.nextPlayer.other,
              gameRepo: gameRepo,
            ),
          ),
        );
      },
      child: ListTile(
        title: Text(
          game.name,
        ),
        leading: Text('Join as ${game.nextPlayer.other}'),
      ),
    );
  }
}

class CreateRemoteGame extends StatefulWidget {
  const CreateRemoteGame({super.key, required this.myToken});

  final Token myToken;

  @override
  State<CreateRemoteGame> createState() => _CreateRemoteGameState();
}

class _CreateRemoteGameState extends State<CreateRemoteGame> {
  String gameName = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                hintText: 'Insert game name',
                hintStyle: TextStyle(
                  color: Colors.grey[350],
                ),
              ),
              onChanged: (value) => {gameName = value},
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (gameName.trim().isEmpty) {
                  return;
                }
                final gameRepo = context.read<GameRepo>();
                final game = await gameRepo.createGame(gameName);
                if (!context.mounted) return;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen.playWithRemote(
                      gameId: game.id,
                      myToken: widget.myToken,
                      gameRepo: gameRepo,
                    ),
                  ),
                );
              },
              child: const Text('Create Game'),
            ),
          ],
        ),
      ],
    );
  }
}
