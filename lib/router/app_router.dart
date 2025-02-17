import 'package:agro_packaging/features/sales/presentation/order_detail_screen.dart';
import 'package:agro_packaging/features/sales/presentation/orders_screen.dart';
import 'package:agro_packaging/features/sales/presentation/quotation_detail_screen.dart';
import 'package:agro_packaging/features/sales/presentation/quotations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/quotation_model.dart';
import '../models/auth_state_model.dart';
import './router_refresh_provider.dart';
import '../features/auth/providers/auth_providers.dart';
import '../common/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/home/presentation/admin_home_screen.dart';
import '../features/sales/presentation/sales_home_screen.dart';
import '../features/home/presentation/unknown_role_screen.dart';
import '../features/sales/presentation/create_quotation_screen.dart';
import '../features/home/presentation/quotation_admin_screen.dart';
import '../features/home/presentation/edit_quotation_screen.dart';
import '../features/admin/presentation/user_create_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final customUser = ref.watch(customAuthStateProvider);
  final capturedAuthState = customUser != null
      ? AuthStateModel(
          currentUser: customUser, currentUserRole: customUser.role)
      : AuthStateModel.empty();

  final routerRefreshNotifier = ref.watch(routerRefreshProvider);

  return GoRouter(
    refreshListenable: routerRefreshNotifier,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: '/salesHome',
        name: 'salesHome',
        builder: (BuildContext context, GoRouterState state) =>
            const SalesHomeScreen(),
        routes: [
          GoRoute(
            path: 'quotations',
            name: 'quotations',
            builder: (BuildContext context, GoRouterState state) =>
                const QuotationScreen(),
          ),
          GoRoute(
            path: 'createQuotation',
            name: 'createQuotation',
            builder: (BuildContext context, GoRouterState state) =>
                const CreateQuotationScreen(),
          ),
          GoRoute(
            path: '/salesHome/quotationDetail/:id',
            name: 'quotationDetail',
            builder: (BuildContext context, GoRouterState state) {
              final quotation = state.extra as Quotation;
              return QuotationDetailScreen(quotation: quotation);
            },
          ),
          GoRoute(
            path: 'orders',
            name: 'orders',
            builder: (BuildContext context, GoRouterState state) =>
                const OrdersScreen(),
          ),
          GoRoute(
            path: '/salesHome/ordersDetail/:id',
            name: 'orderDetail',
            builder: (context, state) {
              // Cast extra to Map<String, dynamic> instead of Quotation.
              final orderData = state.extra as Map<String, dynamic>;
              return OrderDetailScreen(orderData: orderData);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/adminHome',
        name: 'adminHome',
        builder: (BuildContext context, GoRouterState state) =>
            const AdminHomeScreen(),
        routes: [
          GoRoute(
            path: 'approvQuotation',
            name: 'approvQuotation',
            builder: (BuildContext context, GoRouterState state) =>
                const QuotationAdminScreen(),
          ),
          GoRoute(
            path: 'editQuotation/:id',
            name: 'editQuotation',
            builder: (BuildContext context, GoRouterState state) {
              final quotation = state.extra as Quotation;
              return EditQuotationScreen(quotation: quotation);
            },
          ),
          GoRoute(
            path: 'createUser',
            name: 'createUser',
            builder: (BuildContext context, GoRouterState state) =>
                const CreateUserScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/unknownRole',
        name: 'unknownRole',
        builder: (BuildContext context, GoRouterState state) =>
            const UnknownRoleScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final user = capturedAuthState.currentUser;
      final role = capturedAuthState.currentUserRole;
      final currentPath = state.uri.path;

      if (user == null) {
        return currentPath == '/login' ? null : '/login';
      }
      if (currentPath == '/login' || currentPath == '/') {
        if (role == 'sales') return '/salesHome';
        if (role == 'admin') return '/adminHome';
        return '/unknownRole';
      }
      return null;
    },
  );
});

final routerRefreshProvider = Provider<StreamRouterRefresh>((ref) {
  // Create an instance of custom router refresh class
  return StreamRouterRefresh(ref);
});
