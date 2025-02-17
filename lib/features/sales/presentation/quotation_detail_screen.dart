// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import '../../../models/quotation_model.dart';
// import '../providers/quotation_provider.dart';
// import '../../auth/providers/auth_providers.dart';

// class QuotationDetailScreen extends ConsumerWidget {
//   final Quotation quotation;
//   const QuotationDetailScreen({super.key, required this.quotation});

//   // Function to generate a PDF for the given quotation.
//   Future<void> generateQuotationPdf(Quotation quotation) async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text("Quotation Details",
//                   style: pw.TextStyle(
//                       fontSize: 24, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 20),
//               pw.Table.fromTextArray(
//                 context: context,
//                 data: <List<String>>[
//                   <String>['Field', 'Value'],
//                   <String>['Company', quotation.companyName ?? 'N/A'],
//                   <String>['Product', quotation.productName ?? 'N/A'],
//                   <String>['Marka', quotation.marka ?? 'N/A'],
//                   <String>['Film', quotation.film ?? 'N/A'],
//                   <String>['Fabric Color', quotation.fabricColor ?? 'N/A'],
//                   <String>[
//                     'Weight (gm)',
//                     quotation.weight?.toString() ?? 'N/A'
//                   ],
//                   <String>['Quantity', quotation.quantity?.toString() ?? 'N/A'],
//                   <String>[
//                     'Delivery Date',
//                     quotation.deliveryDate != null
//                         ? DateFormat.yMMMd().format(quotation.deliveryDate!)
//                         : 'N/A'
//                   ],
//                   <String>['Status', quotation.status ?? 'N/A'],
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save(),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Get current user to determine role.
//     final customUser = ref.watch(customAuthStateProvider);
//     final bool isSales = customUser != null && customUser.role == 'sales';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quotation Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Table(
//               columnWidths: const {
//                 0: FlexColumnWidth(2),
//                 1: FlexColumnWidth(3),
//               },
//               border: TableBorder.all(color: Colors.grey.shade300),
//               children: [
//                 _buildTableRow("Company", quotation.companyName),
//                 _buildTableRow("Product", quotation.productName),
//                 _buildTableRow("Marka", quotation.marka),
//                 _buildTableRow("Film", quotation.film),
//                 _buildTableRow("Fabric Color", quotation.fabricColor),
//                 _buildTableRow("Weight (gm)", quotation.weight?.toString()),
//                 _buildTableRow("Quantity", quotation.quantity?.toString()),
//                 _buildTableRow(
//                     "Delivery Date",
//                     quotation.deliveryDate != null
//                         ? DateFormat.yMMMd().format(quotation.deliveryDate!)
//                         : null),
//                 _buildTableRow("Status", quotation.status),
//               ],
//             ),
//             const SizedBox(height: 24),
//             if (isSales)
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   await ref
//                       .read(quotationProvider.notifier)
//                       .confirmOrder(quotation);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Order confirmed!')),
//                   );
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
//               onPressed: () async {
//                 await generateQuotationPdf(quotation);
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

//   TableRow _buildTableRow(String field, String? value) {
//     return TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             field,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(value ?? 'N/A'),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import '../../../models/quotation_model.dart';
// import '../providers/quotation_provider.dart';
// import '../../auth/providers/auth_providers.dart';

// class QuotationDetailScreen extends ConsumerWidget {
//   final Quotation quotation;
//   const QuotationDetailScreen({super.key, required this.quotation});

//   Future<void> generateQuotationPdf(Quotation quotation) async {
//     final pdf = pw.Document();
//     // Load a dummy background image.
//     final data = await rootBundle.load('assets/images/agro_pad2.png');
//     final Uint8List bytes = data.buffer.asUint8List();
//     final bgImage = pw.MemoryImage(bytes);

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: pw.EdgeInsets.zero,
//         build: (pw.Context context) {
//           return pw.Stack(
//             children: [
//               // Background image covers the page.
//               pw.Positioned.fill(
//                 child: pw.Image(bgImage, fit: pw.BoxFit.cover),
//               ),
//               // Content overlay.
//               pw.Padding(
//                 padding:
//                     const pw.EdgeInsets.only(top: 150, left: 32, right: 32),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [
//                     // Top header with Company and Date.
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text(
//                           "To\n ${quotation.companyName}",
//                           style: pw.TextStyle(
//                             fontSize: 20,
//                             fontWeight: pw.FontWeight.bold,
//                             color: PdfColors.black,
//                           ),
//                         ),
//                         pw.Text(
//                           '\nDate: ${quotation.createdAt != null ? DateFormat.yMMMd().format(quotation.createdAt!) : 'N/A'}',
//                           style: pw.TextStyle(
//                             fontSize: 16,
//                             color: PdfColors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 24),
//                     pw.Text(
//                       'Quotation',
//                       style: pw.TextStyle(
//                         fontSize: 22,
//                         fontWeight: pw.FontWeight.bold,
//                         decoration: pw.TextDecoration.underline,
//                       ),
//                     ),
//                     pw.SizedBox(height: 12),
//                     // Build table of items with dummy fixed column sizes.
//                     pw.Table(
//                       border: pw.TableBorder.all(color: PdfColors.grey),
//                       columnWidths: {
//                         0: pw.FixedColumnWidth(80), // Product
//                         1: pw.FixedColumnWidth(50), // Marka
//                         2: pw.FixedColumnWidth(25), // Film
//                         3: pw.FixedColumnWidth(40), // Fabric Color
//                         4: pw.FixedColumnWidth(40), // Weight
//                         5: pw.FixedColumnWidth(40), // Quantity
//                         6: pw.FixedColumnWidth(60), // Delivery
//                       },
//                       children: [
//                         // Header row.
//                         pw.TableRow(
//                           decoration:
//                               const pw.BoxDecoration(color: PdfColors.blue),
//                           children: [
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(4),
//                               child: pw.Text('Product',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       color: PdfColors.white)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(4),
//                               child: pw.Text('Marka',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       color: PdfColors.white)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(4),
//                               child: pw.Text('Film',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       color: PdfColors.white)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(4),
//                               child: pw.Text('Fabric Color',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       color: PdfColors.white)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(4),
//                               child: pw.Text('Weight',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       color: PdfColors.white)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(4),
//                               child: pw.Text('Quantity',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       color: PdfColors.white)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(4),
//                               child: pw.Text('Delivery',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       color: PdfColors.white)),
//                             ),
//                           ],
//                         ),
//                         // Data rows.
//                         ...?quotation.items
//                             ?.map(
//                               (item) => pw.TableRow(
//                                 children: [
//                                   pw.Padding(
//                                     padding: const pw.EdgeInsets.all(4),
//                                     child: pw.Text(
//                                       item.productName,
//                                       textAlign: pw.TextAlign.center,
//                                     ),
//                                   ),
//                                   pw.Padding(
//                                     padding: const pw.EdgeInsets.all(4),
//                                     child: pw.Text(
//                                       item.marka ?? 'N/A',
//                                       textAlign: pw.TextAlign.center,
//                                     ),
//                                   ),
//                                   pw.Padding(
//                                     padding: const pw.EdgeInsets.all(4),
//                                     child: pw.Text(
//                                       item.film ?? 'N/A',
//                                       textAlign: pw.TextAlign.center,
//                                     ),
//                                   ),
//                                   pw.Padding(
//                                     padding: const pw.EdgeInsets.all(4),
//                                     child: pw.Text(
//                                       item.fabricColor ?? 'N/A',
//                                       textAlign: pw.TextAlign.center,
//                                     ),
//                                   ),
//                                   pw.Padding(
//                                     padding: const pw.EdgeInsets.all(4),
//                                     child: pw.Text(
//                                       item.weight?.toString() ?? 'N/A',
//                                       textAlign: pw.TextAlign.center,
//                                     ),
//                                   ),
//                                   pw.Padding(
//                                     padding: const pw.EdgeInsets.all(4),
//                                     child: pw.Text(
//                                       item.quantity?.toString() ?? 'N/A',
//                                       textAlign: pw.TextAlign.center,
//                                     ),
//                                   ),
//                                   pw.Padding(
//                                     padding: const pw.EdgeInsets.all(4),
//                                     child: pw.Text(
//                                       item.deliveryDate != null
//                                           ? DateFormat.yMMMd()
//                                               .format(item.deliveryDate!)
//                                           : 'N/A',
//                                       textAlign: pw.TextAlign.center,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                             .toList(),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//     await Printing.layoutPdf(
//         onLayout: (PdfPageFormat format) async => pdf.save());
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Mobile view design.
//     final customUser = ref.watch(customAuthStateProvider);
//     final bool isSales = customUser != null && customUser.role == 'sales';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quotation Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Top Section: Company Name and Date.
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Text(
//                     quotation.companyName,
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleSmall!
//                         .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Text(
//                   'Date: ${quotation.createdAt != null ? DateFormat.yMMMd().format(quotation.createdAt!) : 'N/A'}',
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Section Title.
//             Text(
//               'Items',
//               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                   fontWeight: FontWeight.bold,
//                   decoration: TextDecoration.underline),
//             ),
//             const SizedBox(height: 12),
//             // List of items shown in a vertical list.
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: quotation.items?.length ?? 0,
//               itemBuilder: (context, index) {
//                 final item = quotation.items![index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Text('Item ID: ${item.itemId}',
//                         //     style:
//                         //         const TextStyle(fontWeight: FontWeight.bold)),
//                         // const SizedBox(height: 4),
//                         Text('Product: ${item.productName}'),
//                         Text('Manufacturer: ${item.manufacturer ?? 'N/A'}'),
//                         Text('Marka: ${item.marka ?? 'N/A'}'),
//                         Text('Film: ${item.film ?? 'N/A'}'),
//                         Text('Fabric Color: ${item.fabricColor ?? 'N/A'}'),
//                         Text('Weight: ${item.weight?.toString() ?? 'N/A'}'),
//                         Text('Quantity: ${item.quantity?.toString() ?? 'N/A'}'),
//                         Text(
//                             'Delivery: ${item.deliveryDate != null ? DateFormat.yMMMd().format(item.deliveryDate!) : 'N/A'}'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 24),
//             // Action buttons.
//             if (isSales)
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   await ref
//                       .read(quotationProvider.notifier)
//                       .confirmOrder(quotation);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Order confirmed!')),
//                   );
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
//               onPressed: () async {
//                 await generateQuotationPdf(quotation);
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

import 'package:agro_packaging/features/sales/providers/order_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

  Future<void> generateQuotationPdf(Quotation quotation) async {
    final pdf = pw.Document();
    // Load a dummy background image.
    final data = await rootBundle.load('assets/images/agro_pad2.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final bgImage = pw.MemoryImage(bytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Background image covers the page.
              pw.Positioned.fill(
                child: pw.Image(bgImage, fit: pw.BoxFit.cover),
              ),
              // Content overlay.
              pw.Padding(
                padding:
                    const pw.EdgeInsets.only(top: 150, left: 32, right: 32),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Top header with Company and Date.
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "To\n ${quotation.companyName}",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                        pw.Text(
                          '\nDate: ${quotation.createdAt != null ? DateFormat.yMMMd().format(quotation.createdAt!) : 'N/A'}',
                          style: pw.TextStyle(
                            fontSize: 16,
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 24),
                    pw.Text(
                      'Quotation',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    // Build table of items with additional columns for Unit Price and Amount.
                    pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey),
                      columnWidths: {
                        0: pw.FixedColumnWidth(80), // Product
                        1: pw.FixedColumnWidth(50), // Marka
                        2: pw.FixedColumnWidth(25), // Film
                        3: pw.FixedColumnWidth(40), // Fabric Color
                        4: pw.FixedColumnWidth(40), // Weight
                        5: pw.FixedColumnWidth(40), // Quantity
                        6: pw.FixedColumnWidth(50), // Unit Price
                        7: pw.FixedColumnWidth(50), // Amount
                        8: pw.FixedColumnWidth(60), // Delivery
                      },
                      children: [
                        // Header row.
                        pw.TableRow(
                          decoration:
                              const pw.BoxDecoration(color: PdfColors.blue),
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Product',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Marka',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Film',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Fabric Color',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Weight',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Quantity',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Unit Price',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Amount',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Delivery',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white)),
                            ),
                          ],
                        ),
                        // Data rows.
                        ...?quotation.items
                            ?.map(
                              (item) => pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      item.productName,
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      item.marka ?? 'N/A',
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      item.film ?? 'N/A',
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      item.fabricColor ?? 'N/A',
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      item.weight?.toString() ?? 'N/A',
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      item.quantity?.toString() ?? 'N/A',
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      item.unitPrice != null
                                          ? item.unitPrice!.toStringAsFixed(2)
                                          : 'N/A',
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      item.amount != null
                                          ? item.amount!.toStringAsFixed(2)
                                          : 'N/A',
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(4),
                                    child: pw.Text(
                                      item.deliveryDate != null
                                          ? DateFormat.yMMMd()
                                              .format(item.deliveryDate!)
                                          : 'N/A',
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    // Display Total Amount below the table.
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Total Amount: \$${quotation.totalAmount?.toStringAsFixed(2) ?? 'N/A'}',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mobile view design.
    final customUser = ref.watch(customAuthStateProvider);
    final bool isSales = customUser != null && customUser.role == 'sales';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotation Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Company Name and Date.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    quotation.companyName,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Date: ${quotation.createdAt != null ? DateFormat.yMMMd().format(quotation.createdAt!) : 'N/A'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Section Title.
            Text(
              'Items',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            const SizedBox(height: 12),
            // List of items shown in a vertical list.
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quotation.items?.length ?? 0,
              itemBuilder: (context, index) {
                final item = quotation.items![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Serial numbering for each item.
                        Text(
                          'Item ${index + 1}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text('Product: ${item.productName}'),
                        Text('Manufacturer: ${item.manufacturer ?? 'N/A'}'),
                        Text('Marka: ${item.marka ?? 'N/A'}'),
                        Text('Film: ${item.film ?? 'N/A'}'),
                        Text('Fabric Color: ${item.fabricColor ?? 'N/A'}'),
                        Text('Weight: ${item.weight?.toString() ?? 'N/A'}'),
                        Text('Quantity: ${item.quantity?.toString() ?? 'N/A'}'),
                        Text(
                            'Unit Price: \$${item.unitPrice != null ? item.unitPrice!.toStringAsFixed(2) : 'N/A'}'),
                        Text(
                            'Amount: \$${item.amount != null ? item.amount!.toStringAsFixed(2) : 'N/A'}'),
                        Text(
                          'Delivery: ${item.deliveryDate != null ? DateFormat.yMMMd().format(item.deliveryDate!) : 'N/A'}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Display Total Amount at the bottom.
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total Amount: ${quotation.totalAmount?.toStringAsFixed(2) ?? 'N/A'}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            // Action buttons.
            if (isSales)
              ElevatedButton.icon(
                onPressed: () async {
                  await ref
                      .read(orderProvider.notifier)
                      .confirmOrder(quotation, context);
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
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ),
              label: const Text(
                "Download PDF",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
