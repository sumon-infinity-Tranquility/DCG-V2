class DcgUser {
  const DcgUser({
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.department,
  });

  final String name;
  final String email;
  final String role;
  final String phone;
  final String department;

  factory DcgUser.fromMap(Map<String, dynamic> map, {String? fallbackEmail}) {
    return DcgUser(
      name: (map['name'] as String?)?.trim().isNotEmpty == true ? map['name'] as String : 'Campus Responder',
      email: ((map['email'] as String?) ?? fallbackEmail ?? '').trim().toLowerCase(),
      role: (map['role'] as String?)?.trim().isNotEmpty == true ? map['role'] as String : 'Responder',
      phone: (map['phone'] as String?)?.trim().isNotEmpty == true ? map['phone'] as String : '+8801700000000',
      department: (map['department'] as String?)?.trim().isNotEmpty == true
          ? map['department'] as String
          : 'Proctor Office',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email.trim().toLowerCase(),
      'role': role,
      'phone': phone,
      'department': department,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  DcgUser copyWith({
    String? name,
    String? email,
    String? role,
    String? phone,
    String? department,
  }) {
    return DcgUser(
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      department: department ?? this.department,
    );
  }
}
