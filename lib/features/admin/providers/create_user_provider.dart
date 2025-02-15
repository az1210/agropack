import 'package:agro_packaging/features/auth/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user.dart';

/// A FutureProvider.family that accepts a UserModel and creates a user document in Firestore.
final createUserProvider =
    FutureProvider.family<void, UserModel>((ref, newUser) async {
  final authRepo = ref.read(customAuthRepositoryProvider);
  await authRepo.createUser(newUser);
});
