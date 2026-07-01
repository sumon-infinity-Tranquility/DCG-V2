import 'package:flutter/material.dart';

import '../../core/theme/dcg_theme.dart';
import '../../core/validators.dart';
import '../../models/dcg_user.dart';
import '../../services/auth_exception.dart';
import '../../services/auth_repository.dart';
import '../../widgets/shared_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.authRepository, required this.onSignedIn, super.key});

  final AuthRepository authRepository;
  final ValueChanged<DcgUser> onSignedIn;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: 'Campus Responder');
  final emailController = TextEditingController(text: 'responder@diu.edu.bd');
  final passwordController = TextEditingController(text: '123456');
  final phoneController = TextEditingController(text: '+8801713493050');
  bool createAccount = false;
  bool showPassword = false;
  bool busy = false;
  int roleIndex = 0;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => busy = true);
    try {
      final user = createAccount
          ? await widget.authRepository.signUp(
              name: nameController.text,
              email: emailController.text,
              password: passwordController.text,
              role: roles[roleIndex],
              phone: phoneController.text,
            )
          : await widget.authRepository.signIn(
              email: emailController.text,
              password: passwordController.text,
            );
      widget.onSignedIn(user);
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  static const roles = ['Responder', 'Student', 'Staff'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
          children: [
            const BrandLockup(),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: LiveBadge(
                text: widget.authRepository.providerLabel,
                muted: !widget.authRepository.isFirebaseBacked,
              ),
            ),
            const SizedBox(height: 24),
            AppCard(
              color: DcgTheme.slate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: DcgTheme.accent, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.sos_rounded, color: Colors.white),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Fast campus emergency response',
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, height: 1.05),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sign in, trigger SOS, submit reports, and coordinate responders from one mobile app.',
                    style: TextStyle(color: Color(0xFFDDE2EF), height: 1.45),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      MiniStat(label: 'Teams', value: '6'),
                      SizedBox(width: 10),
                      MiniStat(label: 'Avg', value: '4m'),
                      SizedBox(width: 10),
                      MiniStat(label: 'Live', value: '24/7'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            AppCard(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      child: Text(
                        createAccount ? 'Create account' : 'Sign in',
                        key: ValueKey(createAccount),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SegmentedButton<int>(
                      segments: [
                        for (var i = 0; i < roles.length; i++) ButtonSegment(value: i, label: Text(roles[i])),
                      ],
                      selected: {roleIndex},
                      onSelectionChanged: (value) => setState(() => roleIndex = value.first),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) => createAccount ? requiredValidator(value) : null,
                    ),
                    const SizedBox(height: 12),
                    if (createAccount) ...[
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.call_rounded)),
                        validator: requiredValidator,
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_rounded)),
                      validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_rounded),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => showPassword = !showPassword),
                          icon: Icon(showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                        ),
                      ),
                      validator: (value) => value != null && value.length >= 6 ? null : 'Use at least 6 characters',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: busy ? null : submit,
                      child: busy
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(createAccount ? 'Create and continue' : 'Sign in'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: busy || widget.authRepository.isFirebaseBacked
                          ? null
                          : () async {
                              setState(() => busy = true);
                              try {
                                final user = await widget.authRepository.continueDemo(
                                  name: nameController.text,
                                  email: emailController.text,
                                  role: roles[roleIndex],
                                  phone: phoneController.text,
                                );
                                widget.onSignedIn(user);
                              } on AuthException catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
                              } finally {
                                if (mounted) setState(() => busy = false);
                              }
                            },
                      icon: const Icon(Icons.offline_bolt_rounded),
                      label: Text(widget.authRepository.isFirebaseBacked ? 'Firebase email auth enabled' : 'Continue demo session'),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => setState(() {
                          createAccount = !createAccount;
                          if (createAccount && emailController.text == 'responder@diu.edu.bd') {
                            emailController.text = '';
                            passwordController.text = '';
                          }
                        }),
                        child: Text(createAccount ? 'Already have an account?' : 'Create a new account'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
