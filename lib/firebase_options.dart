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
    apiKey: 'AIzaSyAWiny9pC_haOS7LEJqr4THENavy66vmgE',
    appId: '1:873332438202:web:c73ce8ae7d53b71935fe83',
    messagingSenderId: '873332438202',
    projectId: 'pet-care-6842b',
    authDomain: 'pet-care-6842b.firebaseapp.com',
    storageBucket: 'pet-care-6842b.appspot.com',
    measurementId: 'G-YEX6RTR6PJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCP8Kb2Sb_rgRx2rtZlcAdUew14DY7hUWs',
    appId: '1:873332438202:android:aa28cab6d8903b1535fe83',
    messagingSenderId: '873332438202',
    projectId: 'pet-care-6842b',
    storageBucket: 'pet-care-6842b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPJ12TI0nds6wnKI0CSKjLegfnTpG7Uwg',
    appId: '1:873332438202:ios:ad99403d9a13461435fe83',
    messagingSenderId: '873332438202',
    projectId: 'pet-care-6842b',
    storageBucket: 'pet-care-6842b.appspot.com',
    iosBundleId: 'com.example.petCare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBPJ12TI0nds6wnKI0CSKjLegfnTpG7Uwg',
    appId: '1:873332438202:ios:31057ff3cbaa9ecb35fe83',
    messagingSenderId: '873332438202',
    projectId: 'pet-care-6842b',
    storageBucket: 'pet-care-6842b.appspot.com',
    iosBundleId: 'com.example.petCare.RunnerTests',
  );
}