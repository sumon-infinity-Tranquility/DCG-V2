import 'package:flutter/material.dart';

import '../models/case_status.dart';
import '../models/dcg_case.dart';
import '../models/emergency_category.dart';
import '../models/priority.dart';
import '../models/responder_contact.dart';

const categories = [
  EmergencyCategory('Medical', Icons.medical_services_rounded, Color(0xFFDCE991), 'Health, injury, ambulance'),
  EmergencyCategory('Violence', Icons.security_rounded, Color(0xFFF5A6DF), 'Threat, harassment, crowd risk'),
  EmergencyCategory('Rescue', Icons.volunteer_activism_rounded, Color(0xFFF5E8A6), 'Stuck, trapped, urgent help'),
  EmergencyCategory('Fire', Icons.local_fire_department_rounded, Color(0xFFF5A6A6), 'Smoke, fire, electrical hazard'),
  EmergencyCategory('Disaster', Icons.storm_rounded, Color(0xFFA6F5D4), 'Storm, earthquake, flood'),
  EmergencyCategory('Accident', Icons.car_crash_rounded, Color(0xFFD4CEF9), 'Transport or campus accident'),
];

const contacts = [
  ResponderContact('Proctor Office', 'Campus response lead', '+8801713493050', true),
  ResponderContact('Medical Center', 'First aid and ambulance', '+8801847334655', true),
  ResponderContact('Security Control', 'Gate and patrol unit', '+8801912400700', true),
  ResponderContact('Transport Desk', 'Campus route support', '+8801811110001', false),
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
    status: CaseStatus.responding,
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
