// import 'package:agro_packaging/features/sales/presentation/edit_quotation_screen.dart';
// import 'package:agro_packaging/features/sales/presentation/notice_detail_screen.dart';
// import 'package:agro_packaging/features/sales/presentation/order_detail_screen.dart';
// import 'package:agro_packaging/features/sales/presentation/orders_screen.dart';
// import 'package:agro_packaging/features/sales/presentation/quotation_detail_screen.dart';
// import 'package:agro_packaging/features/sales/presentation/quotations_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../features/admin/presentation/admin_notice_board.dart';
// import '../features/admin/presentation/notice_publish_screen.dart';
// import '../models/custom_codec.dart';
// import '../models/notice_model.dart';
// import '../models/quotation_model.dart';
// import '../models/auth_state_model.dart';
// import './router_refresh_provider.dart';
// import '../features/auth/providers/auth_providers.dart';
// import '../common/presentation/splash_screen.dart';
// import '../features/auth/presentation/login_screen.dart';
// import '../features/admin/presentation/admin_home_screen.dart';
// import '../features/sales/presentation/sales_home_screen.dart';
// import '../features/home/presentation/unknown_role_screen.dart';
// import '../features/sales/presentation/create_quotation_screen.dart';
// import '../features/admin/presentation/quotation_admin_screen.dart';
// import '../features/admin/presentation/user_create_screen.dart';
// import '../features/sales/presentation/notice_board_screen.dart';

// final goRouterProvider = Provider<GoRouter>((ref) {
//   final customUser = ref.watch(customAuthStateProvider);
//   final capturedAuthState = customUser != null
//       ? AuthStateModel(
//           currentUser: customUser, currentUserRole: customUser.role)
//       : AuthStateModel.empty();

//   final routerRefreshNotifier = ref.watch(routerRefreshProvider);

//   return GoRouter(
//     refreshListenable: routerRefreshNotifier,
//     debugLogDiagnostics: true,
//     initialLocation: '/',
//     extraCodec: const MyExtraCodec(),
//     routes: [
//       GoRoute(
//         path: '/',
//         name: 'splash',
//         builder: (BuildContext context, GoRouterState state) =>
//             const SplashScreen(),
//       ),
//       GoRoute(
//         path: '/login',
//         name: 'login',
//         builder: (BuildContext context, GoRouterState state) =>
//             const LoginScreen(),
//       ),
//       GoRoute(
//         path: '/salesHome',
//         name: 'salesHome',
//         builder: (BuildContext context, GoRouterState state) =>
//             const SalesHomeScreen(),
//         routes: [
//           GoRoute(
//             path: 'quotations',
//             name: 'quotations',
//             builder: (BuildContext context, GoRouterState state) =>
//                 const QuotationScreen(),
//           ),
//           GoRoute(
//             path: '/quotations/createQuotation',
//             name: 'createQuotation',
//             builder: (BuildContext context, GoRouterState state) =>
//                 const CreateQuotationScreen(),
//           ),
//           GoRoute(
//             path: '/salesHome/quotationDetail/:id',
//             name: 'quotationDetail',
//             builder: (BuildContext context, GoRouterState state) {
//               final quotation = state.extra as Quotation;
//               return QuotationDetailScreen(quotation: quotation);
//             },
//           ),
//           GoRoute(
//             path: '/quotations/editQuotation/:id',
//             name: 'editQuotation',
//             builder: (BuildContext context, GoRouterState state) {
//               final quotation = state.extra as Quotation;
//               return EditQuotationScreen(quotation: quotation);
//             },
//           ),
//           GoRoute(
//             path: 'orders',
//             name: 'orders',
//             builder: (BuildContext context, GoRouterState state) =>
//                 const OrdersScreen(),
//           ),
//           GoRoute(
//             path: '/salesHome/ordersDetail/:id',
//             name: 'orderDetail',
//             builder: (context, state) {
//               // Cast extra to Map<String, dynamic> instead of Quotation.
//               final orderData = state.extra as Map<String, dynamic>;
//               return OrderDetailScreen(orderData: orderData);
//             },
//           ),
//           GoRoute(
//             path: '/noticeBoard',
//             name: 'noticeBoard',
//             builder: (BuildContext context, GoRouterState state) =>
//                 const NoticeBoardScreen(),
//           ),
//           GoRoute(
//             path: '/noticeDetail/:id',
//             name: 'noticeDetail',
//             builder: (BuildContext context, GoRouterState state) {
//               final notice = state.extra as Notice;
//               return NoticeDetailScreen(notice: notice);
//             },
//           ),
//         ],
//       ),
//       GoRoute(
//         path: '/adminHome',
//         name: 'adminHome',
//         builder: (BuildContext context, GoRouterState state) =>
//             const AdminHomeScreen(),
//         routes: [
//           GoRoute(
//             path: 'approvQuotation',
//             name: 'approvQuotation',
//             builder: (BuildContext context, GoRouterState state) =>
//                 const QuotationAdminScreen(),
//           ),
//           // GoRoute(
//           //   path: 'editQuotation/:id',
//           //   name: 'editQuotation',
//           //   builder: (BuildContext context, GoRouterState state) {
//           //     final quotation = state.extra as Quotation;
//           //     return EditQuotationScreen(quotation: quotation);
//           //   },
//           // ),
//           GoRoute(
//             path: 'createUser',
//             name: 'createUser',
//             builder: (BuildContext context, GoRouterState state) =>
//                 const CreateUserScreen(),
//           ),
//           GoRoute(
//             path: '/adminHome/notice',
//             name: 'adminNoticeBoard',
//             builder: (BuildContext context, GoRouterState state) =>
//                 const AdminNoticeBoardScreen(),
//           ),
//           GoRoute(
//             path: '/adminHome/publishNotice',
//             name: 'adminPublishNotice',
//             builder: (BuildContext context, GoRouterState state) =>
//                 AdminNoticePublishScreen(),
//           ),
//           GoRoute(
//             path: '/adminHome/editNotice/:id',
//             name: 'editNotice',
//             builder: (BuildContext context, GoRouterState state) {
//               final notice = state.extra as Notice;
//               return NoticeDetailScreen(
//                   notice: notice); // You can build an edit screen similarly.
//             },
//           ),
//         ],
//       ),
//       GoRoute(
//         path: '/unknownRole',
//         name: 'unknownRole',
//         builder: (BuildContext context, GoRouterState state) =>
//             const UnknownRoleScreen(),
//       ),
//     ],
//     redirect: (BuildContext context, GoRouterState state) {
//       final user = capturedAuthState.currentUser;
//       final role = capturedAuthState.currentUserRole;
//       final currentPath = state.uri.path;

//       if (user == null) {
//         return currentPath == '/login' ? null : '/login';
//       }
//       if (currentPath == '/login' || currentPath == '/') {
//         if (role == 'sales') return '/salesHome';
//         if (role == 'admin') return '/adminHome';
//         return '/unknownRole';
//       }
//       return null;
//     },
//   );
// });

// final routerRefreshProvider = Provider<StreamRouterRefresh>((ref) {
//   // Create an instance of custom router refresh class
//   return StreamRouterRefresh(ref);
// });

import 'package:agro_packaging/common/presentation/payment_create_screen.dart';
import 'package:agro_packaging/common/presentation/payment_detail_screen.dart';
import 'package:agro_packaging/common/presentation/payment_list_screen.dart';
import 'package:agro_packaging/common/presentation/reports_screen.dart';
import 'package:agro_packaging/features/admin/presentation/edit_user_screen.dart';
import 'package:agro_packaging/features/admin/presentation/orders_report_screen.dart';
import 'package:agro_packaging/features/admin/presentation/user_list_screen.dart';
import 'package:agro_packaging/features/sales/presentation/edit_quotation_screen.dart';
import 'package:agro_packaging/features/sales/presentation/notice_detail_screen.dart';
import 'package:agro_packaging/features/sales/presentation/order_detail_screen.dart';
import 'package:agro_packaging/features/sales/presentation/orders_screen.dart';
import 'package:agro_packaging/features/sales/presentation/quotation_detail_screen.dart';
import 'package:agro_packaging/features/sales/presentation/quotations_screen.dart';
import 'package:agro_packaging/models/payment_model.dart';
import 'package:agro_packaging/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/admin/presentation/admin_notice_board.dart';
import '../features/admin/presentation/notice_publish_screen.dart';
import '../models/custom_codec.dart';
import '../models/notice_model.dart';
import '../models/quotation_model.dart';
import '../models/auth_state_model.dart';
import './router_refresh_provider.dart';
import '../features/auth/providers/auth_providers.dart';
import '../common/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/admin/presentation/admin_home_screen.dart';
import '../features/sales/presentation/sales_home_screen.dart';
import '../features/home/presentation/unknown_role_screen.dart';
import '../features/sales/presentation/create_quotation_screen.dart';
import '../features/admin/presentation/quotation_admin_screen.dart';
import '../features/admin/presentation/user_create_screen.dart';
import '../features/sales/presentation/notice_board_screen.dart';

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
    extraCodec: const MyExtraCodec(),
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
            path: '/quotations',
            name: 'quotations',
            builder: (BuildContext context, GoRouterState state) =>
                const QuotationScreen(),
          ),
          GoRoute(
            path: '/quotations/createQuotation',
            name: 'createQuotation',
            builder: (BuildContext context, GoRouterState state) =>
                const CreateQuotationScreen(),
          ),
          GoRoute(
            path: '/quotationDetail/:id',
            name: 'quotationDetail',
            builder: (BuildContext context, GoRouterState state) {
              final quotation = state.extra as Quotation;
              return QuotationDetailScreen(quotation: quotation);
            },
          ),
          GoRoute(
            path: '/quotations/editQuotation/:id',
            name: 'editQuotation',
            builder: (BuildContext context, GoRouterState state) {
              final quotation = state.extra as Quotation;
              return EditQuotationScreen(quotation: quotation);
            },
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            builder: (BuildContext context, GoRouterState state) =>
                const OrdersScreen(),
          ),
          GoRoute(
            path: '/ordersDetail/:id',
            name: 'orderDetail',
            builder: (context, state) {
              final orderData = state.extra as Map<String, dynamic>;
              return OrderDetailScreen(orderData: orderData);
            },
          ),
          GoRoute(
            path: '/userCreatePayment',
            name: 'userCreatePayment',
            builder: (BuildContext context, GoRouterState state) =>
                const PaymentAddEditScreen(),
          ),
          GoRoute(
            path: '/userPaymentList',
            name: 'userPaymentList',
            builder: (BuildContext context, GoRouterState state) =>
                const PaymentListScreen(),
          ),
          GoRoute(
            path: '/userPaymentDetail/:id',
            name: 'userPaymentDetail',
            builder: (BuildContext context, GoRouterState state) {
              final payment = state.extra as PaymentModel;
              return PaymentDetailsScreen(payment: payment);
            },
          ),
          GoRoute(
            path: '/noticeBoard',
            name: 'noticeBoard',
            builder: (BuildContext context, GoRouterState state) =>
                const NoticeBoardScreen(),
          ),
          GoRoute(
            path: '/noticeDetail/:id',
            name: 'noticeDetail',
            builder: (BuildContext context, GoRouterState state) {
              final notice = state.extra as Notice;
              return NoticeDetailScreen(notice: notice);
            },
          ),
          GoRoute(
            path: '/userReports',
            name: 'userReports',
            builder: (BuildContext context, GoRouterState state) =>
                const ReportScreen(),
          ),
          GoRoute(
            path: '/userOrdersReport',
            name: 'userOrdersReport',
            builder: (BuildContext context, GoRouterState state) =>
                const OrdersReportScreen(),
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
            path: '/approvQuotation',
            name: 'approvQuotation',
            builder: (BuildContext context, GoRouterState state) =>
                const QuotationAdminScreen(),
          ),
          // Uncomment or adjust if needed:
          // GoRoute(
          //   path: 'editQuotation/:id',
          //   name: 'editQuotation',
          //   builder: (BuildContext context, GoRouterState state) {
          //     final quotation = state.extra as Quotation;
          //     return EditQuotationScreen(quotation: quotation);
          //   },
          // ),
          GoRoute(
            path: '/userList',
            name: 'userList',
            builder: (BuildContext context, GoRouterState state) =>
                const UserListScreen(),
          ),
          GoRoute(
            path: '/createUser',
            name: 'createUser',
            builder: (BuildContext context, GoRouterState state) =>
                const CreateUserScreen(),
          ),
          GoRoute(
            path: '/editUser/:id',
            name: 'editUser',
            builder: (BuildContext context, GoRouterState state) {
              final user = state.extra as UserModel;
              return EditUserScreen(user: user);
            },
          ),
          GoRoute(
            path: '/adminNoticeBoard',
            name: 'adminNoticeBoard',
            builder: (BuildContext context, GoRouterState state) =>
                const AdminNoticeBoardScreen(),
          ),
          GoRoute(
            path: '/publishNotice',
            name: 'adminPublishNotice',
            builder: (BuildContext context, GoRouterState state) =>
                AdminNoticePublishScreen(),
          ),
          GoRoute(
            path: '/adminNoticeDetail/:id',
            name: 'adminNoticeDetail',
            builder: (BuildContext context, GoRouterState state) {
              final notice = state.extra as Notice;
              return NoticeDetailScreen(notice: notice);
            },
          ),
          // GoRoute(
          //   path: 'editNotice/:id',
          //   name: 'editNotice',
          //   builder: (BuildContext context, GoRouterState state) {
          //     final notice = state.extra as Notice;
          //     return NoticeDetailScreen(
          //         notice: notice);
          //   },
          // ),
          GoRoute(
            path: '/adminQuotations',
            name: 'adminQuotations',
            builder: (BuildContext context, GoRouterState state) =>
                const QuotationScreen(),
          ),
          GoRoute(
            path: '/adminQuotations/createAdminQuotation',
            name: 'createAdminQuotation',
            builder: (BuildContext context, GoRouterState state) =>
                const CreateQuotationScreen(),
          ),
          GoRoute(
            path: '/adminQuotationDetail/:id',
            name: 'adminQuotationDetail',
            builder: (BuildContext context, GoRouterState state) {
              final quotation = state.extra as Quotation;
              return QuotationDetailScreen(quotation: quotation);
            },
          ),
          GoRoute(
            path: '/adminQuotations/editAdminQuotation/:id',
            name: 'editAdminQuotation',
            builder: (BuildContext context, GoRouterState state) {
              final quotation = state.extra as Quotation;
              return EditQuotationScreen(quotation: quotation);
            },
          ),
          GoRoute(
            path: '/adminOrders',
            name: 'adminOrders',
            builder: (BuildContext context, GoRouterState state) =>
                const OrdersScreen(),
          ),
          GoRoute(
            path: '/adminOrdersDetail/:id',
            name: 'adminOrderDetail',
            builder: (context, state) {
              final orderData = state.extra as Map<String, dynamic>;
              return OrderDetailScreen(orderData: orderData);
            },
          ),
          GoRoute(
            path: '/createPayment',
            name: 'createPayment',
            builder: (BuildContext context, GoRouterState state) =>
                const PaymentAddEditScreen(),
          ),
          GoRoute(
            path: '/paymentList',
            name: 'paymentList',
            builder: (BuildContext context, GoRouterState state) =>
                const PaymentListScreen(),
          ),
          GoRoute(
            path: '/paymentDetail/:id',
            name: 'paymentDetail',
            builder: (BuildContext context, GoRouterState state) {
              final payment = state.extra as PaymentModel;
              return PaymentDetailsScreen(payment: payment);
            },
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (BuildContext context, GoRouterState state) =>
                const ReportScreen(),
          ),
          GoRoute(
            path: '/ordersReport',
            name: 'ordersReport',
            builder: (BuildContext context, GoRouterState state) =>
                const OrdersReportScreen(),
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
