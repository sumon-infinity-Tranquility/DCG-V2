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
