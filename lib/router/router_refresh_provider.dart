// lib/router/router_refresh_provider.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../models/auth_state_model.dart';

class StreamRouterRefresh extends ChangeNotifier {
  late final StreamSubscription<AuthStateModel> _streamSubscription;

  StreamRouterRefresh(Stream<AuthStateModel> stream) {
    _streamSubscription = stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
