import 'package:agro_packaging/features/auth/providers/auth_providers.dart';
import 'package:agro_packaging/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

class StreamRouterRefresh extends ChangeNotifier {
  /// Constructor that takes a [Ref] to listen to changes in [customAuthStateProvider].
  StreamRouterRefresh(Ref ref) {
    // Listen to changes in customAuthStateProvider.
    // Every time the value changes, notifyListeners() is called.
    ref.listen<UserModel?>(customAuthStateProvider, (previous, next) {
      notifyListeners();
    });
    // No need to store the subscription because Riverpod disposes the listener automatically.
  }
}
