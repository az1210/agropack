import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';
import './push_notification_service.dart';
import './router/app_router.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import './models/user.dart';
// import './features/auth/providers/auth_providers.dart';

// final FlutterSecureStorage storage = const FlutterSecureStorage();

// Future<UserModel?> restoreUserSession() async {
//   final userJson = await storage.read(key: 'user_session');
//   if (userJson != null) {
//     final Map<String, dynamic> userMap = jsonDecode(userJson);
//     return UserModel.fromMap(userMap);
//   }
//   return null;
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initFirebaseMessaging();

  // final restoredUser = await restoreUserSession();

  runApp(
    ProviderScope(
      // overrides: [
      //   customAuthStateProvider.overrideWith((ref) => restoredUser),
      // ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Packaging Buying House App',
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
