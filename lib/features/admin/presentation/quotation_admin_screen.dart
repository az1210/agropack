import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/quotation_model.dart';
import '../../sales/providers/quotation_provider.dart';

class QuotationAdminScreen extends ConsumerWidget {
  const QuotationAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(quotationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Quotation Approval')),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Quotation>>(
              future: controller.fetchAllQuotations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                final quotations = snapshot.data ?? [];
                final pending = quotations
                    .where((q) => q.status == 'pending_admin_verification')
                    .toList();

                return ListView.builder(
                  itemCount: pending.length,
                  itemBuilder: (context, index) {
                    final quote = pending[index];
                    return ListTile(
                      title: Text(quote.companyName),
                      subtitle: Text('Status: ${quote.status}'),
                      onTap: () {
                        // Navigate to an editing screen
                        context.pushNamed('editQuotation');
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
