class UserModel {
  final String id;
  final String email;
  final String role; // admin, sales, client
  final String? name;
  final String? phone;

  // Add password (plaintext)
  final String password;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'password': password,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      password: map['password'] ?? '', // Add password field
      phone: map['phone'] ?? '',
    );
  }
}
