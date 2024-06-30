import 'package:tic_tac_toe_flutter/game/board.dart';

abstract class GameRepo {
  Future<List<GameDescriptor>> listActiveGames();

  Future<GameDescriptor> createGame(String name);
  Future<void> updateGame(
    String id, {
    BoardSerialization? board,
    Token? nextPlayer,
    int? lastIndex,
    GameStatus? status,
  });
  Stream<GameDescriptor?> subscribeToGame(String id);
}

enum GameStatus {
  waitingForCrossPlayer,
  active,
  draw,
  wonCircle,
  wonCross;

  factory GameStatus.fromString(String value) {
    for (final s in GameStatus.values) {
      if (s.toString() == value) return s;
    }
    throw Exception("Invalid Status");
  }
}

class GameDescriptor {
  const GameDescriptor({
    required this.id,
    required this.name,
    required this.board,
    required this.nextPlayer,
    required this.lastIndex,
    required this.status,
  });

  final String id;
  final String name;
  final BoardSerialization board;
  final Token nextPlayer;
  final int? lastIndex;
  final GameStatus status;

  factory GameDescriptor.fromMap(Map<String, dynamic> obj) {
    return switch (obj) {
      {
        "id": String id,
        "name": String name,
        "board": String currentBoard,
        "nextPlayer": String nextPlayer,
        "lastIndex": int? lastIndex,
        "status": String status,
      } =>
        GameDescriptor(
          id: id,
          name: name,
          board: BoardSerialization.unsafe(currentBoard),
          nextPlayer: Token.fromString(nextPlayer),
          lastIndex: lastIndex,
          status: GameStatus.fromString(status),
        ),
      _ => throw Exception('Format not satisfied')
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "board": board,
      "nextPlayer": nextPlayer.toString(),
      "lastIndex": lastIndex,
      "status": status.toString(),
    };
  }
}
