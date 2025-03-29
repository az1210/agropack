import 'package:agro_packaging/features/auth/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user.dart';

/// A FutureProvider.family that accepts a UserModel and creates a user document in Firestore.
final createUserProvider =
    FutureProvider.family<void, UserModel>((ref, newUser) async {
  final authRepo = ref.read(customAuthRepositoryProvider);
  await authRepo.createUser(newUser);
});

/// Provider to fetch all users from the "users" collection.
final userListProvider = FutureProvider<List<UserModel>>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('users').get();
  return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
});

final deleteUserProvider =
    FutureProvider.family<void, String>((ref, userId) async {
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('users').doc(userId).delete();
});
