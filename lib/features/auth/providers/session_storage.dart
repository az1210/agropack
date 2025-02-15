// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:convert';
// import '../../../models/user.dart';

// final storage = FlutterSecureStorage();

// Future<void> persistUserSession(UserModel user) async {
//   // Save user data as JSON (you can store additional fields as needed).
//   await storage.write(key: 'user_session', value: jsonEncode(user.toMap()));
// }

// Future<UserModel?> restoreUserSession() async {
//   final userJson = await storage.read(key: 'user_session');
//   if (userJson != null) {
//     final Map<String, dynamic> userMap = jsonDecode(userJson);
//     return UserModel.fromMap(userMap);
//   }
//   return null;
// }

// Future<void> clearUserSession() async {
//   await storage.delete(key: 'user_session');
// }
