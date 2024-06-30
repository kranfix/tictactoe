import 'package:tic_tac_toe_flutter/lib.dart';

class FirebaseRemotePlayer extends RemotePlayer {
  FirebaseRemotePlayer({required super.myToken});

  @override
  void Function() subscribe(
      void Function(Token lastPlayer, int lastIndex) onNext) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  Future<void> updateState(BoardSerialization board) {
    // TODO: implement updateState
    throw UnimplementedError();
  }
}
