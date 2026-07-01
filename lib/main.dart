import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const DcgApp());
}

class DcgApp extends StatelessWidget {
  const DcgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DCG',
      debugShowCheckedModeBanner: false,
      theme: DcgTheme.light,
      home: const AuthGate(),
    );
  }
}

class DcgTheme {
  static const bg = Color(0xFFF5F5FA);
  static const surface = Color(0xFFFFFFFF);
  static const slate = Color(0xFF313A51);
  static const muted = Color(0xFF737A8C);
  static const line = Color(0xFFE3E6EE);
  static const accent = Color(0xFFFF8852);
  static const danger = Color(0xFFE34242);
  static const green = Color(0xFF0F9F6E);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.light,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: colorScheme.copyWith(
        primary: accent,
        secondary: slate,
        error: danger,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: slate),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: slate),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: slate),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: slate),
        bodyLarge: TextStyle(fontSize: 15, height: 1.45, color: slate),
        bodyMedium: TextStyle(fontSize: 13, height: 1.45, color: muted),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          elevation: 0,
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          foregroundColor: slate,
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

enum CaseStatus { open, triage, resolved }

enum Priority { low, medium, high, critical }

class EmergencyCategory {
  const EmergencyCategory(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;
}

class DcgCase {
  DcgCase({
    required this.id,
    required this.name,
    required this.contact,
    required this.role,
    required this.category,
    required this.location,
    required this.priority,
    required this.status,
    required this.details,
    required this.createdAt,
    this.updatedAt,
    this.updatedBy,
  });

  final String id;
  final String name;
  final String contact;
  final String role;
  final String category;
  final String location;
  final Priority priority;
  CaseStatus status;
  final String details;
  final DateTime createdAt;
  DateTime? updatedAt;
  String? updatedBy;
}

const categories = [
  EmergencyCategory('Medical', Icons.medical_services_rounded, Color(0xFFDCE991)),
  EmergencyCategory('Violence', Icons.warning_amber_rounded, Color(0xFFF5A6DF)),
  EmergencyCategory('Rescue', Icons.volunteer_activism_rounded, Color(0xFFF5E8A6)),
  EmergencyCategory('Fire', Icons.local_fire_department_rounded, Color(0xFFF5A6A6)),
  EmergencyCategory('Natural disaster', Icons.storm_rounded, Color(0xFFA6F5D4)),
  EmergencyCategory('Accident', Icons.car_crash_rounded, Color(0xFFD4CEF9)),
];

final seedCases = <DcgCase>[
  DcgCase(
    id: '1',
    name: 'Proctor Office',
    contact: '+8801713493050',
    role: 'Safety team',
    category: 'Violence',
    location: 'Main Campus Gate',
    priority: Priority.high,
    status: CaseStatus.triage,
    details: 'Crowd pressure reported near the gate. Safety team is monitoring.',
    createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
  ),
  DcgCase(
    id: '2',
    name: 'Transport Desk',
    contact: '+8801811110001',
    role: 'Staff',
    category: 'Accident',
    location: 'Bus Stand',
    priority: Priority.medium,
    status: CaseStatus.open,
    details: 'Minor transport incident reported. Route support requested.',
    createdAt: DateTime.now().subtract(const Duration(minutes: 24)),
  ),
  DcgCase(
    id: '3',
    name: 'Medical Center',
    contact: '+8801847334655',
    role: 'Staff',
    category: 'Medical',
    location: 'Knowledge Tower',
    priority: Priority.low,
    status: CaseStatus.resolved,
    details: 'First-aid support completed on level 2.',
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
];

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool signedIn = false;
  String responderName = 'Campus Responder';

  @override
  Widget build(BuildContext context) {
    if (signedIn) {
      return DcgHome(
        responderName: responderName,
        onSignOut: () => setState(() => signedIn = false),
      );
    }

    return AuthScreen(
      onSignedIn: (name) {
        setState(() {
          responderName = name.trim().isEmpty ? 'Campus Responder' : name.trim();
          signedIn = true;
        });
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.onSignedIn, super.key});

  final ValueChanged<String> onSignedIn;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: 'Campus Responder');
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool createAccount = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BrandHeader(),
                  const SizedBox(height: 28),
                  Text(
                    createAccount ? 'Create responder account' : 'Welcome back',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to manage SOS alerts, campus cases, and emergency contacts.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  AppCard(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Responder name'),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Password'),
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Use at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                widget.onSignedIn(nameController.text);
                              }
                            },
                            child: Text(createAccount ? 'Create account' : 'Sign in'),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () => widget.onSignedIn(nameController.text),
                            icon: const Icon(Icons.g_mobiledata_rounded),
                            label: const Text('Continue with Google'),
                          ),
                          TextButton(
                            onPressed: () => setState(() => createAccount = !createAccount),
                            child: Text(createAccount ? 'Already have an account?' : 'Create new account'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const AuthNote(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DcgHome extends StatefulWidget {
  const DcgHome({
    required this.responderName,
    required this.onSignOut,
    super.key,
  });

  final String responderName;
  final VoidCallback onSignOut;

  @override
  State<DcgHome> createState() => _DcgHomeState();
}

class _DcgHomeState extends State<DcgHome> {
  int tabIndex = 0;
  final cases = List<DcgCase>.from(seedCases);

  void addCase(DcgCase dcgCase) {
    setState(() => cases.insert(0, dcgCase));
  }

  void updateStatus(DcgCase dcgCase, CaseStatus status) {
    setState(() {
      dcgCase.status = status;
      dcgCase.updatedAt = DateTime.now();
      dcgCase.updatedBy = widget.responderName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        responderName: widget.responderName,
        cases: cases,
        onOpenSos: () => setState(() => tabIndex = 1),
        onSelectCategory: (category) => showReportSheet(context, category.name),
      ),
      SosPage(
        responderName: widget.responderName,
        onCreateCase: addCase,
      ),
      CasesPage(
        cases: cases,
        onStatusChange: updateStatus,
        onAddReport: () => showReportSheet(context, categories.first.name),
      ),
      ContactsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DcgTheme.bg,
        elevation: 0,
        titleSpacing: 20,
        title: const _BrandHeader(compact: true),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: widget.onSignOut,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: pages[tabIndex],
      floatingActionButton: tabIndex == 2
          ? FloatingActionButton.extended(
              onPressed: () => showReportSheet(context, categories.first.name),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Report'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (index) => setState(() => tabIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.sos_rounded), label: 'SOS'),
          NavigationDestination(icon: Icon(Icons.view_kanban_rounded), label: 'Cases'),
          NavigationDestination(icon: Icon(Icons.call_rounded), label: 'Contacts'),
        ],
      ),
    );
  }

  Future<void> showReportSheet(BuildContext context, String category) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => ReportSheet(
        initialCategory: category,
        responderName: widget.responderName,
        onSubmit: addCase,
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.responderName,
    required this.cases,
    required this.onOpenSos,
    required this.onSelectCategory,
    super.key,
  });

  final String responderName;
  final List<DcgCase> cases;
  final VoidCallback onOpenSos;
  final ValueChanged<EmergencyCategory> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    final open = cases.where((item) => item.status != CaseStatus.resolved).length;
    final critical = cases.where((item) => item.priority == Priority.critical).length;
    final resolved = cases.where((item) => item.status == CaseStatus.resolved).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text('Hi, $responderName', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text('Stay ready. DCG is monitoring campus response signals.', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(child: MetricCard(label: 'Open', value: '$open')),
            const SizedBox(width: 12),
            Expanded(child: MetricCard(label: 'Critical', value: '$critical', accent: true)),
            const SizedBox(width: 12),
            Expanded(child: MetricCard(label: 'Done', value: '$resolved')),
          ],
        ),
        const SizedBox(height: 18),
        AppCard(
          color: DcgTheme.slate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you in an emergency?',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22),
              ),
              const SizedBox(height: 8),
              const Text(
                'Press SOS to share your live campus location with the nearest help centre.',
                style: TextStyle(color: Color(0xFFDDE1EB), height: 1.4),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onOpenSos,
                icon: const Icon(Icons.sos_rounded),
                label: const Text('Open SOS'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text('What is your emergency?', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: categories.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryTile(
              category: category,
              onTap: () => onSelectCategory(category),
            );
          },
        ),
      ],
    );
  }
}

class SosPage extends StatefulWidget {
  const SosPage({
    required this.responderName,
    required this.onCreateCase,
    super.key,
  });

  final String responderName;
  final ValueChanged<DcgCase> onCreateCase;

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  Timer? timer;
  int seconds = 3;
  bool calling = false;
  String selectedCategory = categories.first.name;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startHold() {
    if (timer != null) return;
    setState(() {
      seconds = 3;
      calling = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds <= 1) {
        finishHold();
      } else {
        setState(() => seconds--);
      }
    });
  }

  void cancelHold() {
    timer?.cancel();
    timer = null;
    if (mounted && calling) {
      setState(() {
        calling = false;
        seconds = 3;
      });
    }
  }

  void finishHold() {
    timer?.cancel();
    timer = null;
    final dcgCase = DcgCase(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: widget.responderName,
      contact: '+8801713493050',
      role: 'Responder',
      category: selectedCategory,
      location: 'Current campus location',
      priority: Priority.critical,
      status: CaseStatus.open,
      details: 'SOS triggered. Live campus location shared with nearest help centre and emergency contacts.',
      createdAt: DateTime.now(),
    );
    widget.onCreateCase(dcgCase);
    setState(() => calling = false);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calling Emergency...'),
        content: const Text(
          'Please stand by. DCG has created a critical alert for campus responders and emergency contacts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text('SOS Emergency', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Hold the SOS button for 3 seconds. Your emergency category and live location will be shared.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final selected = category.name == selectedCategory;
            return ChoiceChip(
              selected: selected,
              label: Text(category.name),
              avatar: Icon(category.icon, size: 18),
              onSelected: (_) => setState(() => selectedCategory = category.name),
            );
          }).toList(),
        ),
        const SizedBox(height: 34),
        Center(
          child: GestureDetector(
            onLongPressStart: (_) => startHold(),
            onLongPressEnd: (_) => cancelHold(),
            onTapDown: (_) => startHold(),
            onTapUp: (_) => cancelHold(),
            onTapCancel: cancelHold,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 160),
              scale: calling ? 0.96 : 1,
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: DcgTheme.accent,
                  border: Border.all(color: Colors.white, width: 16),
                  boxShadow: [
                    BoxShadow(
                      color: DcgTheme.accent.withOpacity(0.34),
                      blurRadius: 42,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      calling ? '$seconds' : 'SOS',
                      style: const TextStyle(color: Colors.white, fontSize: 54, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      calling ? 'Keep holding' : 'Hold 3 seconds',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        AppCard(
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFEFF2F7),
                child: Icon(Icons.location_on_rounded, color: DcgTheme.slate),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Standby mode: nearest help centre and emergency contacts receive your alert.',
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

class CasesPage extends StatefulWidget {
  const CasesPage({
    required this.cases,
    required this.onStatusChange,
    required this.onAddReport,
    super.key,
  });

  final List<DcgCase> cases;
  final void Function(DcgCase dcgCase, CaseStatus status) onStatusChange;
  final VoidCallback onAddReport;

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
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
      children: [
        Row(
          children: [
            Expanded(child: Text('Cases', style: Theme.of(context).textTheme.headlineMedium)),
            IconButton.filled(
              onPressed: widget.onAddReport,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
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

class ContactsPage extends StatelessWidget {
  ContactsPage({super.key});

  final contacts = const [
    ('Proctor Office', 'Campus discipline and response', '+8801713493050'),
    ('Medical Center', 'First aid and ambulance support', '+8801847334655'),
    ('Security Control', 'Gate, building, and night patrol', '+8801912400700'),
    ('Transport Desk', 'Campus transport and route help', '+8801811110001'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text('Emergency contacts', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text('Quick access to verified campus response channels.', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 18),
        for (final contact in contacts)
          AppCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFEFF2F7),
                  child: Icon(Icons.call_rounded, color: DcgTheme.slate),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contact.$1, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 3),
                      Text(contact.$2, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 3),
                      Text(contact.$3, style: const TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${contact.$3} copied')),
                  ),
                  icon: const Icon(Icons.copy_rounded),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Submit campus report', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Reporter name'),
                  validator: requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Contact number'),
                  validator: requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
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
                DropdownButtonFormField<Priority>(
                  value: priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: Priority.values
                      .map((item) => DropdownMenuItem(value: item, child: Text(item.label)))
                      .toList(),
                  onChanged: (value) => setState(() => priority = value ?? priority),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report submitted')),
                    );
                  },
                  child: const Text('Submit report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Required';
  return null;
}

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.margin,
    this.color,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? DcgTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color == null ? DcgTheme.line : Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: DcgTheme.slate.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.label,
    required this.value,
    this.accent = false,
    super.key,
  });

  final String label;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: accent ? const Color(0xFFFFF1EA) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: accent ? DcgTheme.accent : DcgTheme.slate,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.category,
    required this.onTap,
    super.key,
  });

  final EmergencyCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: AppCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(category.icon, color: DcgTheme.slate),
            ),
            const SizedBox(height: 10),
            Text(category.name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class CaseCard extends StatelessWidget {
  const CaseCard({
    required this.dcgCase,
    required this.onStatusChange,
    super.key,
  });

  final DcgCase dcgCase;
  final ValueChanged<CaseStatus> onStatusChange;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(dcgCase.location, style: Theme.of(context).textTheme.titleLarge)),
              PriorityBadge(priority: dcgCase.priority),
            ],
          ),
          const SizedBox(height: 8),
          Text(dcgCase.details, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoChip(label: dcgCase.category),
              InfoChip(label: dcgCase.role),
              InfoChip(label: dcgCase.status.label),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onStatusChange(CaseStatus.triage),
                  child: const Text('Triage'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onStatusChange(CaseStatus.resolved),
                  child: const Text('Resolve'),
                ),
              ),
            ],
          ),
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
    final isHot = priority == Priority.high || priority == Priority.critical;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isHot ? DcgTheme.danger : const Color(0xFFF4E4A7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
          color: isHot ? Colors.white : DcgTheme.slate,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
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
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}

class AuthNote extends StatelessWidget {
  const AuthNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1EA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Firebase Auth can replace this demo sign-in without changing the app flow.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({this.compact = false});

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
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'D',
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 18 : 24,
                fontWeight: FontWeight.w900,
              ),
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

extension CaseStatusLabel on CaseStatus {
  String get label {
    switch (this) {
      case CaseStatus.open:
        return 'Open';
      case CaseStatus.triage:
        return 'Triage';
      case CaseStatus.resolved:
        return 'Resolved';
    }
  }
}

extension PriorityLabel on Priority {
  String get label {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
      case Priority.critical:
        return 'Critical';
    }
  }
}
