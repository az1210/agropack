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

import '../../../models/auth_state_model.dart';
import '../data/auth_repository.dart';

/// Auth repository provider.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Stream provider for auth state changes.
final authStateChangesProvider = StreamProvider<AuthStateModel>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return authRepo.authStateChanges;
});

/// Provider for signing in a user.
final signInProvider = FutureProvider.family<void, String>((ref, email) async {
  final authRepo = ref.read(authRepositoryProvider);
  await authRepo.signIn(email);
});

/// Provider for signing out a user.
final signOutProvider = FutureProvider<void>((ref) async {
  final authRepo = ref.read(authRepositoryProvider);
  await authRepo.signOut();
});
