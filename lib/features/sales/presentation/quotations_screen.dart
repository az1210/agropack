import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/quotation_model.dart';
import '../providers/quotation_provider.dart';
import '../../auth/providers/auth_providers.dart'; // Exports customAuthStateProvider.

class QuotationScreen extends ConsumerWidget {
  const QuotationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current user from the custom auth state.
    final customUser = ref.watch(customAuthStateProvider);
    if (customUser == null) {
      return const Center(child: Text('No user logged in'));
    }
    // Check the role of the user.
    final String role = customUser.role;
    final String userId = customUser.id;

    // Depending on the role, fetch quotations accordingly.
    final Future<List<Quotation>> quotationsFuture = role == 'admin'
        ? ref.read(quotationProvider.notifier).fetchAllQuotations()
        : ref.read(quotationProvider.notifier).fetchQuotationsForUser(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotations'),
      ),
      body: FutureBuilder<List<Quotation>>(
        future: quotationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final quotations = snapshot.data ?? [];
            if (quotations.isEmpty) {
              return const Center(child: Text('No quotations available.'));
            }
            return ListView.builder(
              itemCount: quotations.length,
              itemBuilder: (context, index) {
                final quotation = quotations[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(quotation.companyName ?? 'No Company'),
                    subtitle: Text('Product: ${quotation.productName}'),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // Implement your PDF generation/download logic here.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Generating PDF...')),
                        );
                      },
                    ),
                    onTap: () {
                      // Navigate to the detail screen.
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Create Quotation screen.
          context.goNamed('createQuotation');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
