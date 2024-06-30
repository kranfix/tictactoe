import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tic_tac_toe_flutter/domain/domain.dart';
import 'package:tic_tac_toe_flutter/game/board.dart';

class FirestoreGameSearch extends GameRepo {
  static final colRef = FirebaseFirestore.instance.collection('tictactoe');

  @override
  Future<List<GameDescriptor>> listActiveGames() async {
    final snapshot =
        await colRef.where("status", isEqualTo: "active").limit(10).get();
    return snapshot.docs
        .map((snap) => snap.data())
        .map(GameDescriptor.fromMap)
        .toList();
  }

  @override
  Future<GameDescriptor> createGame(String name) async {
    final sanitizedName = name.trim().replaceAll(' ', '-');
    final docRef = colRef.doc();
    final selectedName = '$sanitizedName-${docRef.id.substring(0, 6)}';
    final initialGame = GameDescriptor(
      id: docRef.id,
      name: selectedName,
      board: BoardSerialization.empty(),
      nextPlayer: Token.circle,
      lastIndex: null,
      status: GameStatus.waitingForCrossPlayer,
    );
    await colRef.doc().set(initialGame.toMap());
    return initialGame;
  }

  @override
  Future<void> updateGame(
    String id, {
    BoardSerialization? board,
    Token? nextPlayer,
    int? lastIndex,
    GameStatus? status,
  }) async {
    final data = {
      if (board != null) 'board': board,
      if (nextPlayer != null) 'nextPlayer': nextPlayer.toString(),
      if (lastIndex != null) 'lastIndex': lastIndex,
      if (status != null) 'status': status.toString(),
    };
    if (data.isNotEmpty) {
      await colRef.doc(id).update(data);
    }
  }

  @override
  Stream<GameDescriptor?> subscribeToGame(String id) {
    return colRef.doc(id).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return GameDescriptor.fromMap(data);
    });
  }
}
