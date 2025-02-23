// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart';
// import './firebase_options.dart';
// import './push_notification_service.dart';
// import './router/app_router.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   await initFirebaseMessaging();

//   runApp(
//     ProviderScope(
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final goRouter = ref.watch(goRouterProvider);
//     return MaterialApp.router(
//       title: 'Packaging Buying House App',
//       routerConfig: goRouter,
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';
import './push_notification_service.dart';
import './router/app_router.dart';
import 'features/auth/providers/auth_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initFirebaseMessaging();

  // Load the persisted user session before starting the app.
  final persistedUser = await getPersistedUser();

  runApp(
    ProviderScope(
      overrides: [
        // Override the initial value of customAuthStateProvider with persistedUser
        customAuthStateProvider.overrideWith((ref) => persistedUser),
      ],
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
