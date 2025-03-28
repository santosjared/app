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
    apiKey: 'AIzaSyDe5WKuLlOhdZpm2YILjsmbajhQk7xXl5I',
    appId: '1:597455666151:web:c2b33f71c6133e1e909b42',
    messagingSenderId: '597455666151',
    projectId: 'mi-laboratorio-10c78',
    authDomain: 'mi-laboratorio-10c78.firebaseapp.com',
    storageBucket: 'mi-laboratorio-10c78.firebasestorage.app',
    measurementId: 'G-JFYJ8K9W5P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBASjK72dQhOG5VaJkmHqKbI_xvX22pTh0',
    appId: '1:597455666151:android:cbafee832e8b4619909b42',
    messagingSenderId: '597455666151',
    projectId: 'mi-laboratorio-10c78',
    storageBucket: 'mi-laboratorio-10c78.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDhRvFewVB_fOxero4Zoe-zKstMEWM6B3g',
    appId: '1:597455666151:ios:4bc619d41c2b6b5e909b42',
    messagingSenderId: '597455666151',
    projectId: 'mi-laboratorio-10c78',
    storageBucket: 'mi-laboratorio-10c78.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDhRvFewVB_fOxero4Zoe-zKstMEWM6B3g',
    appId: '1:597455666151:ios:4bc619d41c2b6b5e909b42',
    messagingSenderId: '597455666151',
    projectId: 'mi-laboratorio-10c78',
    storageBucket: 'mi-laboratorio-10c78.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDmBp6Joydk2on4tEy_e_i3YTEGbNKwE9c',
    appId: '1:597455666151:web:6dd17fa4c5d0ea66909b42',
    messagingSenderId: '597455666151',
    projectId: 'mi-laboratorio-10c78',
    authDomain: 'mi-laboratorio-10c78.firebaseapp.com',
    storageBucket: 'mi-laboratorio-10c78.firebasestorage.app',
    measurementId: 'G-RBR456QSZJ',
  );
}
