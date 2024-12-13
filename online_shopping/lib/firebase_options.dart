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
    apiKey: 'AIzaSyAtIP55XR1oZ-qgOgRt41F2Tjop_zGUMhQ',
    appId: '1:379655736815:web:31a488b1e50e1c427dfa1a',
    messagingSenderId: '379655736815',
    projectId: 'test-b6cd5',
    authDomain: 'test-b6cd5.firebaseapp.com',
    storageBucket: 'test-b6cd5.firebasestorage.app',
    measurementId: 'G-6XJFG41MWH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPuQx1Sx11M7ltZZC2qO0SYEePDVK6ApM',
    appId: '1:379655736815:android:b1be8de4a46913247dfa1a',
    messagingSenderId: '379655736815',
    projectId: 'test-b6cd5',
    storageBucket: 'test-b6cd5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFLLhDgOrk_RQKgYKZox47isVxjiOxy4M',
    appId: '1:379655736815:ios:41390d19dc8fd1f27dfa1a',
    messagingSenderId: '379655736815',
    projectId: 'test-b6cd5',
    storageBucket: 'test-b6cd5.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFLLhDgOrk_RQKgYKZox47isVxjiOxy4M',
    appId: '1:379655736815:ios:41390d19dc8fd1f27dfa1a',
    messagingSenderId: '379655736815',
    projectId: 'test-b6cd5',
    storageBucket: 'test-b6cd5.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAtIP55XR1oZ-qgOgRt41F2Tjop_zGUMhQ',
    appId: '1:379655736815:web:78e6b46978b615987dfa1a',
    messagingSenderId: '379655736815',
    projectId: 'test-b6cd5',
    authDomain: 'test-b6cd5.firebaseapp.com',
    storageBucket: 'test-b6cd5.firebasestorage.app',
    measurementId: 'G-FS3699HYPK',
  );
}