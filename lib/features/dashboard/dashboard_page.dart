import 'package:flutter/material.dart';

import '../../core/theme/dcg_theme.dart';
import '../../data/emergency_data.dart';
import '../../models/case_status.dart';
import '../../models/dcg_case.dart';
import '../../models/dcg_user.dart';
import '../../models/emergency_category.dart';
import '../../models/priority.dart';
import '../../widgets/shared_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.user,
    required this.cases,
    required this.onOpenSos,
    required this.onOpenProfile,
    required this.onSelectCategory,
    super.key,
  });

  final DcgUser user;
  final List<DcgCase> cases;
  final VoidCallback onOpenSos;
  final VoidCallback onOpenProfile;
  final ValueChanged<EmergencyCategory> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    final open = cases.where((item) => item.status != CaseStatus.resolved).length;
    final critical = cases.where((item) => item.priority == Priority.critical).length;
    final responding = cases.where((item) => item.status == CaseStatus.responding).length;
    final submittedByUser = cases.where((item) => item.name == user.name).length;
    final latest = cases.take(3).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hi, ${user.name}', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 5),
                  Text('${user.role} - ${user.department}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            LiveBadge(text: '$responding live'),
          ],
        ),
        const SizedBox(height: 18),
        AppCard(
          padding: EdgeInsets.zero,
          clip: true,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [DcgTheme.slate, Color(0xFF45516E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Need urgent help?',
                            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                          ),
                        ),
                        IconButton.filled(
                          onPressed: onOpenSos,
                          style: IconButton.styleFrom(backgroundColor: DcgTheme.accent),
                          icon: const Icon(Icons.sos_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Open SOS, choose the emergency type, then hold to alert responders.',
                      style: TextStyle(color: Color(0xFFDDE2EF), height: 1.4),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(child: MetricPill(label: 'Open', value: '$open')),
                    const SizedBox(width: 10),
                    Expanded(child: MetricPill(label: 'Critical', value: '$critical', danger: true)),
                    const SizedBox(width: 10),
                    Expanded(child: MetricPill(label: 'Mine', value: '$submittedByUser')),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        SectionTitle(title: 'Responder dashboard', action: 'Profile', onAction: onOpenProfile),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              DashboardProgress(label: 'Campus coverage', value: 0.82, color: DcgTheme.green),
              const SizedBox(height: 12),
              DashboardProgress(label: 'Critical readiness', value: critical == 0 ? 0.35 : 0.72, color: DcgTheme.accent),
              const SizedBox(height: 12),
              DashboardProgress(label: 'Case resolution', value: cases.isEmpty ? 0 : cases.where((item) => item.status == CaseStatus.resolved).length / cases.length, color: DcgTheme.blue),
            ],
          ),
        ),
        const SizedBox(height: 22),
        SectionTitle(
          title: 'What is your emergency?',
          action: 'Tap to report',
          onAction: () => onSelectCategory(categories.first),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: 142,
              child: CategoryTile(category: categories[index], onTap: () => onSelectCategory(categories[index])),
            ),
          ),
        ),
        const SizedBox(height: 22),
        SectionTitle(title: 'Latest activity', action: 'View cases', onAction: () {}),
        const SizedBox(height: 12),
        for (final item in latest) CompactCaseTile(dcgCase: item),
      ],
    );
  }
}
