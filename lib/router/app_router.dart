// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'router_refresh_provider.dart';
// import '../features/auth/providers/auth_providers.dart';
// import '../presentation/splash_screen.dart';
// import '../features/auth/presentation/login_screen.dart';
// import '../features/home/presentation/admin_home_screen.dart';
// import '../features/home/presentation/sales_home_screen.dart';
// import '../features/home/presentation/unknown_role_screen.dart';
// import '../features/quotations/presentation/create_quotation_screen.dart';

// final goRouterProvider = Provider<GoRouter>((ref) {
//   // This listens to auth changes (user + role)
//   final authState = ref.watch(authStateChangesProvider);

//   return GoRouter(
//     debugLogDiagnostics: true,
//     initialLocation: '/',
//     refreshListenable: GoRouterRefreshStream(authState.authStateChanges),
//     routes: [
//       GoRoute(
//         path: '/',
//         name: 'splash',
//         builder: (context, state) => const SplashScreen(),
//       ),
//       GoRoute(
//         path: '/login',
//         name: 'login',
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: '/salesHome',
//         name: 'salesHome',
//         builder: (context, state) => const SalesHomeScreen(),
//         routes: [
//           GoRoute(
//             path: 'createQuotation',
//             name: 'createQuotation',
//             builder: (context, state) => const CreateQuotationScreen(),
//           ),
//         ],
//       ),
//       GoRoute(
//         path: '/adminHome',
//         name: 'adminHome',
//         builder: (context, state) => const AdminHomeScreen(),
//       ),
//       GoRoute(
//         path: '/unknownRole',
//         name: 'unknownRole',
//         builder: (context, state) => const UnknownRoleScreen(),
//       ),
//     ],
//     redirect: (context, state) {
//       final user = authState.currentUser;
//       final role = authState.currentUserRole;
//       final isLoggingIn = state.subloc == '/login';

//       // If user is not logged in, always go to login (unless we are already there)
//       if (user == null) {
//         return isLoggingIn ? null : '/login';
//       }

//       // If user is logged in and tries to go to login page, redirect to role-based home
//       if (isLoggingIn) {
//         if (role == 'sales') return '/salesHome';
//         if (role == 'admin') return '/adminHome';
//         return '/unknownRole';
//       }

//       // If user is on splash screen, also redirect accordingly
//       if (state.subloc == '/') {
//         if (role == 'sales') return '/salesHome';
//         if (role == 'admin') return '/adminHome';
//         return '/unknownRole';
//       }

//       // Otherwise do nothing
//       return null;
//     },
//   );
// });
// lib/router/app_router.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/quotation_model.dart';
import './router_refresh_provider.dart';
import '../features/auth/providers/auth_providers.dart';
import '../presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/home/presentation/admin_home_screen.dart';
import '../features/home/presentation/sales_home_screen.dart';
import '../features/home/presentation/unknown_role_screen.dart';
import '../features/quotations/presentation/create_quotation_screen.dart';
import '../features/home/presentation/quotation_admin_screen.dart';
import '../features/home/presentation/edit_quotation_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider).maybeWhen(
        data: (authStateModel) => authStateModel,
        orElse: () => null,
      );

  final routerRefreshNotifier = ref.watch(routerRefreshProvider);

  return GoRouter(
    refreshListenable: routerRefreshNotifier,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/salesHome',
        name: 'salesHome',
        builder: (context, state) => const SalesHomeScreen(),
        routes: [
          GoRoute(
            path: 'createQuotation',
            name: 'createQuotation',
            builder: (context, state) => const CreateQuotationScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/adminHome',
        name: 'adminHome',
        builder: (context, state) => const AdminHomeScreen(),
        routes: [
          GoRoute(
            path: 'approvQuotation',
            name: 'approvQuotation',
            builder: (context, state) => const QuotationAdminScreen(),
          ),
          GoRoute(
            path: 'editQuotation/:id',
            name: 'editQuotation',
            builder: (context, state) {
              final quotation = state.extra as Quotation;
              return EditQuotationScreen(quotation: quotation);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/unknownRole',
        name: 'unknownRole',
        builder: (context, state) => const UnknownRoleScreen(),
      ),
    ],
    redirect: (context, state) {
      final user = authState?.currentUser;
      final role = authState?.currentUserRole;
      final currentPath = state.uri.path;

      if (user == null) {
        return (currentPath == '/login') ? null : '/login';
      }

      if (currentPath == '/login') {
        if (role == 'sales') return '/salesHome';
        if (role == 'admin') return '/adminHome';
        return '/unknownRole';
      }

      if (currentPath == '/') {
        if (role == 'sales') return '/salesHome';
        if (role == 'admin') return '/adminHome';
        return '/unknownRole';
      }

      return null;
    },
  );
});

final routerRefreshProvider = Provider<StreamRouterRefresh>((ref) {
  final authStream = ref.watch(authStateChangesProvider.stream);
  return StreamRouterRefresh(authStream);
});
