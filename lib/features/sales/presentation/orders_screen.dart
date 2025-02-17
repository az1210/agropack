// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import '../../auth/providers/auth_providers.dart';
// import '../providers/order_provider.dart';

// class OrdersScreen extends ConsumerStatefulWidget {
//   const OrdersScreen({super.key});

//   @override
//   ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends ConsumerState<OrdersScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // Get current user information from your auth provider.
//     final currentUser = ref.watch(customAuthStateProvider);
//     final bool isAdmin = currentUser != null && currentUser.role == 'admin';
//     final String userId = currentUser?.id ?? '';
//     debugPrint("Current user id: $userId, isAdmin: $isAdmin");

//     return Scaffold(
//       appBar: AppBar(title: const Text("Orders")),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: ref
//             .read(orderProvider.notifier)
//             .fetchOrders(userId, isAdmin: isAdmin),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           final orders = snapshot.data ?? [];
//           if (orders.isEmpty) {
//             return const Center(child: Text("No orders found."));
//           }
//           return ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               final order = orders[index];
//               final orderId = order['orderId'] as String? ?? 'N/A';
//               final Timestamp? timestamp = order['createdAt'] as Timestamp?;
//               final DateTime? createdAt = timestamp?.toDate();
//               // Retrieve quotation data stored inside the order.
//               final Map<String, dynamic> quotationData =
//                   order['quotation'] as Map<String, dynamic>? ?? {};
//               final companyName =
//                   quotationData['companyName'] as String? ?? 'N/A';
//               final totalAmount = quotationData['totalAmount'] != null
//                   ? (quotationData['totalAmount'] as num).toDouble()
//                   : 0.0;

//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ListTile(
//                   title: Text("Order ID: $orderId"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Company: $companyName"),
//                       Text("Total Amount: \$${totalAmount.toStringAsFixed(2)}"),
//                       if (createdAt != null)
//                         Text(
//                             "Created At: ${DateFormat.yMMMd().add_jm().format(createdAt)}"),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_providers.dart'; // Provides customAuthStateProvider
import '../providers/order_provider.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  Future<void> _refreshOrders() async {
    // This simply triggers a rebuild by calling setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(customAuthStateProvider);
    final bool isAdmin = currentUser != null && currentUser.role == 'admin';
    final String userId = currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ref
            .read(orderProvider.notifier)
            .fetchOrders(userId, isAdmin: isAdmin),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text("No orders found."));
          }
          return RefreshIndicator(
            onRefresh: _refreshOrders,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final order = orders[index];
                final orderId = order['orderId'] as String? ?? 'N/A';
                final Timestamp? timestamp = order['createdAt'] as Timestamp?;
                final DateTime? createdAt = timestamp?.toDate();
                // Retrieve quotation data stored inside the order.
                final Map<String, dynamic> quotationData =
                    order['quotation'] as Map<String, dynamic>? ?? {};
                final companyName =
                    quotationData['companyName'] as String? ?? 'N/A';
                final totalAmount = quotationData['totalAmount'] != null
                    ? (quotationData['totalAmount'] as num).toDouble()
                    : 0.0;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      context.goNamed(
                        'orderDetail',
                        pathParameters: {'id': orderId},
                        extra: order,
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Order ID: $orderId",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (createdAt != null)
                                Text(
                                  DateFormat.yMMMd().format(createdAt),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Company: $companyName",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (createdAt != null)
                            Text(
                              "Created At: ${DateFormat.yMMMd().add_jm().format(createdAt)}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
