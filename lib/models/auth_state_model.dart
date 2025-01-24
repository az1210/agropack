import 'package:firebase_auth/firebase_auth.dart';

class AuthStateModel {
  final User? currentUser;
  final String? currentUserRole;

  AuthStateModel({this.currentUser, this.currentUserRole});
}
