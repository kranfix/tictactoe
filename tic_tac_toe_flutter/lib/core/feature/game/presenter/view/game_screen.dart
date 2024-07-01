import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/design_system/design_system.dart';
import 'package:tic_tac_toe/domain/game_search.dart';
import 'package:tic_tac_toe/game/game.dart';
import 'package:tic_tac_toe/lib.dart';

class GameScreen extends StatelessWidget {
  const GameScreen._({super.key, required this.game});

  factory GameScreen.standAlone({Key? key}) {
    final game = Game(
      circlePlayer: LocalPlayer(myToken: Token.circle),
      crossPlayer: LocalPlayer(myToken: Token.cross),
    );

    return GameScreen._(key: key, game: game);
  }

  factory GameScreen.vsMachine({Key? key, required Token myToken}) {
    final me = LocalPlayer(myToken: myToken);
    final other = MachinePlayer(myToken: myToken.other);
    final game = switch (myToken) {
      Token.circle => Game(circlePlayer: me, crossPlayer: other),
      Token.cross => Game(circlePlayer: other, crossPlayer: me),
    };

    return GameScreen._(key: key, game: game);
  }

  factory GameScreen.playWithRemote({
    Key? key,
    required String gameId,
    required Token myToken,
    required GameRepo gameRepo,
  }) {
    final me = LocalPlayer(myToken: myToken);
    final other =
        RemotePlayer(myToken: myToken.other, id: gameId, gameRepo: gameRepo);
    final game = switch (myToken) {
      Token.circle => Game(circlePlayer: me, crossPlayer: other),
      Token.cross => Game(circlePlayer: other, crossPlayer: me),
    };

    return GameScreen._(key: key, game: game);
  }

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('circle: ${game.circlePlayer.runtimeType}'),
            Text('cross: ${game.crossPlayer.runtimeType}'),
            BoardBoxes(
              game: game,
            ),
          ],
        ),
      ),
    );
  }
}

extension ToText on Token {
  Widget toText() => Text(this == Token.circle ? 'O' : 'X');
}

class Game extends ChangeNotifier {
  Game({required this.circlePlayer, required this.crossPlayer}) {
    _start();
  }

  Player circlePlayer;
  Player crossPlayer;

  int _remaindingBoxes = 9;
  int get remaindingBoxes => _remaindingBoxes;

  Token? nextToken = Token.circle;

  final _tokens = Board();
  Board get board => _tokens;

  bool _isAlive = true;
  int? lastIndex;

  Future<void> _start() async {
    while (_isAlive) {
      switch (nextToken) {
        case null:
          return;
        case Token.circle:
          final index =
              await circlePlayer.requestNext(board.serialize(), lastIndex);
          if (index == null) {
            nextToken = null;
            return;
          }
          final wasInserted = _insertToken(index);
          if (wasInserted) break;
        case Token.cross:
          final index =
              await crossPlayer.requestNext(board.serialize(), lastIndex);
          if (index == null) {
            nextToken = null;
            return;
          }
          final wasInserted = _insertToken(index);
          if (wasInserted) break;
      }
    }
  }

  void notifyLocalSelectionToPLayers(int index) {
    switch (nextToken) {
      case null:
        return;
      case Token.circle:
        if (circlePlayer is LocalPlayer) {
          (circlePlayer as LocalPlayer).insertToken(index);
        }
      case Token.cross:
        if (crossPlayer is LocalPlayer) {
          (crossPlayer as LocalPlayer).insertToken(index);
        }
    }
  }

  bool _insertToken(int index) {
    final nextToken = this.nextToken;
    if (nextToken == null) return false;
    final wasInserted = board.insertTokenAt(index, nextToken);
    if (!wasInserted) return false;

    lastIndex = index;
    _remaindingBoxes--;
    // if (_remaindingBoxes == 0) {
    //   this.nextToken = null;
    // } else {
    this.nextToken = switch (nextToken) {
      Token.circle => Token.cross,
      Token.cross => Token.circle,
    };
    // }
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _isAlive = false;
  }
}

class BoardBoxes extends StatefulWidget {
  const BoardBoxes({super.key, required this.game});

  final Game game;

  @override
  State<BoardBoxes> createState() => _BoardBoxesState();
}

class _BoardBoxesState extends State<BoardBoxes> {
  Game get controller => widget.game;

  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(update);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(update);
  }

  @override
  Widget build(BuildContext context) {
    final player = controller.nextToken;
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          itemCount: 9,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 140,
          ),
          itemBuilder: (context, index) {
            return BoxItem(
              onTap: () => controller.notifyLocalSelectionToPLayers(index),
              child: controller.board.at(index)?.toText(),
            );
          },
        ),
        if (player != null) Text('Plays ${player.name}'),
      ],
    );
  }
}
