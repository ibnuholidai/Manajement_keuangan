// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBP0Xi_7dX-74IGpZtEwu8J6KUMAvEN_eU',
    appId: '1:504140817965:web:25204c32675a9f01177aa4',
    messagingSenderId: '504140817965',
    projectId: 'mitra-abadi-sejahtera',
    authDomain: 'mitra-abadi-sejahtera.firebaseapp.com',
    databaseURL: 'https://mitra-abadi-sejahtera-default-rtdb.firebaseio.com',
    storageBucket: 'mitra-abadi-sejahtera.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1Vc8EgS7Zf1va0jYCYD03TrNCsDVxyeA',
    appId: '1:504140817965:android:4c1b6432e7117804177aa4',
    messagingSenderId: '504140817965',
    projectId: 'mitra-abadi-sejahtera',
    databaseURL: 'https://mitra-abadi-sejahtera-default-rtdb.firebaseio.com',
    storageBucket: 'mitra-abadi-sejahtera.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUo--rI9AasAwekfTZ5YeO7SYgBaDsDkM',
    appId: '1:504140817965:ios:d56cb090dc209468177aa4',
    messagingSenderId: '504140817965',
    projectId: 'mitra-abadi-sejahtera',
    databaseURL: 'https://mitra-abadi-sejahtera-default-rtdb.firebaseio.com',
    storageBucket: 'mitra-abadi-sejahtera.appspot.com',
    iosBundleId: 'com.example.manajementKeuangan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUo--rI9AasAwekfTZ5YeO7SYgBaDsDkM',
    appId: '1:504140817965:ios:bb1e64740d6ae213177aa4',
    messagingSenderId: '504140817965',
    projectId: 'mitra-abadi-sejahtera',
    databaseURL: 'https://mitra-abadi-sejahtera-default-rtdb.firebaseio.com',
    storageBucket: 'mitra-abadi-sejahtera.appspot.com',
    iosBundleId: 'com.example.manajementKeuangan.RunnerTests',
  );
}
