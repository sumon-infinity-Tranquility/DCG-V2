import '../models/auth_record.dart';
import '../models/dcg_user.dart';
import 'auth_exception.dart';
import 'auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository();

  final Map<String, AuthRecord> _records = {
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

  DcgUser? _currentUser;

  @override
  String get providerLabel => 'Local secure demo';

  @override
  bool get isFirebaseBacked => false;

  String normalize(String email) => email.trim().toLowerCase();

  @override
  Future<DcgUser?> restoreSession() async => _currentUser;

  @override
  Future<DcgUser> signIn({required String email, required String password}) async {
    final record = _records[normalize(email)];
    if (record == null) {
      throw const AuthException('No account found for this email.');
    }
    if (record.password != password) {
      throw const AuthException('Password does not match.');
    }
    _currentUser = record.user;
    return record.user;
  }

  @override
  Future<DcgUser> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
  }) async {
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
    _currentUser = user;
    return user;
  }

  @override
  Future<DcgUser> continueDemo({
    required String name,
    required String email,
    required String role,
    required String phone,
  }) async {
    final user = DcgUser(
      name: name.trim().isEmpty ? 'Demo Responder' : name.trim(),
      email: normalize(email.trim().isEmpty ? 'demo@diu.edu.bd' : email),
      role: role,
      phone: phone.trim().isEmpty ? '+8801700000000' : phone.trim(),
      department: 'Demo Session',
    );
    _records[user.email] = AuthRecord(user: user, password: '123456');
    _currentUser = user;
    return user;
  }

  @override
  Future<void> updateUser(DcgUser user) async {
    final key = normalize(user.email);
    final current = _records[key];
    _records[key] = AuthRecord(user: user, password: current?.password ?? '123456');
    _currentUser = user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}
