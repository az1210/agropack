// lib/router/router_refresh_provider.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../models/auth_state_model.dart';

class StreamRouterRefresh extends ChangeNotifier {
  late final StreamSubscription<AuthStateModel> _streamSubscription;

  /// Constructor to initialize and listen to the stream
  StreamRouterRefresh(Stream<AuthStateModel> stream) {
    _streamSubscription = stream.listen(
      (_) {
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Error in StreamRouterRefresh: $error');
      },
    );
  }

  /// Clean up the stream subscription when the provider is disposed
  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
