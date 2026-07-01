import 'case_status.dart';
import 'priority.dart';

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
