// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class ReportScreen extends StatelessWidget {
//   const ReportScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Reports"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         // Optionally add a gradient background:
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.deepPurple, Colors.indigo],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Orders Report Button
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Navigate to Orders Report screen (ensure route is defined)
//                 context.goNamed('ordersReport');
//               },
//               icon: const Icon(Icons.list_alt),
//               label: const Text("Orders Report"),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.deepPurple,
//                 textStyle:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Shipped Report Button
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Navigate to Shipped Report screen (ensure route is defined)
//                 context.goNamed('shippedReport');
//               },
//               icon: const Icon(Icons.local_shipping),
//               label: const Text("Shipped Report"),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.deepPurple,
//                 textStyle:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Delivered Report Button
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Navigate to Delivered Report screen (ensure route is defined)
//                 context.goNamed('deliveredReport');
//               },
//               icon: const Icon(Icons.check_circle_outline),
//               label: const Text("Delivered Report"),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.deepPurple,
//                 textStyle:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_providers.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  Widget _buildReportCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.indigo.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(customAuthStateProvider);
    final bool isAdmin = currentUser != null && currentUser.role == 'admin';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildReportCard(
              context: context,
              title: 'Orders Report',
              icon: Icons.list_alt,
              onTap: () {
                if (isAdmin) {
                  context.goNamed('ordersReport');
                } else {
                  context.goNamed('userOrdersReport');
                }
              },
            ),
            _buildReportCard(
              context: context,
              title: 'Shipped Report',
              icon: Icons.local_shipping,
              onTap: () {},
            ),
            _buildReportCard(
              context: context,
              title: 'Delivered Report',
              icon: Icons.check_circle_outline,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
