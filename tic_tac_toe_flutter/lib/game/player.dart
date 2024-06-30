import 'dart:async';
import 'package:tic_tac_toe/domain/game_search.dart';
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
class RemotePlayer extends Player {
  RemotePlayer({
    required this.id,
    required super.myToken,
    required this.gameRepo,
  }) {
    subscribe(_onNext);
  }

  final String id;
  final GameRepo gameRepo;
  Completer<int>? _completer;

  void Function()? _unsub;

  void subscribe(
    void Function(Token lastPlayer, int lastIndex) onNext,
  ) {
    _unsub?.call();
    _unsub = null;

    final stream = gameRepo.subscribeToGame(id);
    final sub = stream.listen((game) {
      if (game != null) {
        final lastIndex = game.lastIndex;
        if (lastIndex != null) {
          onNext(game.nextPlayer, lastIndex);
        }
      }
    });

    _unsub = () => sub.cancel();
  }

  void _onNext(Token nextPlayer, int lastIndex) {
    // Ignored because it was the local player
    if (nextPlayer != myToken) return;

    _completer?.complete(lastIndex);
    _completer = null;
  }

  @override
  Future<int> requestNext(BoardSerialization data) async {
    await gameRepo.updateGame(
      id,
      board: data,
      nextPlayer: myToken,
    );
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
