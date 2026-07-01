import 'package:flutter/material.dart';

import '../../data/emergency_data.dart';
import '../../models/case_status.dart';
import '../../models/dcg_case.dart';
import '../../models/dcg_user.dart';
import '../../services/demo_auth_store.dart';
import '../../widgets/shared_widgets.dart';
import '../cases/cases_page.dart';
import '../contacts/contacts_page.dart';
import '../dashboard/dashboard_page.dart';
import '../profile/profile_page.dart';
import '../reports/report_hub_page.dart';
import '../reports/report_sheet.dart';
import '../sos/sos_page.dart';

class DcgHome extends StatefulWidget {
  const DcgHome({required this.initialUser, required this.onSignOut, super.key});

  final DcgUser initialUser;
  final VoidCallback onSignOut;

  @override
  State<DcgHome> createState() => _DcgHomeState();
}

class _DcgHomeState extends State<DcgHome> {
  int tabIndex = 0;
  final cases = List<DcgCase>.from(seedCases);
  final pageController = PageController();
  late DcgUser user;

  @override
  void initState() {
    super.initState();
    user = widget.initialUser;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void addCase(DcgCase dcgCase) {
    setState(() => cases.insert(0, dcgCase));
  }

  void updateStatus(DcgCase dcgCase, CaseStatus status) {
    setState(() {
      dcgCase.status = status;
      dcgCase.updatedAt = DateTime.now();
      dcgCase.updatedBy = user.name;
    });
    showSnack('${dcgCase.location} moved to ${status.label}');
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void selectTab(int index) {
    setState(() => tabIndex = index);
    pageController.animateToPage(index, duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        user: user,
        cases: cases,
        onOpenSos: () => selectTab(1),
        onOpenProfile: () => selectTab(5),
        onSelectCategory: (category) => showReportSheet(category.name),
      ),
      SosPage(
        responderName: user.name,
        onCreateCase: (dcgCase) {
          addCase(dcgCase);
          showSnack('Critical SOS case created');
        },
      ),
      ReportHubPage(
        onStartReport: (category) => showReportSheet(category),
      ),
      CasesPage(cases: cases, onStatusChange: updateStatus),
      ContactsPage(),
      ProfilePage(
        user: user,
        cases: cases,
        onSave: (updatedUser) {
          setState(() => user = updatedUser);
          DemoAuthStore.updateUser(updatedUser);
          showSnack('Profile updated');
        },
        onSignOut: widget.onSignOut,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const BrandLockup(compact: true),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: widget.onSignOut,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => setState(() => tabIndex = index),
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: selectTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.sos_rounded), label: 'SOS'),
          NavigationDestination(icon: Icon(Icons.edit_note_rounded), label: 'Report'),
          NavigationDestination(icon: Icon(Icons.view_kanban_rounded), label: 'Cases'),
          NavigationDestination(icon: Icon(Icons.call_rounded), label: 'Contacts'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Future<void> showReportSheet(String category) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => ReportSheet(
        initialCategory: category,
        responderName: user.name,
        onSubmit: (dcgCase) {
          addCase(dcgCase);
          showSnack('Report submitted');
        },
      ),
    );
  }
}
