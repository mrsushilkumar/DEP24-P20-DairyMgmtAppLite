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
    apiKey: 'AIzaSyAt0_9gr0EIyM4YRKSgUqR2Qt_tG0zs6uI',
    appId: '1:856392093031:web:0de39960e0aeb7dc33b3c2',
    messagingSenderId: '856392093031',
    projectId: 'farm-expense-management-cp',
    authDomain: 'farm-expense-management-cp.firebaseapp.com',
    storageBucket: 'farm-expense-management-cp.appspot.com',
    measurementId: 'G-4CMTQM9SE3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyALWWg6zUU0KsjClXs9SvX_5q30tOLMTSw',
    appId: '1:856392093031:android:edbd56a8d78133bf33b3c2',
    messagingSenderId: '856392093031',
    projectId: 'farm-expense-management-cp',
    storageBucket: 'farm-expense-management-cp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEBroxwravOFvgMLexWrAWPrmMzvvYD0w',
    appId: '1:856392093031:ios:b3ec6d3c92f45aa533b3c2',
    messagingSenderId: '856392093031',
    projectId: 'farm-expense-management-cp',
    storageBucket: 'farm-expense-management-cp.appspot.com',
    iosBundleId: 'com.example.farmExpenseMangementApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEBroxwravOFvgMLexWrAWPrmMzvvYD0w',
    appId: '1:856392093031:ios:537a36e9dcad893433b3c2',
    messagingSenderId: '856392093031',
    projectId: 'farm-expense-management-cp',
    storageBucket: 'farm-expense-management-cp.appspot.com',
    iosBundleId: 'com.example.farmExpenseMangementApp.RunnerTests',
  );
}