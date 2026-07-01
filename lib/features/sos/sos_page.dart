import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/dcg_theme.dart';
import '../../data/emergency_data.dart';
import '../../models/case_status.dart';
import '../../models/dcg_case.dart';
import '../../models/priority.dart';
import '../../widgets/shared_widgets.dart';

class SosPage extends StatefulWidget {
  const SosPage({required this.responderName, required this.onCreateCase, super.key});

  final String responderName;
  final ValueChanged<DcgCase> onCreateCase;

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> with SingleTickerProviderStateMixin {
  late final AnimationController pulseController;
  Timer? holdTimer;
  double holdProgress = 0;
  bool calling = false;
  String selectedCategory = categories.first.name;
  final timeline = <String>[
    'Ready to share campus location',
    'Emergency contacts standing by',
    'Nearest help centre available',
  ];

  @override
  void initState() {
    super.initState();
    pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    holdTimer?.cancel();
    pulseController.dispose();
    super.dispose();
  }

  void startHold() {
    if (holdTimer != null) return;
    setState(() {
      calling = true;
      holdProgress = 0;
    });
    holdTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      setState(() => holdProgress = (holdProgress + 0.02).clamp(0, 1));
      if (holdProgress >= 1) finishHold();
    });
  }

  void cancelHold() {
    if (holdProgress >= 1) return;
    holdTimer?.cancel();
    holdTimer = null;
    setState(() {
      calling = false;
      holdProgress = 0;
    });
  }

  void finishHold() {
    holdTimer?.cancel();
    holdTimer = null;
    final dcgCase = DcgCase(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: widget.responderName,
      contact: '+8801713493050',
      role: 'Responder',
      category: selectedCategory,
      location: 'Live campus location',
      priority: Priority.critical,
      status: CaseStatus.open,
      details: 'SOS triggered. Live location shared with nearest help centre and emergency contacts.',
      createdAt: DateTime.now(),
    );
    widget.onCreateCase(dcgCase);
    setState(() {
      calling = false;
      holdProgress = 0;
      timeline.insert(0, 'Critical $selectedCategory case created now');
      timeline.insert(1, 'Location sent to Proctor Office');
    });
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SosResultSheet(category: selectedCategory),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('SOS Emergency', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text('Choose the emergency type, then hold the SOS button until the ring completes.',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 18),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              final selected = selectedCategory == category.name;
              return ChoiceChip(
                selected: selected,
                avatar: Icon(category.icon, size: 18),
                label: Text(category.name),
                onSelected: (_) => setState(() => selectedCategory = category.name),
              );
            },
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: GestureDetector(
            onTapDown: (_) => startHold(),
            onTapCancel: cancelHold,
            onTapUp: (_) => cancelHold(),
            child: AnimatedBuilder(
              animation: pulseController,
              builder: (context, child) {
                return CustomPaint(
                  painter: SosPulsePainter(
                    pulse: pulseController.value,
                    progress: holdProgress,
                    calling: calling,
                  ),
                  child: child,
                );
              },
              child: AnimatedScale(
                duration: const Duration(milliseconds: 160),
                scale: calling ? 0.96 : 1,
                child: Container(
                  width: 238,
                  height: 238,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: DcgTheme.accent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        calling ? '${(holdProgress * 100).round()}%' : 'SOS',
                        style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        calling ? 'Keep holding' : 'Press and hold',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Live response timeline', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              for (var i = 0; i < math.min(timeline.length, 5); i++)
                TimelineRow(text: timeline[i], active: i == 0),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          color: DcgTheme.accentSoft,
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded, color: DcgTheme.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Demo map: live campus location, nearest help centre, and emergency contacts are simulated here.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
