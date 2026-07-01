import 'package:flutter/material.dart';

import '../../data/emergency_data.dart';
import '../../widgets/shared_widgets.dart';

class ReportHubPage extends StatelessWidget {
  const ReportHubPage({required this.onStartReport, super.key});

  final ValueChanged<String> onStartReport;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('Quick report', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text('Pick a category to open a focused report form.', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 18),
        for (final category in categories)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onStartReport(category.name),
              child: AppCard(
                child: Row(
                  children: [
                    CategoryIcon(category: category, size: 52),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.name, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(category.helpText, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
