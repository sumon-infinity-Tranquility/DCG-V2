import 'package:flutter/material.dart';

import '../../models/dcg_user.dart';
import '../../services/auth_exception.dart';
import '../../services/auth_repository.dart';
import '../home/dcg_home.dart';
import 'auth_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({required this.authRepository, super.key});

  final AuthRepository authRepository;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  DcgUser? currentUser;
  bool restoringSession = true;

  @override
  void initState() {
    super.initState();
    restoreSession();
  }

  Future<void> restoreSession() async {
    DcgUser? user;
    try {
      user = await widget.authRepository.restoreSession();
    } on AuthException {
      user = null;
    }
    if (!mounted) return;
    setState(() {
      currentUser = user;
      restoringSession = false;
    });
  }

  Future<void> signOut() async {
    await widget.authRepository.signOut();
    if (!mounted) return;
    setState(() => currentUser = null);
  }

  @override
  Widget build(BuildContext context) {
    if (restoringSession) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      child: currentUser != null
          ? DcgHome(
              key: const ValueKey('home'),
              authRepository: widget.authRepository,
              initialUser: currentUser!,
              onSignOut: signOut,
            )
          : AuthScreen(
              key: const ValueKey('auth'),
              authRepository: widget.authRepository,
              onSignedIn: (user) => setState(() => currentUser = user),
            ),
    );
  }
}
