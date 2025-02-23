// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:go_router/go_router.dart';
// import '../../auth/providers/auth_providers.dart'; // Provides customAuthStateProvider
// import '../providers/order_provider.dart';

// class OrdersScreen extends ConsumerStatefulWidget {
//   const OrdersScreen({super.key});

//   @override
//   ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends ConsumerState<OrdersScreen> {
//   Future<void> _refreshOrders() async {
//     // This simply triggers a rebuild by calling setState
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = ref.watch(customAuthStateProvider);
//     final bool isAdmin = currentUser != null && currentUser.role == 'admin';
//     final String userId = currentUser?.id ?? '';

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
//           return RefreshIndicator(
//             onRefresh: _refreshOrders,
//             child: ListView.separated(
//               padding: const EdgeInsets.all(16),
//               itemCount: orders.length,
//               separatorBuilder: (context, index) => const SizedBox(height: 16),
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 final orderId = order['orderId'] as String? ?? 'N/A';
//                 final Timestamp? timestamp = order['createdAt'] as Timestamp?;
//                 final DateTime? createdAt = timestamp?.toDate();
//                 // Retrieve quotation data stored inside the order.
//                 final Map<String, dynamic> quotationData =
//                     order['quotation'] as Map<String, dynamic>? ?? {};
//                 final companyName =
//                     quotationData['companyName'] as String? ?? 'N/A';
//                 final totalAmount = quotationData['totalAmount'] != null
//                     ? (quotationData['totalAmount'] as num).toDouble()
//                     : 0.0;

//                 return Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       context.goNamed(
//                         'orderDetail',
//                         pathParameters: {'id': orderId},
//                         extra: order,
//                       );
//                     },
//                     borderRadius: BorderRadius.circular(12),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "Order ID: $orderId",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               if (createdAt != null)
//                                 Text(
//                                   DateFormat.yMMMd().format(createdAt),
//                                   style: TextStyle(
//                                     color: Color.fromARGB(255, 99, 99, 99),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Company: $companyName",
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Total Amount: ${totalAmount.toStringAsFixed(2)}",
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           if (createdAt != null)
//                             Text(
//                               "Created At: ${DateFormat.yMMMd().add_jm().format(createdAt)}",
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Color.fromARGB(255, 99, 99, 99),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshOrders() async {
    setState(() {}); // Trigger rebuild for refresh
  }

  // Filter orders based on search query.
  List<Map<String, dynamic>> _filterOrders(List<Map<String, dynamic>> orders) {
    if (_searchQuery.isEmpty) return orders;
    return orders.where((order) {
      final orderId = (order['orderId'] as String? ?? 'N/A').toLowerCase();
      final quotationData =
          order['quotation'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final companyName =
          (quotationData['companyName'] as String? ?? 'N/A').toLowerCase();
      // Check product names if available.
      bool productMatch = false;
      if (quotationData['items'] is List) {
        for (var item in quotationData['items']) {
          final productName =
              (item['productName']?.toString() ?? '').toLowerCase();
          if (productName.contains(_searchQuery)) {
            productMatch = true;
            break;
          }
        }
      }
      return orderId.contains(_searchQuery) ||
          companyName.contains(_searchQuery) ||
          productMatch;
    }).toList();
  }

  /// Build the search field widget.
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by ID, Company or Product',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _searchController.clear(),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(customAuthStateProvider);
    final bool isAdmin = currentUser != null && currentUser.role == 'admin';
    final String userId = currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
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
                List<Map<String, dynamic>> orders = snapshot.data ?? [];
                orders = _filterOrders(orders);
                if (orders.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refreshOrders,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        Center(
                            child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("No orders found."),
                        )),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _refreshOrders,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final orderId = order['orderId'] as String? ?? 'N/A';
                      final Timestamp? timestamp =
                          order['createdAt'] as Timestamp?;
                      final DateTime? createdAt = timestamp?.toDate();
                      final Map<String, dynamic> quotationData =
                          order['quotation'] as Map<String, dynamic>? ??
                              <String, dynamic>{};
                      final companyName =
                          quotationData['companyName'] as String? ?? 'N/A';
                      final totalAmount = quotationData['totalAmount'] != null
                          ? (quotationData['totalAmount'] as num).toDouble()
                          : 0.0;

                      return SizedBox(
                        height: 140, // Fixed height for order card.
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () {
                              context.goNamed(
                                'orderDetail',
                                pathParameters: {'id': orderId},
                                extra: order,
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Leading Icon / Avatar.
                                  CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    radius: 28,
                                    child: const Icon(Icons.shopping_cart,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  // Order details.
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Order ID: $orderId",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Company: $companyName",
                                          style: const TextStyle(fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Total: \$${totalAmount.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        if (createdAt != null)
                                          Text(
                                            "Created: ${DateFormat.yMMMd().add_jm().format(createdAt)}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // Trailing creation date.
                                  if (createdAt != null)
                                    Text(
                                      DateFormat.yMMMd().format(createdAt),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
