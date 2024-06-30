import 'dart:async';

import './board.dart';

abstract interface class Player {
  const Player({required this.myToken});
  final Token myToken;

  Future<int> requestNext(BoardSerialization data);

  void dispose();
}

class LocalPlayer extends Player {
  LocalPlayer({
    required super.myToken,
  })  : _completer = null,
        board = Board(),
        super();

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

/// In DB we must save
/// currentBoard: "ox_xoo__x"
/// lastPlayer: "o", // 'o' | 'x'
/// lastIndex: 4, // 0..<9
abstract class RemotePlayer extends Player {
  RemotePlayer({required super.myToken}) {
    _unsub = subscribe(_onNext);
  }

  Completer<int>? _completer;

  // Save BoardSerialization, last player(myToken)
  Future<void> updateState(BoardSerialization board);

  void Function()? _unsub;

  void Function() subscribe(
      void Function(Token lastPlayer, int lastIndex) onNext);

  void _onNext(Token lastPlayer, int lastIndex) {
    // Ignored because it was the local player
    if (lastPlayer != myToken) return;

    _completer?.complete(lastIndex);
    _completer = null;
  }

  @override
  Future<int> requestNext(BoardSerialization data) async {
    await updateState(data);
    _completer ??= Completer();
    return _completer!.future;
  }

  @override
  void dispose() {
    _unsub?.call();
    _unsub = null;
    _completer = null;
  }
}
