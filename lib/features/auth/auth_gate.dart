import 'package:flutter/material.dart';

import '../../models/dcg_user.dart';
import '../home/dcg_home.dart';
import 'auth_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  DcgUser? currentUser;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      child: currentUser != null
          ? DcgHome(
              key: const ValueKey('home'),
              initialUser: currentUser!,
              onSignOut: () => setState(() => currentUser = null),
            )
          : AuthScreen(
              key: const ValueKey('auth'),
              onSignedIn: (user) => setState(() => currentUser = user),
            ),
    );
  }
}
