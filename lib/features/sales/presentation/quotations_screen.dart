// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../../models/quotation_model.dart';
// import '../providers/quotation_provider.dart';
// import '../../auth/providers/auth_providers.dart'; // Exports customAuthStateProvider.

// class QuotationScreen extends ConsumerWidget {
//   const QuotationScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Get the current user from the custom auth state.
//     final customUser = ref.watch(customAuthStateProvider);
//     if (customUser == null) {
//       return const Center(child: Text('No user logged in'));
//     }
//     // Check the role of the user.
//     final String role = customUser.role;
//     final String userId = customUser.id;

//     // Depending on the role, fetch quotations accordingly.
//     final Future<List<Quotation>> quotationsFuture = role == 'admin'
//         ? ref.read(quotationProvider.notifier).fetchAllQuotations()
//         : ref.read(quotationProvider.notifier).fetchQuotationsForUser(userId);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quotations'),
//       ),
//       body: FutureBuilder<List<Quotation>>(
//         future: quotationsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final quotations = snapshot.data ?? [];
//             if (quotations.isEmpty) {
//               return const Center(child: Text('No quotations available.'));
//             }
//             return ListView.builder(
//               itemCount: quotations.length,
//               itemBuilder: (context, index) {
//                 final quotation = quotations[index];
//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     title: Text(quotation.companyName ?? 'No Company'),
//                     subtitle: Text('Product: ${quotation.productName}'),
//                     trailing: IconButton(
//                       icon: const Icon(
//                         Icons.picture_as_pdf,
//                         color: Colors.red,
//                       ),
//                       onPressed: () {
//                         // Implement your PDF generation/download logic here.
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Generating PDF...')),
//                         );
//                       },
//                     ),
//                     onTap: () {
//                       // Navigate to the detail screen.
//                       context.goNamed(
//                         'quotationDetail',
//                         pathParameters: {'id': quotation.id!},
//                         extra: quotation,
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to the Create Quotation screen.
//           context.goNamed('createQuotation');
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../models/quotation_model.dart';
import '../providers/quotation_provider.dart';
import '../../auth/providers/auth_providers.dart'; // Exports customAuthStateProvider

class QuotationScreen extends ConsumerStatefulWidget {
  const QuotationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends ConsumerState<QuotationScreen> {
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

  // Helper method to filter quotations based on status and search query.
  List<Quotation> _filterQuotations(List<Quotation> quotations, String status) {
    return quotations.where((q) {
      final matchesStatus = q.status?.toLowerCase() == status.toLowerCase();
      final matchesSearch =
          q.companyName?.toLowerCase().contains(_searchQuery) ?? false;
      return matchesStatus && matchesSearch;
    }).toList();
  }

  Future<List<Quotation>> _fetchQuotations(String role, String userId) async {
    if (role == 'admin') {
      return await ref.read(quotationProvider.notifier).fetchAllQuotations();
    } else {
      return await ref
          .read(quotationProvider.notifier)
          .fetchQuotationsForUser(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read current custom user.
    final customUser = ref.watch(customAuthStateProvider);
    if (customUser == null) {
      return const Center(child: Text('No user logged in'));
    }
    final role = customUser.role;
    final userId = customUser.id;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quotations'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
                // Rounded search box.
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by Company Name...',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // Tabs for Pending and Approved.
                const TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: 'Pending'),
                    Tab(text: 'Approved'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Call your sign-out function (ensure it's implemented properly)
                await signOutUser(ref);
                context.goNamed('login');
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Quotation>>(
          future: _fetchQuotations(role, userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final quotations = snapshot.data ?? [];
              // Wrap in TabBarView to show different filtered lists.
              return TabBarView(
                children: [
                  // Pending quotations
                  _buildQuotationList(
                    _filterQuotations(quotations, 'pending_admin_verification'),
                    isPending: true,
                  ),
                  // Approved quotations
                  _buildQuotationList(
                    _filterQuotations(quotations, 'approved'),
                    isPending: false,
                  ),
                ],
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the Create Quotation screen.
            context.goNamed('createQuotation');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildQuotationList(List<Quotation> quotations,
      {required bool isPending}) {
    if (quotations.isEmpty) {
      return const Center(child: Text('No quotations available.'));
    }
    return ListView.builder(
      itemCount: quotations.length,
      itemBuilder: (context, index) {
        final quotation = quotations[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(quotation.companyName ?? 'No Company'),
            subtitle: Text(
                'Product: ${quotation.items != null && quotation.items!.isNotEmpty ? quotation.items![0].productName ?? 'N/A' : 'N/A'}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPending)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Confirm deletion before calling delete.
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this quotation?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirm == true) {
                        try {
                          await ref
                              .read(quotationProvider.notifier)
                              .deleteQuotation(quotation);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Quotation deleted successfully')),
                          );
                          // Force a rebuild by calling setState if needed.
                          setState(() {});
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                  ),
                IconButton(
                  icon: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    // Implement PDF generation/download logic.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generating PDF...')),
                    );
                  },
                ),
              ],
            ),
            onTap: () {
              // Navigate to the quotation detail screen.
              context.goNamed(
                'quotationDetail',
                pathParameters: {'id': quotation.id!},
                extra: quotation,
              );
            },
          ),
        );
      },
    );
  }
}
