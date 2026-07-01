import 'package:flutter/material.dart';

import '../../core/theme/dcg_theme.dart';
import '../../core/validators.dart';
import '../../models/case_status.dart';
import '../../models/dcg_case.dart';
import '../../models/dcg_user.dart';
import '../../widgets/shared_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.user,
    required this.cases,
    required this.onSave,
    required this.onSignOut,
    super.key,
  });

  final DcgUser user;
  final List<DcgCase> cases;
  final Future<void> Function(DcgUser user) onSave;
  final Future<void> Function() onSignOut;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController departmentController;
  late String role;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    departmentController = TextEditingController(text: widget.user.department);
    role = widget.user.role;
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user != widget.user) {
      nameController.text = widget.user.name;
      emailController.text = widget.user.email;
      phoneController.text = widget.user.phone;
      departmentController.text = widget.user.department;
      role = widget.user.role;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myCases = widget.cases.where((item) => item.name == widget.user.name).length;
    final resolved = widget.cases.where((item) => item.updatedBy == widget.user.name && item.status == CaseStatus.resolved).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('User profile', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text('Manage responder identity and account details for the app session.',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 18),
        AppCard(
          color: DcgTheme.slate,
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: DcgTheme.accent,
                child: Text(
                  widget.user.name.isEmpty ? 'D' : widget.user.name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.user.name,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text('${widget.user.role} - ${widget.user.department}',
                        style: const TextStyle(color: Color(0xFFDDE2EF))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: MetricPill(label: 'My reports', value: '$myCases')),
            const SizedBox(width: 10),
            Expanded(child: MetricPill(label: 'Resolved', value: '$resolved')),
            const SizedBox(width: 10),
            const Expanded(child: MetricPill(label: 'Trust', value: 'A+')),
          ],
        ),
        const SizedBox(height: 18),
        AppCard(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_rounded)),
                  validator: requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_rounded)),
                  validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.call_rounded)),
                  validator: requiredValidator,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: ['Responder', 'Student', 'Staff']
                      .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) => setState(() => role = value ?? role),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: departmentController,
                  decoration: const InputDecoration(labelText: 'Department', prefixIcon: Icon(Icons.apartment_rounded)),
                  validator: requiredValidator,
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: saving
                      ? null
                      : () async {
                          if (!(formKey.currentState?.validate() ?? false)) return;
                          setState(() => saving = true);
                          try {
                            await widget.onSave(
                              widget.user.copyWith(
                                name: nameController.text.trim(),
                                email: emailController.text.trim().toLowerCase(),
                                role: role,
                                phone: phoneController.text.trim(),
                                department: departmentController.text.trim(),
                              ),
                            );
                          } finally {
                            if (mounted) setState(() => saving = false);
                          }
                        },
                  icon: saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(saving ? 'Saving profile' : 'Save profile'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: widget.onSignOut,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
