// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../models/user.dart';
// import '../../../models/auth_state_model.dart';

// class AuthRepository {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Hardcoded users (for initial login).
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

//   /// Public getter for hardcoded users
//   List<UserModel> get hardcodedUsers => _hardcodedUsers;

//   /// Stream to listen for auth state changes.
//   Stream<AuthStateModel> get authStateChanges {
//     return _auth.authStateChanges().asyncMap((user) async {
//       if (user == null) {
//         return AuthStateModel(currentUser: null, currentUserRole: null);
//       }

//       final userDoc = await _firestore.collection('users').doc(user.uid).get();

//       if (!userDoc.exists) {
//         throw Exception('User not found in Firestore');
//       }

//       final userRole = userDoc.data()?['role'] as String?;
//       return AuthStateModel(currentUser: user, currentUserRole: userRole);
//     });
//   }

//   /// Authenticate with hardcoded users.
//   Future<UserModel?> authenticateWithHardcodedUsers(
//       String email, String password) async {
//     return _hardcodedUsers.firstWhere(
//       (user) => user.email == email && user.password == password,
//       orElse: () => throw Exception('Invalid email or password'),
//     );
//   }

//   /// Create or update user in Firestore.
//   Future<void> saveUserToFirestore(UserModel user) async {
//     final userRef = _firestore.collection('users').doc(user.id);
//     await userRef.set(user.toMap());
//   }

//   Future<void> createUser(UserModel user) async {
//     try {
//       await _firestore.collection('users').doc(user.id).set(user.toMap());
//     } catch (e) {
//       throw Exception('Error creating user: $e');
//     }
//   }

//   /// Seed the hardcoded users in Firestore
//   Future<void> seedHardcodedUsers() async {
//     for (final user in _hardcodedUsers) {
//       await createUser(user);
//     }
//   }

//   /// Sign in using email and role.
//   Future<void> signIn(String email, String password) async {
//     final user = await authenticateWithHardcodedUsers(email, password);
//     if (user != null) {
//       // Use Firebase Anonymous Auth for the session.
//       final authUser = await _auth.signInAnonymously();
//       final firebaseUser = authUser.user;

//       if (firebaseUser != null) {
//         final userModel = UserModel(
//           id: firebaseUser.uid,
//           email: user.email,
//           name: user.name,
//           role: user.role,
//           password: user.password,
//           phone: user.phone,
//         );

//         // Save to Firestore.
//         await saveUserToFirestore(userModel);
//       }
//     }
//   }

//   /// Sign out the current user.
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../models/user.dart';
// import '../../../models/auth_state_model.dart';

// class AuthRepository {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Hardcoded users (for initial login).
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

//   /// Public getter for hardcoded users.
//   List<UserModel> get hardcodedUsers => _hardcodedUsers;

//   /// (Optional) Stream to listen for FirebaseAuth state changes.
//   /// In Option 2, you rely on your custom auth state.
//   Stream<AuthStateModel> get authStateChanges {
//     return _auth.authStateChanges().asyncMap((user) async {
//       if (user == null) {
//         return AuthStateModel(currentUser: null, currentUserRole: null);
//       }

//       final userDoc = await _firestore.collection('users').doc(user.uid).get();

//       if (!userDoc.exists) {
//         throw Exception('User not found in Firestore');
//       }

//       final userRole = userDoc.data()?['role'] as String?;
//       return AuthStateModel(currentUser: user, currentUserRole: userRole);
//     });
//   }

//   /// Finds a hardcoded user matching the email and password.
//   /// Throws an exception if no matching user is found.
//   Future<UserModel> authenticateWithHardcodedUsers(
//       String email, String password) async {
//     return _hardcodedUsers.firstWhere(
//       (user) => user.email == email && user.password == password,
//       orElse: () => throw Exception('Invalid email or password'),
//     );
//   }

//   /// Create or update a user in Firestore.
//   Future<void> saveUserToFirestore(UserModel user) async {
//     final userRef = _firestore.collection('users').doc(user.id);
//     await userRef.set(user.toMap());
//   }

//   Future<void> createUser(UserModel user) async {
//     try {
//       await _firestore.collection('users').doc(user.id).set(user.toMap());
//     } catch (e) {
//       throw Exception('Error creating user: $e');
//     }
//   }

//   /// Seed the hardcoded users in Firestore.
//   Future<void> seedHardcodedUsers() async {
//     for (final user in _hardcodedUsers) {
//       await createUser(user);
//     }
//   }

//   /// Custom sign in method.
//   /// Checks Firestore for an existing user document with the provided email.
//   /// If found, verifies the password; otherwise, looks up the hardcoded user
//   /// and creates a new Firestore document.
//   /// Returns the custom user (UserModel) on success.
//   Future<UserModel> signIn(String email, String password) async {
//     try {
//       // 1. Check Firestore if a user document with the given email exists.
//       final querySnapshot = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .limit(1)
//           .get();

//       UserModel user;

//       if (querySnapshot.docs.isNotEmpty) {
//         // 2a. If the user document exists, verify the password.
//         final doc = querySnapshot.docs.first;
//         final data = doc.data();
//         if (data['password'] != password) {
//           throw Exception('Invalid password.');
//         }
//         // Convert Firestore data into a UserModel.
//         user = UserModel.fromMap(data);
//         // Optionally, update the user's id with the Firestore doc id:
//         // user = user.copyWith(id: doc.id);
//       } else {
//         // 2b. If no user document exists, find the user in the hardcoded list.
//         user = await authenticateWithHardcodedUsers(email, password);
//         // Create the Firestore document for this user.
//         await createUser(user);
//       }

//       // Return the custom user.
//       return user;
//     } catch (e) {
//       throw Exception('Error during sign in: $e');
//     }
//   }

//   /// Custom sign out method.
//   /// In a custom auth system, you might simply clear your custom auth state.
//   Future<void> signOut() async {
//     // If you maintain a custom auth state (e.g., via a Riverpod StateProvider),
//     // you would clear it here.
//     // Optionally, you may also call _auth.signOut() if needed.
//     return;
//   }
// }
