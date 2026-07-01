import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/dcg_theme.dart';
import '../models/case_status.dart';
import '../models/dcg_case.dart';
import '../models/emergency_category.dart';
import '../models/priority.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.margin,
    this.color,
    this.padding = const EdgeInsets.all(16),
    this.clip = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? DcgTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color == null ? DcgTheme.line : Colors.transparent),
        boxShadow: [
          BoxShadow(color: DcgTheme.slate.withOpacity(0.07), blurRadius: 26, offset: const Offset(0, 14)),
        ],
      ),
      child: child,
    );
  }
}

class MetricPill extends StatelessWidget {
  const MetricPill({required this.label, required this.value, this.danger = false, super.key});

  final String label;
  final String value;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: danger ? DcgTheme.accentSoft : DcgTheme.bg, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: danger ? DcgTheme.accent : DcgTheme.slate)),
        ],
      ),
    );
  }
}

class DashboardProgress extends StatelessWidget {
  const DashboardProgress({
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
            Text('${(clamped * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: 9,
            backgroundColor: const Color(0xFFEFF2F7),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({required this.category, required this.onTap, super.key});

  final EmergencyCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryIcon(category: category),
            const Spacer(),
            Text(category.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 3),
            Text(category.helpText, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({required this.category, this.size = 44, super.key});

  final EmergencyCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: category.color, borderRadius: BorderRadius.circular(14)),
      child: Icon(category.icon, color: DcgTheme.slate),
    );
  }
}

class CaseCard extends StatelessWidget {
  const CaseCard({required this.dcgCase, required this.onStatusChange, super.key});

  final DcgCase dcgCase;
  final ValueChanged<CaseStatus> onStatusChange;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(dcgCase.location, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoChip(label: dcgCase.category),
              PriorityBadge(priority: dcgCase.priority),
              InfoChip(label: dcgCase.status.label),
            ],
          ),
        ),
        children: [
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(dcgCase.details, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () => onStatusChange(CaseStatus.triage), child: const Text('Triage'))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton(onPressed: () => onStatusChange(CaseStatus.responding), child: const Text('Respond'))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: () => onStatusChange(CaseStatus.resolved), child: const Text('Done'))),
            ],
          ),
        ],
      ),
    );
  }
}

class CompactCaseTile extends StatelessWidget {
  const CompactCaseTile({required this.dcgCase, super.key});

  final DcgCase dcgCase;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          StatusDot(status: dcgCase.status),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dcgCase.location, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text('${dcgCase.category} - ${dcgCase.status.label}', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          PriorityBadge(priority: dcgCase.priority),
        ],
      ),
    );
  }
}

class PriorityBadge extends StatelessWidget {
  const PriorityBadge({required this.priority, super.key});

  final Priority priority;

  @override
  Widget build(BuildContext context) {
    final hot = priority == Priority.high || priority == Priority.critical;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: hot ? DcgTheme.danger : const Color(0xFFF4E4A7), borderRadius: BorderRadius.circular(999)),
      child: Text(
        priority.label,
        style: TextStyle(color: hot ? Colors.white : DcgTheme.slate, fontSize: 12, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  const InfoChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: const Color(0xFFEFF2F7), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
    );
  }
}

class LiveBadge extends StatelessWidget {
  const LiveBadge({required this.text, this.muted = false, super.key});

  final String text;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: muted ? const Color(0xFFEFF2F7) : const Color(0xFFE7F8F1), borderRadius: BorderRadius.circular(999)),
      child: Text(
        text,
        style: TextStyle(color: muted ? DcgTheme.muted : DcgTheme.green, fontSize: 12, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class StatusDot extends StatelessWidget {
  const StatusDot({required this.status, super.key});

  final CaseStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
    );
  }
}

class TimelineRow extends StatelessWidget {
  const TimelineRow({required this.text, required this.active, super.key});

  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(color: active ? DcgTheme.accent : const Color(0xFFEFF2F7), shape: BoxShape.circle),
            child: Icon(active ? Icons.flash_on_rounded : Icons.check_rounded, size: 15, color: active ? Colors.white : DcgTheme.muted),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}

class SosResultSheet extends StatelessWidget {
  const SosResultSheet({required this.category, super.key});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(color: DcgTheme.accentSoft, shape: BoxShape.circle),
            child: const Icon(Icons.sos_rounded, color: DcgTheme.accent),
          ),
          const SizedBox(height: 14),
          Text('Emergency request sent', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            '$category alert created. Please stand by while the nearest campus response team reviews your location.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('I understand')),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(child: Center(child: Padding(padding: const EdgeInsets.all(18), child: Text(message))));
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, this.action, this.onAction, super.key});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class MiniStat extends StatelessWidget {
  const MiniStat({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            Text(label, style: const TextStyle(color: Color(0xFFDDE2EF), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class BrandLockup extends StatelessWidget {
  const BrandLockup({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: compact ? 38 : 48,
          height: compact ? 38 : 48,
          decoration: BoxDecoration(
            color: DcgTheme.accent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              'D',
              style: TextStyle(color: Colors.white, fontSize: compact ? 18 : 24, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DCG', style: Theme.of(context).textTheme.titleLarge),
            if (!compact) Text('Daffodil CrisisGuard', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}

class SosPulsePainter extends CustomPainter {
  SosPulsePainter({required this.pulse, required this.progress, required this.calling});

  final double pulse;
  final double progress;
  final bool calling;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final ripplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = DcgTheme.accent.withOpacity(calling ? 0.22 : 0.12);

    for (var i = 0; i < 3; i++) {
      final r = radius + 10 + ((pulse + i / 3) % 1) * 36;
      canvas.drawCircle(center, r, ripplePaint..color = DcgTheme.accent.withOpacity((1 - ((pulse + i / 3) % 1)) * 0.18));
    }

    if (calling) {
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10
        ..color = DcgTheme.slate;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius + 12),
        -math.pi / 2,
        math.pi * 2 * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SosPulsePainter oldDelegate) {
    return pulse != oldDelegate.pulse || progress != oldDelegate.progress || calling != oldDelegate.calling;
  }
}
