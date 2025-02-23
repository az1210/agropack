// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../models/user.dart';

// class CustomAuthRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final List<UserModel> _hardcodedUsers = [
//     UserModel(
//       id: 'admin001',
//       email: 'admin@example.com',
//       name: 'Admin User',
//       role: 'admin',
//       password: '123456',
//       phone: '01732688904',
//     ),
//     UserModel(
//       id: 'sales001',
//       email: 'sales@example.com',
//       name: 'Sales Executive',
//       role: 'sales',
//       password: '123456',
//       phone: '01732688904',
//     ),
//   ];

//   List<UserModel> get hardcodedUsers => _hardcodedUsers;

//   Future<UserModel> authenticateWithHardcodedUsers(
//       String email, String password) async {
//     return _hardcodedUsers.firstWhere(
//       (user) => user.email == email && user.password == password,
//       orElse: () => throw Exception('Invalid email or password'),
//     );
//   }

//   Future<void> createUser(UserModel user) async {
//     try {
//       await _firestore.collection('users').doc(user.id).set(user.toMap());
//     } catch (e) {
//       throw Exception('Error creating user: $e');
//     }
//   }

//   Future<UserModel> signIn(String email, String password) async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .limit(1)
//           .get();

//       UserModel user;

//       if (querySnapshot.docs.isNotEmpty) {
//         final doc = querySnapshot.docs.first;
//         final data = doc.data();
//         if (data['password'] != password) {
//           throw Exception('Invalid password.');
//         }
//         user = UserModel.fromMap(data);
//       } else {
//         user = await authenticateWithHardcodedUsers(email, password);
//         await createUser(user);
//       }
//       return user;
//     } catch (e) {
//       throw Exception('Error during sign in: $e');
//     }
//   }

//   Future<void> signOut() async {
//     // Optionally, call FirebaseAuth's signOut if needed.
//     // await _auth.signOut();
//     return;
//   }
// }

// final customAuthRepositoryProvider = Provider<CustomAuthRepository>((ref) {
//   return CustomAuthRepository();
// });

// final customAuthStateProvider = StateProvider<UserModel?>((ref) => null);

// final signInProvider =
//     FutureProvider.family<void, Map<String, String>>((ref, credentials) async {
//   final authRepo = ref.read(customAuthRepositoryProvider);
//   final email = credentials['email']!;
//   final password = credentials['password']!;
//   final user = await authRepo.signIn(email, password);
//   ref.read(customAuthStateProvider.notifier).state = user;
// });

// Future<void> signOutUser(WidgetRef ref) async {
//   final authRepo = ref.read(customAuthRepositoryProvider);
//   await authRepo.signOut();
//   ref.read(customAuthStateProvider.notifier).state = null;
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // New import
import '../../../models/user.dart';

class CustomAuthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<UserModel> _hardcodedUsers = [
    UserModel(
      id: 'admin001',
      email: 'admin@example.com',
      name: 'Admin User',
      role: 'admin',
      password: '123456',
      phone: '01732688904',
    ),
    UserModel(
      id: 'sales001',
      email: 'sales@example.com',
      name: 'Sales Executive',
      role: 'sales',
      password: '123456',
      phone: '01732688904',
    ),
  ];

  List<UserModel> get hardcodedUsers => _hardcodedUsers;

  Future<UserModel> authenticateWithHardcodedUsers(
      String email, String password) async {
    return _hardcodedUsers.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      UserModel user;

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        if (data['password'] != password) {
          throw Exception('Invalid password.');
        }
        user = UserModel.fromMap(data);
      } else {
        user = await authenticateWithHardcodedUsers(email, password);
        await createUser(user);
      }
      return user;
    } catch (e) {
      throw Exception('Error during sign in: $e');
    }
  }

  Future<void> signOut() async {
    // Optionally, call FirebaseAuth's signOut if needed.
    // await _auth.signOut();
    return;
  }
}

Future<void> saveUserSession(UserModel user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', user.id);
  await prefs.setString('loginTimestamp', DateTime.now().toIso8601String());
  // Save additional user details for restoration
  await prefs.setString('email', user.email);
  await prefs.setString('role', user.role);
}

Future<UserModel?> getPersistedUser() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final timestampString = prefs.getString('loginTimestamp');
  final email = prefs.getString('email');
  final role = prefs.getString('role');

  if (userId != null &&
      timestampString != null &&
      email != null &&
      role != null) {
    final loginTimestamp = DateTime.parse(timestampString);
    if (DateTime.now().difference(loginTimestamp).inDays <= 30) {
      return UserModel(
        id: userId,
        email: email,
        role: role,
        name: '', // Optionally store and retrieve if needed
        password: '', // Not required for session restoration
        phone: '', // Optionally store and retrieve if needed
      );
    } else {
      // Session expired; clear stored data
      await prefs.remove('userId');
      await prefs.remove('loginTimestamp');
      await prefs.remove('email');
      await prefs.remove('role');
    }
  }
  return null;
}

final customAuthRepositoryProvider = Provider<CustomAuthRepository>((ref) {
  return CustomAuthRepository();
});

final customAuthStateProvider = StateProvider<UserModel?>((ref) => null);

// Modified signInProvider: saves session on successful login
final signInProvider =
    FutureProvider.family<void, Map<String, String>>((ref, credentials) async {
  final authRepo = ref.read(customAuthRepositoryProvider);
  final email = credentials['email']!;
  final password = credentials['password']!;
  final user = await authRepo.signIn(email, password);

  // Save the session for 30 days
  await saveUserSession(user);

  ref.read(customAuthStateProvider.notifier).state = user;
});

// Modified signOutUser: clears persistent session data
Future<void> signOutUser(WidgetRef ref) async {
  final authRepo = ref.read(customAuthRepositoryProvider);
  await authRepo.signOut();
  ref.read(customAuthStateProvider.notifier).state = null;

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
  await prefs.remove('loginTimestamp');
}
