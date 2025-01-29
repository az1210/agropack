// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../data/auth_repository.dart';

// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   return AuthRepository();
// });

// final authStateChangesProvider = StreamProvider<AuthStateModel>((ref) {
//   final authRepo = ref.read(authRepositoryProvider);
//   return authRepo.authStateChanges;
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../../../models/auth_state_model.dart';

/// Provider for the `AuthRepository`, responsible for all auth-related operations.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Stream provider for listening to authentication state changes.
final authStateChangesProvider = StreamProvider<AuthStateModel>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return authRepo.authStateChanges;
});

/// Provider for signing in a user with email and password.
final signInProvider =
    FutureProvider.family<void, Map<String, String>>((ref, credentials) async {
  final authRepo = ref.read(authRepositoryProvider);
  final email = credentials['email']!;
  final password = credentials['password']!;
  await authRepo.signIn(email, password);
});

/// Provider for signing out the current user.
final signOutProvider = FutureProvider<void>((ref) async {
  final authRepo = ref.read(authRepositoryProvider);
  await authRepo.signOut();
});
