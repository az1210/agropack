import 'package:firebase_auth/firebase_auth.dart';

class AuthStateModel {
  final User? currentUser;
  final String? currentUserRole;

  AuthStateModel({this.currentUser, this.currentUserRole});

  /// Factory constructor for creating an empty state.
  factory AuthStateModel.empty() {
    return AuthStateModel(currentUser: null, currentUserRole: null);
  }

  /// Check if the user is authenticated.
  bool get isAuthenticated => currentUser != null;

  /// Check if the user has a specific role.
  bool hasRole(String role) {
    return currentUserRole == role;
  }

  @override
  String toString() {
    return 'AuthStateModel(currentUser: $currentUser, currentUserRole: $currentUserRole)';
  }
}
