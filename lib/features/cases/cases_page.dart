import 'package:flutter/material.dart';

import '../../models/case_status.dart';
import '../../models/dcg_case.dart';
import '../../widgets/shared_widgets.dart';

class CasesPage extends StatefulWidget {
  const CasesPage({required this.cases, required this.onStatusChange, super.key});

  final List<DcgCase> cases;
  final void Function(DcgCase dcgCase, CaseStatus status) onStatusChange;

  @override
  State<CasesPage> createState() => _CasesPageState();
}

class _CasesPageState extends State<CasesPage> {
  String query = '';
  CaseStatus? filterStatus;

  @override
  Widget build(BuildContext context) {
    final filtered = widget.cases.where((item) {
      final text = '${item.name} ${item.category} ${item.location} ${item.details}'.toLowerCase();
      final queryOk = query.isEmpty || text.contains(query.toLowerCase());
      final statusOk = filterStatus == null || item.status == filterStatus;
      return queryOk && statusOk;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('Cases', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: const InputDecoration(
            hintText: 'Search location, reporter, details',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                selected: filterStatus == null,
                label: const Text('All'),
                onSelected: (_) => setState(() => filterStatus = null),
              ),
              const SizedBox(width: 8),
              for (final status in CaseStatus.values) ...[
                FilterChip(
                  selected: filterStatus == status,
                  label: Text(status.label),
                  onSelected: (_) => setState(() => filterStatus = status),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (filtered.isEmpty)
          const EmptyState(message: 'No matching cases.')
        else
          ...filtered.map(
            (item) => CaseCard(
              dcgCase: item,
              onStatusChange: (status) => widget.onStatusChange(item, status),
            ),
          ),
      ],
    );
  }
}
