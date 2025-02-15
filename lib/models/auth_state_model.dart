import '../../../models/user.dart';

class AuthStateModel {
  final UserModel? currentUser; // Now using our custom UserModel.
  final String? currentUserRole;

  AuthStateModel({this.currentUser, this.currentUserRole});

  /// Factory constructor for creating an empty authentication state.
  factory AuthStateModel.empty() {
    return AuthStateModel(currentUser: null, currentUserRole: null);
  }

  /// Returns true if a user is currently authenticated.
  bool get isAuthenticated => currentUser != null;

  /// Checks whether the current user has the specified role.
  bool hasRole(String role) {
    return currentUserRole == role;
  }

  @override
  String toString() {
    return 'AuthStateModel(currentUser: ${currentUser?.id ?? "null"}, currentUserRole: $currentUserRole)';
  }
}
