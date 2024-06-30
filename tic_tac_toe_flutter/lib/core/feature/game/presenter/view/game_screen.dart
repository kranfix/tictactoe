import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/core/design_system/design_system.dart';

enum Token {
  circle,
  cross,
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

// const tokensDemo = [
//   Token.circle, null, null, //
//   null, Token.circle, null, //
//   Token.cross, null, null
// ];

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
                        child: controller.tokens[index]?.toText(),
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

  List<Token?> get tokens => _tokens;

  int get remaindingBoxes =>
      tokens.fold(0, (acc, token) => token == null ? acc + 1 : acc);

  Token? nextToken = Token.circle;

  final List<Token?> _tokens = List.generate(9, (_) => null);

  bool _isAlive = true;

  Future<void> _start() async {
    while (_isAlive) {
      switch (nextToken) {
        case null:
          return;
        case Token.circle:
          final index = await circlePlayer.requestNext(tokens: [...tokens]);
          final wasInserted = _insertToken(index);
          if (wasInserted) {
            nextToken = Token.cross;
            break;
          }
        case Token.cross:
          final index = await crossPlayer.requestNext(tokens: [...tokens]);
          final wasInserted = _insertToken(index);
          if (wasInserted) {
            nextToken = Token.circle;
            break;
          }
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
    if (_tokens[index] == null) {
      _tokens[index] = nextToken;
      if (remaindingBoxes == 0) {
        nextToken = null;
      }
      notifyListeners();
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    super.dispose();
    _isAlive = false;
  }
}

abstract interface class Player {
  const Player();
  Future<int> requestNext({required List<Token?> tokens});

  void dispose();
}

class LocalPlayer implements Player {
  LocalPlayer({
    required this.myToken,
  })  : _completer = null,
        tokens = List.generate(9, (_) => null);

  final Token myToken;

  Completer<int>? _completer;
  List<Token?> tokens;

  @override
  void dispose() {
    _completer = null;
  }

  void insertToken(int index) {
    if (_completer == null || tokens[index] != null) return;
    tokens[index] = myToken;
    _completer!.complete(index);
    _completer = null;
  }

  @override
  Future<int> requestNext({required List<Token?> tokens}) {
    this.tokens = tokens;
    _completer ??= Completer();
    return _completer!.future;
  }
}
