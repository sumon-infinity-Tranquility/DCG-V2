import 'package:flutter/material.dart';

import 'core/theme/dcg_theme.dart';
import 'features/auth/auth_gate.dart';

void main() {
  runApp(const DcgApp());
}

class DcgApp extends StatelessWidget {
  const DcgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DCG',
      debugShowCheckedModeBanner: false,
      theme: DcgTheme.light,
      home: const AuthGate(),
    );
  }
}
