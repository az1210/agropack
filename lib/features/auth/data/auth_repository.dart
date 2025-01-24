// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthStateModel {
//   final User? currentUser;
//   final String? currentUserRole;

//   AuthStateModel({this.currentUser, this.currentUserRole});
// }

// class AuthRepository {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Stream<AuthStateModel> get authStateChanges {
//     return _auth.authStateChanges().asyncMap((user) async {
//       if (user == null) {
//         // No user => no role
//         return AuthStateModel(currentUser: null, currentUserRole: null);
//       }

//       final doc = await _firestore.collection('users').doc(user.uid).get();
//       final role = doc.data()?['role'] as String?;
//       return AuthStateModel(currentUser: user, currentUserRole: role);
//     });
//   }

//   Future<void> signInWithEmailAndPassword(String email, String password) async {
//     await _auth.signInWithEmailAndPassword(email: email, password: password);
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user.dart';
import '../../../models/auth_state_model.dart';
// import '../providers/user.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Hardcoded users (for initial login).
  final List<UserModel> _hardcodedUsers = [
    UserModel(
        id: 'admin001',
        email: 'admin@example.com',
        name: 'Admin User',
        role: 'admin',
        password: '123456',
        phone: '01732688904'),
    UserModel(
        id: 'sales001',
        email: 'sales@example.com',
        name: 'Sales Executive',
        role: 'sales',
        password: '123456',
        phone: '01732688904'),
  ];

  /// Stream to listen for auth state changes.
  Stream<AuthStateModel> get authStateChanges {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        return AuthStateModel(currentUser: null, currentUserRole: null);
      }
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userRole = userDoc.data()?['role'] as String?;
      return AuthStateModel(currentUser: user, currentUserRole: userRole);
    });
  }

  /// Authenticate with hardcoded users.
  Future<UserModel?> authenticateWithHardcodedUsers(String email) async {
    return _hardcodedUsers.firstWhere(
      (user) => user.email == email,
      orElse: () => throw Exception('Invalid email'),
    );
  }

  /// Create or update user in Firestore.
  Future<void> saveUserToFirestore(UserModel user) async {
    final userRef = _firestore.collection('users').doc(user.id);
    await userRef.set(user.toMap());
  }

  /// Sign in using email and role.
  Future<void> signIn(String email) async {
    final user = await authenticateWithHardcodedUsers(email);
    if (user != null) {
      // Use Firebase Anonymous Auth for the session.
      final authUser = await _auth.signInAnonymously();
      final firebaseUser = authUser.user;

      if (firebaseUser != null) {
        final userModel = UserModel(
            id: firebaseUser.uid,
            email: user.email,
            name: user.name,
            role: user.role,
            password: user.password,
            phone: user.phone);

        // Save to Firestore.
        await saveUserToFirestore(userModel);
      }
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
