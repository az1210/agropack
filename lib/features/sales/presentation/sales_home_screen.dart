// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../auth/providers/auth_providers.dart';

// class SalesHomeScreen extends ConsumerWidget {
//   const SalesHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentUser = ref.watch(customAuthStateProvider);
//     final userName = currentUser?.name ?? "User";

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sales Dashboard"),
//       ),
//       drawer: _buildAppDrawer(context, ref, userName),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           children: [
//             _buildGridCard(
//               context,
//               icon: Icons.list_alt,
//               title: 'Quotations',
//               color: Colors.blue,
//               onTap: () => context.goNamed('quotations'),
//             ),
//             _buildGridCard(
//               context,
//               icon: Icons.shopping_cart,
//               title: 'Orders',
//               color: Colors.orange,
//               onTap: () => context.goNamed('orders'),
//             ),
//             _buildGridCard(
//               context,
//               icon: Icons.payment,
//               title: 'Payments',
//               color: Colors.green,
//               onTap: () => context.goNamed('payments'),
//             ),
//             _buildGridCard(
//               context,
//               icon: Icons.local_shipping,
//               title: 'Delivered',
//               color: Colors.purple,
//               onTap: () => context.goNamed('delivered'),
//             ),
//             _buildGridCard(
//               context,
//               icon: Icons.bar_chart,
//               title: 'Reports',
//               color: Colors.red,
//               onTap: () => context.goNamed('reports'),
//             ),
//             _buildGridCard(
//               context,
//               icon: Icons.announcement,
//               title: 'Notice Board',
//               color: Colors.teal,
//               onTap: () => context.goNamed('noticeBoard'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Builds the App Drawer with a welcome message and sign out option.
//   Widget _buildAppDrawer(BuildContext context, WidgetRef ref, String userName) {
//     return Drawer(
//       child: ListView(
//         children: [
//           UserAccountsDrawerHeader(
//             decoration: const BoxDecoration(
//               color: Colors.blue,
//             ),
//             accountName: Text(
//               "Welcome, $userName",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             accountEmail: null,
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, size: 30, color: Colors.blue),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text("Sign Out"),
//             onTap: () async {
//               await signOutUser(ref);
//               if (context.mounted) context.goNamed('login');
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   /// Builds a modern grid card with a gradient background.
//   Widget _buildGridCard(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: LinearGradient(
//               colors: [
//                 color.withValues(alpha: 0.7),
//                 color.withValues(alpha: 1)
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 40, color: Colors.white),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
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

class SalesHomeScreen extends ConsumerWidget {
  const SalesHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(customAuthStateProvider);
    final userName = currentUser?.name ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sales Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: _buildAppDrawer(context, ref, userName),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildGridCard(
              context,
              icon: Icons.list_alt,
              title: 'Quotations',
              color: Colors.blue,
              onTap: () => context.goNamed('quotations'),
            ),
            _buildGridCard(
              context,
              icon: Icons.shopping_cart,
              title: 'Orders',
              color: Colors.orange,
              onTap: () => context.goNamed('orders'),
            ),
            _buildGridCard(
              context,
              icon: Icons.payment,
              title: 'Payments',
              color: Colors.green,
              onTap: () => context.goNamed('payments'),
            ),
            _buildGridCard(
              context,
              icon: Icons.local_shipping,
              title: 'Delivered',
              color: Colors.purple,
              onTap: () => context.goNamed('delivered'),
            ),
            _buildGridCard(
              context,
              icon: Icons.bar_chart,
              title: 'Reports',
              color: Colors.red,
              onTap: () => context.goNamed('reports'),
            ),
            _buildGridCard(
              context,
              icon: Icons.announcement,
              title: 'Notice Board',
              color: Colors.teal,
              onTap: () => context.goNamed('noticeBoard'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a custom App Drawer with a colorful header, welcome message, and sign out option.
  Widget _buildAppDrawer(BuildContext context, WidgetRef ref, String userName) {
    return Drawer(
      child: Column(
        children: [
          // A header with gradient background, avatar, and welcome message.
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
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
              child: Icon(Icons.person, size: 40, color: Colors.blue.shade700),
            ),
          ),
          // Additional drawer items

          ListTile(
            leading: const Icon(Icons.list_alt, color: Colors.black54),
            trailing: const Icon(Icons.add, color: Colors.black87),
            title: const Text("Add Quotation"),
            onTap: () {
              context.goNamed("createQuotation");
              // Add navigation to About page if needed.
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.black54),
            title: const Text("About"),
            onTap: () {
              // Add navigation to About page if needed.
            },
          ),
          const Divider(),
          // Sign Out option with confirmation dialog.
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Sign Out"),
            onTap: () => _showSignOutConfirmationDialog(context, ref),
          ),
        ],
      ),
    );
  }

  /// Displays a confirmation dialog before signing out.
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

  /// Builds a modern grid card with a gradient background, icon, and label.
  Widget _buildGridCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
