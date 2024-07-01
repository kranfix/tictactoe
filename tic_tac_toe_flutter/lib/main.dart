import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/core/feature/game/presenter/view/start_game.dart';
import 'package:tic_tac_toe/firebase_impls/firebase_impls.dart';
import 'package:tic_tac_toe/firebase_options.dart';

import 'domain/domain.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GameRepo>(create: (_) => FirestoreGameRepo()),
      ],
      child: const MaterialApp(
        title: 'Tic Tact Toe',
        home: StartGame(),
      ),
    );
  }
}
