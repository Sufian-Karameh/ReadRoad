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
    apiKey: 'AIzaSyBK5H2c99MWTullyeRzAzey6LhB1p9ZNSw',
    appId: '1:48656043273:web:6aa33c66116f71c78857d8',
    messagingSenderId: '48656043273',
    projectId: 'readroadsufian',
    authDomain: 'readroadsufian.firebaseapp.com',
    storageBucket: 'readroadsufian.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnF7RiNSUmlPRFBs6xdsNvtODr4coUOqw',
    appId: '1:48656043273:ios:369eab563d5d909a8857d8',
    messagingSenderId: '48656043273',
    projectId: 'readroadsufian',
    storageBucket: 'readroadsufian.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnF7RiNSUmlPRFBs6xdsNvtODr4coUOqw',
    appId: '1:48656043273:ios:369eab563d5d909a8857d8',
    messagingSenderId: '48656043273',
    projectId: 'readroadsufian',
    storageBucket: 'readroadsufian.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-cF8gCV0VshHnFzvTUGzRAAXF24MWeUQ',
    appId: '1:48656043273:android:2607e2a052805c088857d8',
    messagingSenderId: '48656043273',
    projectId: 'readroadsufian',
    storageBucket: 'readroadsufian.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBK5H2c99MWTullyeRzAzey6LhB1p9ZNSw',
    appId: '1:48656043273:web:30274f15916d29b38857d8',
    messagingSenderId: '48656043273',
    projectId: 'readroadsufian',
    authDomain: 'readroadsufian.firebaseapp.com',
    storageBucket: 'readroadsufian.appspot.com',
  );

}