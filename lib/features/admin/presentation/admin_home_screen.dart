// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:badges/badges.dart' as badges;
// import 'package:go_router/go_router.dart';
// import '../../auth/providers/auth_providers.dart';

// // final notificationCountProvider = StreamProvider<int>((ref) {
// //   return Stream<int>.periodic(
// //     const Duration(seconds: 5),
// //     (count) => (count % 5),
// //   );
// // });

// class AdminHomeScreen extends ConsumerWidget {
//   const AdminHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final notificationCount = ref.watch(notificationCountProvider).maybeWhen(
//     //       data: (count) => count,
//     //       orElse: () => 0,
//     //     );

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Admin Dashboard',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurple,
//         // actions: [
//         //   IconButton(
//         //     onPressed: () {
//         //       // Navigate to a notifications screen or show a dialog.
//         //     },
//         //     icon: badges.Badge(
//         //       badgeContent: Text(
//         //         notificationCount.toString(),
//         //         style: const TextStyle(color: Colors.white, fontSize: 12),
//         //       ),
//         //       showBadge: notificationCount > 0,
//         //       child: const Icon(Icons.notifications),
//         //     ),
//         //   ),
//         //   const SizedBox(width: 16),
//         // ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.deepPurple, Colors.indigo],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: GridView.count(
//           crossAxisCount: 2,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           children: [
//             _buildCard(
//               context,
//               title: 'Quotations\nfor Approval',
//               icon: Icons.list_alt_rounded,
//               onTap: () {
//                 context.goNamed('adminQuotations');
//               },
//             ),
//             _buildCard(
//               context,
//               title: 'Confirmed\nOrders',
//               icon: Icons.check_circle_outline,
//               onTap: () {
//                 context.goNamed('adminOrders');
//               },
//             ),
//             _buildCard(
//               context,
//               title: 'Notice Board',
//               icon: Icons.notifications_active,
//               onTap: () {
//                 context.goNamed('adminNoticeBoard');
//               },
//             ),
//             _buildCard(
//               context,
//               title: 'Add/Remove Users',
//               icon: Icons.person_add_alt_1,
//               onTap: () {
//                 context.goNamed('userList');
//               },
//             ),
//             // Example additional card.
//             _buildCard(
//               context,
//               title: 'Reports',
//               icon: Icons.assessment,
//               onTap: () {
//                 context.goNamed('reports');
//               },
//             ),
//             // Sign out card.
//             Center(
//               child: TextButton.icon(
//                 onPressed: () async {
//                   await signOutUser(ref);
//                   context.goNamed('login');
//                 },
//                 icon: const Icon(Icons.logout, color: Colors.white),
//                 label: const Text(
//                   'Sign Out',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Helper method to build each menu card.
//   Widget _buildCard(
//     BuildContext context, {
//     required String title,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       color: Colors.white.withOpacity(0.9),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 48,
//                 color: Colors.deepPurple,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_providers.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(customAuthStateProvider);
    final userName = currentUser?.name ?? "User";

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: _buildAppDrawer(context, ref, userName),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildCard(
              context,
              title: 'Quotations\nfor Approval',
              icon: Icons.list_alt_rounded,
              onTap: () {
                context.goNamed('adminQuotations');
              },
            ),
            _buildCard(
              context,
              title: 'Confirmed\nOrders',
              icon: Icons.check_circle_outline,
              onTap: () {
                context.goNamed('adminOrders');
              },
            ),
            _buildCard(
              context,
              title: 'Notice Board',
              icon: Icons.notifications_active,
              onTap: () {
                context.goNamed('adminNoticeBoard');
              },
            ),
            _buildCard(
              context,
              title: 'Payments',
              icon: Icons.payment,
              onTap: () {
                context.goNamed('paymentList');
              },
            ),
            _buildCard(
              context,
              title: 'Add/Remove Users',
              icon: Icons.person_add_alt_1,
              onTap: () {
                context.goNamed('userList');
              },
            ),
            _buildCard(
              context,
              title: 'Reports',
              icon: Icons.assessment,
              onTap: () {
                context.goNamed('reports');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppDrawer(BuildContext context, WidgetRef ref, String userName) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              "Welcome, $userName",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.admin_panel_settings,
                  size: 40, color: Colors.deepPurple.shade700),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.assessment, color: Colors.black54),
            trailing:
                const Icon(Icons.arrow_forward_ios, color: Colors.black87),
            title: const Text("Order Reports"),
            onTap: () {
              context.goNamed("ordersReport");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Sign Out"),
            onTap: () => _showSignOutConfirmationDialog(context, ref),
          ),
        ],
      ),
    );
  }

  void _showSignOutConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await signOutUser(ref);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  context.goNamed('login');
                }
              },
              child: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
