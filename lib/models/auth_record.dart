import 'dcg_user.dart';

class AuthRecord {
  const AuthRecord({required this.user, required this.password});

  final DcgUser user;
  final String password;
}
