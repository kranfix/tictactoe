// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDs8rXGG-gtDpu8atuCqVCcdl48U5HZfJw',
    appId: '1:1085432450848:web:b12fd55accc18f4cc71145',
    messagingSenderId: '1085432450848',
    projectId: 'tictactoe-50bcd',
    authDomain: 'tictactoe-50bcd.firebaseapp.com',
    storageBucket: 'tictactoe-50bcd.appspot.com',
    measurementId: 'G-5X2KEG46GC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAoQJkROp6mDZIOa7Q6KXs-Wu9db3lt_oA',
    appId: '1:1085432450848:android:d5035553cfd29594c71145',
    messagingSenderId: '1085432450848',
    projectId: 'tictactoe-50bcd',
    storageBucket: 'tictactoe-50bcd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDHHBT3P7E9ccfHHhC9-sP2wIOqTt_r3mw',
    appId: '1:1085432450848:ios:868cc25f0893b3b8c71145',
    messagingSenderId: '1085432450848',
    projectId: 'tictactoe-50bcd',
    storageBucket: 'tictactoe-50bcd.appspot.com',
    iosBundleId: 'dev.kranfix.ticTacToeFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDHHBT3P7E9ccfHHhC9-sP2wIOqTt_r3mw',
    appId: '1:1085432450848:ios:868cc25f0893b3b8c71145',
    messagingSenderId: '1085432450848',
    projectId: 'tictactoe-50bcd',
    storageBucket: 'tictactoe-50bcd.appspot.com',
    iosBundleId: 'dev.kranfix.ticTacToeFlutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDs8rXGG-gtDpu8atuCqVCcdl48U5HZfJw',
    appId: '1:1085432450848:web:c704cfae2db595cbc71145',
    messagingSenderId: '1085432450848',
    projectId: 'tictactoe-50bcd',
    authDomain: 'tictactoe-50bcd.firebaseapp.com',
    storageBucket: 'tictactoe-50bcd.appspot.com',
    measurementId: 'G-WHE3FX26Y5',
  );
}
