// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../features/auth/providers/auth_providers.dart';
// import '../providers/payment_provider.dart';

// class PaymentListScreen extends ConsumerStatefulWidget {
//   const PaymentListScreen({super.key});

//   @override
//   ConsumerState<PaymentListScreen> createState() => _PaymentListScreenState();
// }

// class _PaymentListScreenState extends ConsumerState<PaymentListScreen> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final paymentController = ref.read(paymentProvider);
//       final currentUser = ref.read(customAuthStateProvider);
//       final bool isAdmin = currentUser != null && currentUser.role == 'admin';
//       final String? createdBy = isAdmin ? null : currentUser?.id;
//       paymentController.fetchPayments(refresh: true, createdBy: createdBy);
//     });

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200) {
//         final currentUser = ref.read(customAuthStateProvider);
//         final bool isAdmin = currentUser != null && currentUser.role == 'admin';
//         ref
//             .read(paymentProvider)
//             .fetchPayments(createdBy: isAdmin ? null : currentUser?.id);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final paymentController = ref.watch(paymentProvider);
//     final payments = paymentController.payments;

//     // Get current user for empty state message.
//     final currentUser = ref.watch(customAuthStateProvider);
//     final bool isAdmin = currentUser != null && currentUser.role == 'admin';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payments"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             context.pop();
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.add,
//               color: Colors.blue,
//             ),
//             onPressed: () {
//               if (isAdmin) {
//                 context.pushNamed('createPayment');
//               } else {
//                 context.goNamed('userCreatePayment');
//               }
//             },
//           )
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           final currentUser = ref.read(customAuthStateProvider);
//           final bool isAdmin =
//               currentUser != null && currentUser.role == 'admin';
//           await paymentController.fetchPayments(
//               refresh: true, createdBy: isAdmin ? null : currentUser?.id);
//         },
//         child: payments.isEmpty
//             ? ListView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 children: [
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         isAdmin
//                             ? "No payments found."
//                             : "No payments found for your account.",
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             : ListView.builder(
//                 controller: _scrollController,
//                 itemCount:
//                     payments.length + (paymentController.hasMore ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (index < payments.length) {
//                     final payment = payments[index];
//                     return ListTile(
//                         title: Text(payment.paymentId),
//                         subtitle: Text(payment.companyName),
//                         trailing: Text(
//                             "\$${payment.paymentAmount.toStringAsFixed(2)}"),
//                         onTap: () {
//                           if (isAdmin) {
//                             context.pushNamed(
//                               'paymentDetail',
//                               pathParameters: {'id': payment.paymentId},
//                               extra: payment,
//                             );
//                           } else {
//                             context.pushNamed(
//                               'userPaymentDetail',
//                               pathParameters: {'id': payment.paymentId},
//                               extra: payment,
//                             );
//                           }
//                         });
//                   } else {
//                     return const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }
//                 },
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../providers/payment_provider.dart';

class PaymentListScreen extends ConsumerStatefulWidget {
  const PaymentListScreen({super.key});

  @override
  ConsumerState<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends ConsumerState<PaymentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final newQuery = _searchController.text.toLowerCase();
      if (newQuery != _searchQuery) {
        setState(() {
          _searchQuery = newQuery;
        });
      }
    });
    // Delay the fetch until after build to avoid modifying provider during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final paymentController = ref.read(paymentProvider);
      final currentUser = ref.read(customAuthStateProvider);
      final bool isAdmin = currentUser != null && currentUser.role == 'admin';
      final String? createdBy = isAdmin ? null : currentUser?.id;
      paymentController.fetchPayments(refresh: true, createdBy: createdBy);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Builds a search field widget that allows the user to filter payments by payment ID or company name.
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by Payment ID or Company Name...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
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

  /// Helper method to build a payment card.
  Widget _buildPaymentCard(payment, bool isAdmin) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (isAdmin) {
            context.pushNamed(
              'paymentDetail',
              pathParameters: {'id': payment.paymentId},
              extra: payment,
            );
          } else {
            context.pushNamed(
              'userPaymentDetail',
              pathParameters: {'id': payment.paymentId},
              extra: payment,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 28,
                child: Text(
                  payment.paymentId.isNotEmpty
                      ? payment.paymentId[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment ID: ${payment.paymentId}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment.companyName,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "BDT ${payment.paymentAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentController = ref.watch(paymentProvider);
    final payments = paymentController.payments;
    final currentUser = ref.watch(customAuthStateProvider);
    final bool isAdmin = currentUser != null && currentUser.role == 'admin';

    // Filter payments by payment ID or company name.
    final filteredPayments = payments.where((payment) {
      final paymentIdLower = payment.paymentId.toLowerCase();
      final companyNameLower = payment.companyName.toLowerCase();
      return paymentIdLower.contains(_searchQuery) ||
          companyNameLower.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payments"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () {
              if (isAdmin) {
                context.pushNamed('createPayment');
              } else {
                context.goNamed('userCreatePayment');
              }
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final currentUser = ref.read(customAuthStateProvider);
          final bool isAdmin =
              currentUser != null && currentUser.role == 'admin';
          await paymentController.fetchPayments(
              refresh: true, createdBy: isAdmin ? null : currentUser?.id);
        },
        child: paymentController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : payments.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            isAdmin
                                ? "No payments found."
                                : "No payments found for your account.",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                : filteredPayments.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          _buildSearchField(),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: const Text(
                                "No payments match your search.",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: filteredPayments.length + 1,
                        itemBuilder: (context, index) {
                          // Show search field as the first widget.
                          if (index == 0) {
                            return _buildSearchField();
                          }
                          final payment = filteredPayments[index - 1];
                          return _buildPaymentCard(payment, isAdmin);
                        },
                      ),
      ),
    );
  }
}
