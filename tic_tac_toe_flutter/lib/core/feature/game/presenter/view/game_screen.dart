import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/core/design_system/design_system.dart';
import 'package:tic_tac_toe_flutter/lib.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final controller = TokenController(
      circlePlayer: LocalPlayer(
        myToken: Token.circle,
      ),
      crossPlayer: LocalPlayer(
        myToken: Token.cross,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: 9,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 140,
                    ),
                    itemBuilder: (context, index) {
                      return BoxItem(
                        onTap: () =>
                            controller.notifyLocalSelectionToPLayers(index),
                        child: controller.board.at(index)?.toText(),
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

extension ToText on Token {
  Widget toText() => Text(this == Token.circle ? 'O' : 'X');
}

class TokenController extends ChangeNotifier {
  TokenController({required this.circlePlayer, required this.crossPlayer}) {
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

  Future<void> _start() async {
    while (_isAlive) {
      switch (nextToken) {
        case null:
          return;
        case Token.circle:
          final index = await circlePlayer.requestNext(board.serialize());
          final wasInserted = _insertToken(index);
          if (wasInserted) break;
        case Token.cross:
          final index = await crossPlayer.requestNext(board.serialize());
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

    _remaindingBoxes--;
    if (_remaindingBoxes == 0) {
      this.nextToken = null;
    } else {
      this.nextToken = switch (nextToken) {
        Token.circle => Token.cross,
        Token.cross => Token.circle,
      };
    }
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _isAlive = false;
  }
}

abstract interface class Player {
  const Player();
  Future<int> requestNext(BoardSerialization board);

  void dispose();
}

class LocalPlayer implements Player {
  LocalPlayer({
    required this.myToken,
  })  : _completer = null,
        board = Board();

  final Token myToken;

  Completer<int>? _completer;
  Board board;

  @override
  void dispose() {
    _completer = null;
  }

  void insertToken(int index) {
    if (_completer == null) return;
    final wasInserted = board.insertTokenAt(index, myToken);
    if (wasInserted) {
      _completer!.complete(index);
      _completer = null;
    }
  }

  @override
  Future<int> requestNext(BoardSerialization data) {
    board = Board.deserialize(data);
    _completer ??= Completer();
    return _completer!.future;
  }
}
