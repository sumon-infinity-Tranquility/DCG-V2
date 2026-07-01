import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../models/dcg_user.dart';
import 'auth_exception.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required firebase_auth.FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  String get providerLabel => 'Firebase connected';

  @override
  bool get isFirebaseBacked => true;

  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection('users');

  @override
  Future<DcgUser?> restoreSession() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return _loadUser(firebaseUser.uid, fallbackEmail: firebaseUser.email);
  }

  @override
  Future<DcgUser> signIn({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      return _loadUser(credential.user!.uid, fallbackEmail: credential.user!.email);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw AuthException(_messageForFirebaseAuth(error));
    }
  }

  @override
  Future<DcgUser> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      final user = DcgUser(
        name: name.trim().isEmpty ? 'Campus Responder' : name.trim(),
        email: email.trim().toLowerCase(),
        role: role,
        phone: phone.trim().isEmpty ? '+8801700000000' : phone.trim(),
        department: role == 'Student' ? 'Student Affairs' : 'Proctor Office',
      );
      await credential.user?.updateDisplayName(user.name);
      await _users.doc(credential.user!.uid).set(user.toMap(), SetOptions(merge: true));
      return user;
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw AuthException(_messageForFirebaseAuth(error));
    }
  }

  @override
  Future<DcgUser> continueDemo({
    required String name,
    required String email,
    required String role,
    required String phone,
  }) {
    throw const AuthException('Demo session is available only when Firebase is not configured.');
  }

  @override
  Future<void> updateUser(DcgUser user) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) throw const AuthException('Please sign in again to update your profile.');
    await firebaseUser.updateDisplayName(user.name);
    await _users.doc(firebaseUser.uid).set(user.toMap(), SetOptions(merge: true));
  }

  @override
  Future<void> signOut() => _auth.signOut();

  Future<DcgUser> _loadUser(String uid, {String? fallbackEmail}) async {
    final snapshot = await _users.doc(uid).get();
    if (snapshot.exists && snapshot.data() != null) {
      return DcgUser.fromMap(snapshot.data()!, fallbackEmail: fallbackEmail);
    }
    final fallback = DcgUser(
      name: _auth.currentUser?.displayName?.trim().isNotEmpty == true
          ? _auth.currentUser!.displayName!
          : 'Campus Responder',
      email: (fallbackEmail ?? _auth.currentUser?.email ?? '').trim().toLowerCase(),
      role: 'Responder',
      phone: '+8801700000000',
      department: 'Proctor Office',
    );
    await _users.doc(uid).set(fallback.toMap(), SetOptions(merge: true));
    return fallback;
  }

  String _messageForFirebaseAuth(firebase_auth.FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'An account already exists. Please sign in.';
      case 'invalid-credential':
      case 'wrong-password':
        return 'Email or password is incorrect.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'weak-password':
        return 'Use a stronger password.';
      default:
        return error.message ?? 'Authentication failed.';
    }
  }
}
