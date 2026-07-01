import '../models/auth_record.dart';
import '../models/dcg_user.dart';
import 'auth_exception.dart';

class DemoAuthStore {
  static final Map<String, AuthRecord> _records = {
    'responder@diu.edu.bd': const AuthRecord(
      password: '123456',
      user: DcgUser(
        name: 'Campus Responder',
        email: 'responder@diu.edu.bd',
        role: 'Responder',
        phone: '+8801713493050',
        department: 'Proctor Office',
      ),
    ),
  };

  static String normalize(String email) => email.trim().toLowerCase();

  static DcgUser signIn({required String email, required String password}) {
    final record = _records[normalize(email)];
    if (record == null) {
      throw const AuthException('No account found for this email.');
    }
    if (record.password != password) {
      throw const AuthException('Password does not match.');
    }
    return record.user;
  }

  static DcgUser signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
  }) {
    final key = normalize(email);
    if (_records.containsKey(key)) {
      throw const AuthException('An account already exists. Please sign in.');
    }
    final user = DcgUser(
      name: name.trim().isEmpty ? 'Campus Responder' : name.trim(),
      email: key,
      role: role,
      phone: phone.trim().isEmpty ? '+8801700000000' : phone.trim(),
      department: role == 'Student' ? 'Student Affairs' : 'Proctor Office',
    );
    _records[key] = AuthRecord(user: user, password: password);
    return user;
  }

  static void updateUser(DcgUser user) {
    final key = normalize(user.email);
    final current = _records[key];
    _records[key] = AuthRecord(user: user, password: current?.password ?? '123456');
  }
}
