import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';
import 'auth_repository.dart';
import 'firebase_auth_repository.dart';
import 'local_auth_repository.dart';

class AppServices {
  static Future<AuthRepository> createAuthRepository() async {
    try {
      final options = DefaultFirebaseOptions.currentPlatform;
      if (options.apiKey.startsWith('REPLACE_WITH_')) {
        return LocalAuthRepository();
      }
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: options);
      }
      return FirebaseAuthRepository(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      );
    } catch (_) {
      return LocalAuthRepository();
    }
  }
}
