import 'dart:async';

import './board.dart';

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
