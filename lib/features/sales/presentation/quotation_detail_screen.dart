// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import '../../../models/quotation_model.dart';
// import '../providers/quotation_provider.dart';
// import '../../auth/providers/auth_providers.dart';

// class QuotationDetailScreen extends ConsumerWidget {
//   final Quotation quotation;
//   const QuotationDetailScreen({super.key, required this.quotation});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Read the current user from your custom auth state.
//     final customUser = ref.watch(customAuthStateProvider);
//     final bool isSales = customUser != null && customUser.role == 'sales';

//     // Build table rows for each field.
//     final rows = <DataRow>[
//       DataRow(cells: [
//         const DataCell(Text("Company")),
//         DataCell(Text(quotation.companyName ?? 'N/A')),
//       ]),
//       DataRow(cells: [
//         const DataCell(Text("Product")),
//         DataCell(Text(quotation.productName ?? 'N/A')),
//       ]),
//       DataRow(cells: [
//         const DataCell(Text("Marka")),
//         DataCell(Text(quotation.marka ?? 'N/A')),
//       ]),
//       DataRow(cells: [
//         const DataCell(Text("Film")),
//         DataCell(Text(quotation.film ?? 'N/A')),
//       ]),
//       DataRow(cells: [
//         const DataCell(Text("Fabric Color")),
//         DataCell(Text(quotation.fabricColor ?? 'N/A')),
//       ]),
//       DataRow(cells: [
//         const DataCell(Text("Weight (gm)")),
//         DataCell(Text(quotation.weight?.toString() ?? 'N/A')),
//       ]),
//       DataRow(cells: [
//         const DataCell(Text("Quantity")),
//         DataCell(Text(quotation.quantity?.toString() ?? 'N/A')),
//       ]),
//       DataRow(cells: [
//         const DataCell(Text("Delivery Date")),
//         DataCell(Text(quotation.deliveryDate != null
//             ? DateFormat.yMMMd().format(quotation.deliveryDate!)
//             : 'N/A')),
//       ]),
//       DataRow(cells: [
//         const DataCell(Text("Status")),
//         DataCell(Text(quotation.status ?? 'N/A')),
//       ]),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quotation Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             DataTable(
//               headingRowColor: MaterialStateColor.resolveWith(
//                   (states) => Colors.grey.shade200),
//               columns: const [
//                 DataColumn(
//                     label: Text(
//                   "Field",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 )),
//                 DataColumn(
//                     label: Text(
//                   "Value",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 )),
//               ],
//               rows: rows,
//             ),
//             const SizedBox(height: 24),
//             if (isSales)
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   await ref
//                       .read(quotationProvider.notifier)
//                       .confirmOrder(quotation);
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Order confirmed!')),
//                     );
//                   }
//                 },
//                 icon: const Icon(Icons.check),
//                 label: const Text("Confirm Order"),
//                 style: ElevatedButton.styleFrom(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // TODO: Integrate PDF generation/download.
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Generating PDF...')),
//                 );
//               },
//               icon: const Icon(Icons.picture_as_pdf),
//               label: const Text("Download PDF"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                 textStyle: const TextStyle(fontSize: 16),
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
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../models/quotation_model.dart';
import '../providers/quotation_provider.dart';
import '../../auth/providers/auth_providers.dart';

class QuotationDetailScreen extends ConsumerWidget {
  final Quotation quotation;
  const QuotationDetailScreen({super.key, required this.quotation});

  // Function to generate a PDF for the given quotation.
  Future<void> generateQuotationPdf(Quotation quotation) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Quotation Details",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Field', 'Value'],
                  <String>['Company', quotation.companyName ?? 'N/A'],
                  <String>['Product', quotation.productName ?? 'N/A'],
                  <String>['Marka', quotation.marka ?? 'N/A'],
                  <String>['Film', quotation.film ?? 'N/A'],
                  <String>['Fabric Color', quotation.fabricColor ?? 'N/A'],
                  <String>[
                    'Weight (gm)',
                    quotation.weight?.toString() ?? 'N/A'
                  ],
                  <String>['Quantity', quotation.quantity?.toString() ?? 'N/A'],
                  <String>[
                    'Delivery Date',
                    quotation.deliveryDate != null
                        ? DateFormat.yMMMd().format(quotation.deliveryDate!)
                        : 'N/A'
                  ],
                  <String>['Status', quotation.status ?? 'N/A'],
                ],
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current user to determine role.
    final customUser = ref.watch(customAuthStateProvider);
    final bool isSales = customUser != null && customUser.role == 'sales';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotation Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                _buildTableRow("Company", quotation.companyName),
                _buildTableRow("Product", quotation.productName),
                _buildTableRow("Marka", quotation.marka),
                _buildTableRow("Film", quotation.film),
                _buildTableRow("Fabric Color", quotation.fabricColor),
                _buildTableRow("Weight (gm)", quotation.weight?.toString()),
                _buildTableRow("Quantity", quotation.quantity?.toString()),
                _buildTableRow(
                    "Delivery Date",
                    quotation.deliveryDate != null
                        ? DateFormat.yMMMd().format(quotation.deliveryDate!)
                        : null),
                _buildTableRow("Status", quotation.status),
              ],
            ),
            const SizedBox(height: 24),
            if (isSales)
              ElevatedButton.icon(
                onPressed: () async {
                  await ref
                      .read(quotationProvider.notifier)
                      .confirmOrder(quotation);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order confirmed!')),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text("Confirm Order"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                await generateQuotationPdf(quotation);
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Download PDF"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String field, String? value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            field,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value ?? 'N/A'),
        ),
      ],
    );
  }
}
