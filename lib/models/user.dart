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
      'phone': phone,
      'password': password, // Save plaintext password
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      role: map['role'],
      name: map['name'],
      phone: map['phone'],
      password: map['password'], // Retrieve plaintext password
    );
  }
}
