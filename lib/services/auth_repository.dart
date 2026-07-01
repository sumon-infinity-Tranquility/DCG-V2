import '../models/dcg_user.dart';

abstract class AuthRepository {
  String get providerLabel;

  bool get isFirebaseBacked;

  Future<DcgUser?> restoreSession();

  Future<DcgUser> signIn({required String email, required String password});

  Future<DcgUser> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
  });

  Future<DcgUser> continueDemo({
    required String name,
    required String email,
    required String role,
    required String phone,
  });

  Future<void> updateUser(DcgUser user);

  Future<void> signOut();
}
