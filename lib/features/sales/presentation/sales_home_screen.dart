// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../auth/providers/auth_providers.dart'; // Ensure this file exports signOutUser

// class SalesHomeScreen extends ConsumerWidget {
//   const SalesHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sales Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await signOutUser(ref);
//               context.goNamed('login');
//             },
//           ),
//         ],
//       ),
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
//               onTap: () {
//                 // Navigate to the Quotations screen (which includes "Create Quotation")
//                 context.goNamed('quotations');
//               },
//             ),
//             _buildGridCard(
//               context,
//               icon: Icons.shopping_cart,
//               title: 'Orders',
//               onTap: () {
//                 context.goNamed('orders');
//               },
//             ),
//             _buildGridCard(
//               context,
//               icon: Icons.payment,
//               title: 'Payments',
//               onTap: () {
//                 context.goNamed('payments');
//               },
//             ),
//             _buildGridCard(
//               context,
//               icon: Icons.announcement,
//               title: 'Notice Board',
//               onTap: () {
//                 context.goNamed('noticeBoard');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGridCard(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 48,
//                 color: Theme.of(context).primaryColor,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.titleMedium,
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
import '../../auth/providers/auth_providers.dart'; // Ensure this file exports signOutUser

class SalesHomeScreen extends ConsumerWidget {
  const SalesHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await signOutUser(ref);
              context.goNamed('login');
            },
          ),
        ],
      ),
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
              onTap: () {
                // Navigate to the Quotations screen (which includes "Create Quotation")
                context.goNamed('quotations');
              },
            ),
            _buildGridCard(
              context,
              icon: Icons.shopping_cart,
              title: 'Orders',
              onTap: () {
                context.goNamed('orders');
              },
            ),
            _buildGridCard(
              context,
              icon: Icons.payment,
              title: 'Payments',
              onTap: () {
                context.goNamed('payments');
              },
            ),

            // New grid card for Delivered
            _buildGridCard(
              context,
              icon: Icons.local_shipping,
              title: 'Delivered',
              onTap: () {
                context.goNamed('delivered');
              },
            ),
            // New grid card for Reports
            _buildGridCard(
              context,
              icon: Icons.bar_chart,
              title: 'Reports',
              onTap: () {
                context.goNamed('reports');
              },
            ),
            _buildGridCard(
              context,
              icon: Icons.announcement,
              title: 'Notice Board',
              onTap: () {
                context.goNamed('noticeBoard');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
