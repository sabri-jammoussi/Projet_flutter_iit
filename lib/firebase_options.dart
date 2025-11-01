// File: lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyB8PjHJAFsIZ_4lWbsUiAGcyTI46VKW1Mg',
      appId: '1:75752383317:android:c8aafddefdbfdac4f805dc',
      messagingSenderId: '75752383317',
      projectId: 'dentiste2-4e76b',
      storageBucket: 'dentiste2-4e76b.firebasestorage.app',
    );
  }
}
