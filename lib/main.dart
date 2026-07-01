import 'package:flutter/material.dart';

import 'core/theme/dcg_theme.dart';
import 'features/auth/auth_gate.dart';
import 'services/app_services.dart';
import 'services/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepository = await AppServices.createAuthRepository();
  runApp(DcgApp(authRepository: authRepository));
}

class DcgApp extends StatelessWidget {
  const DcgApp({required this.authRepository, super.key});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DCG',
      debugShowCheckedModeBanner: false,
      theme: DcgTheme.light,
      home: AuthGate(authRepository: authRepository),
    );
  }
}
