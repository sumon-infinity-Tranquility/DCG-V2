import 'package:flutter/material.dart';

import '../../core/validators.dart';
import '../../data/emergency_data.dart';
import '../../models/case_status.dart';
import '../../models/dcg_case.dart';
import '../../models/priority.dart';

class ReportSheet extends StatefulWidget {
  const ReportSheet({
    required this.initialCategory,
    required this.responderName,
    required this.onSubmit,
    super.key,
  });

  final String initialCategory;
  final String responderName;
  final ValueChanged<DcgCase> onSubmit;

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final locationController = TextEditingController();
  final detailsController = TextEditingController();
  String role = 'Student';
  String category = categories.first.name;
  Priority priority = Priority.medium;

  @override
  void initState() {
    super.initState();
    category = widget.initialCategory;
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    locationController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 24),
          children: [
            Text('Submit campus report', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text('This report becomes a live case for responders.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Reporter name', prefixIcon: Icon(Icons.person_rounded)),
                    validator: requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: contactController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Contact number', prefixIcon: Icon(Icons.call_rounded)),
                    validator: requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location', prefixIcon: Icon(Icons.place_rounded)),
                    validator: requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: ['Student', 'Teacher', 'Staff', 'Alumni', 'Visitor']
                        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                    onChanged: (value) => setState(() => role = value ?? role),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categories
                        .map((item) => DropdownMenuItem(value: item.name, child: Text(item.name)))
                        .toList(),
                    onChanged: (value) => setState(() => category = value ?? category),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<Priority>(
                    segments: Priority.values
                        .map((item) => ButtonSegment(value: item, label: Text(item.label)))
                        .toList(),
                    selected: {priority},
                    onSelectionChanged: (value) => setState(() => priority = value.first),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: detailsController,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Details'),
                    validator: requiredValidator,
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      widget.onSubmit(
                        DcgCase(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          name: nameController.text,
                          contact: contactController.text,
                          role: role,
                          category: category,
                          location: locationController.text,
                          priority: priority,
                          status: CaseStatus.open,
                          details: detailsController.text,
                          createdAt: DateTime.now(),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Submit report'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
