// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:go_router/go_router.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class OrderDetailScreen extends ConsumerWidget {
//   final Map<String, dynamic> orderData;

//   const OrderDetailScreen({super.key, required this.orderData});

//   // Helper: Generate PDF for Challan (example implementation)
//   Future<void> _downloadChallan(BuildContext context) async {
//     final pdf = pw.Document();
//     final data =
//         await rootBundle.load('assets/images/challan_bg.png'); // Use your asset
//     final bgImage = pw.MemoryImage(data.buffer.asUint8List());
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Stack(
//             children: [
//               pw.Positioned.fill(
//                   child: pw.Image(bgImage, fit: pw.BoxFit.cover)),
//               pw.Center(
//                   child: pw.Text('Challan', style: pw.TextStyle(fontSize: 30))),
//             ],
//           );
//         },
//       ),
//     );
//     await Printing.layoutPdf(
//         onLayout: (PdfPageFormat format) async => pdf.save());
//   }

//   // Helper: Generate PDF for Bill (example implementation)
//   Future<void> _downloadBill(BuildContext context) async {
//     final pdf = pw.Document();
//     final data =
//         await rootBundle.load('assets/images/bill_bg.png'); // Use your asset
//     final bgImage = pw.MemoryImage(data.buffer.asUint8List());
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Stack(
//             children: [
//               pw.Positioned.fill(
//                   child: pw.Image(bgImage, fit: pw.BoxFit.cover)),
//               pw.Center(
//                   child: pw.Text('Bill', style: pw.TextStyle(fontSize: 30))),
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
//     // Extract order and quotation details.
//     final orderId = orderData['orderId'] ?? 'N/A';
//     final Timestamp? ts = orderData['createdAt'] as Timestamp?;
//     final DateTime? createdAt = ts?.toDate();
//     final Map<String, dynamic> quotation =
//         orderData['quotation'] as Map<String, dynamic>? ?? {};
//     final companyName = quotation['companyName'] ?? 'N/A';
//     final totalAmount = quotation['totalAmount'] != null
//         ? (quotation['totalAmount'] as num).toDouble()
//         : 0.0;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Detail'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Order Info Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     "Order ID: $orderId",
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ),
//                 if (createdAt != null)
//                   Text(
//                     DateFormat.yMMMd().format(createdAt),
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Quotation Info (similar to quotation detail screen)
//             Text("Company: $companyName", style: const TextStyle(fontSize: 14)),
//             const SizedBox(height: 8),
//             Text(
//               "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             // (Add more details as required from the quotation if needed)
//             const Divider(),
//             const SizedBox(height: 16),
//             // Action Buttons Row(s)
//             Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Payment functionality
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Payment pressed')));
//                   },
//                   child: const Text("Payment"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Shipped functionality
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Shipped pressed')));
//                   },
//                   child: const Text("Shipped"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Partial Delivered functionality
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                         content: Text('Partial Delivered pressed')));
//                   },
//                   child: const Text("Partial Delivered"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Delivered functionality
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Delivered pressed')));
//                   },
//                   child: const Text("Delivered"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await _downloadChallan(context);
//                   },
//                   child: const Text("Download Challan"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await _downloadBill(context);
//                   },
//                   child: const Text("Download Bill"),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // You can include additional details below or actions as needed.
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';

class OrderDetailScreen extends ConsumerWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailScreen({Key? key, required this.orderData})
      : super(key: key);

  // PDF generator for Challan
  Future<void> _downloadChallan(BuildContext context) async {
    final pdf = pw.Document();
    final data = await rootBundle
        .load('assets/images/challan_bg.png'); // Ensure this asset exists
    final bgImage = pw.MemoryImage(data.buffer.asUint8List());
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Image(bgImage, fit: pw.BoxFit.cover),
              ),
              pw.Center(
                child: pw.Text('Challan',
                    style: pw.TextStyle(
                        fontSize: 30, fontWeight: pw.FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // PDF generator for Bill
  Future<void> _downloadBill(BuildContext context) async {
    final pdf = pw.Document();
    final data = await rootBundle
        .load('assets/images/bill_bg.png'); // Ensure this asset exists
    final bgImage = pw.MemoryImage(data.buffer.asUint8List());
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Image(bgImage, fit: pw.BoxFit.cover),
              ),
              pw.Center(
                child: pw.Text('Bill',
                    style: pw.TextStyle(
                        fontSize: 30, fontWeight: pw.FontWeight.bold)),
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
    // Extract order details from the orderData map.
    final String orderId = orderData['orderId'] ?? 'N/A';
    final Timestamp? ts = orderData['createdAt'] as Timestamp?;
    final DateTime? createdAt = ts?.toDate();
    final Map<String, dynamic> quotation =
        orderData['quotation'] as Map<String, dynamic>? ?? {};
    final String companyName = quotation['companyName'] ?? 'N/A';
    final double totalAmount = quotation['totalAmount'] != null
        ? (quotation['totalAmount'] as num).toDouble()
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header Card with Order Information
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order ID & Created Date Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order ID: $orderId",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (createdAt != null)
                            Text(
                              DateFormat.yMMMd().format(createdAt),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Company Name
                      Text(
                        "Company: $companyName",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      // Total Amount
                      Text(
                        "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // Detailed Created At (optional)
                      if (createdAt != null)
                        Text(
                          "Created At: ${DateFormat.yMMMd().add_jm().format(createdAt)}",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Action Buttons Section
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement Payment action logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Payment action triggered")),
                      );
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text("Payment"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement Shipped action logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Shipped action triggered")),
                      );
                    },
                    icon: const Icon(Icons.local_shipping),
                    label: const Text("Shipped"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement Partial Delivered action logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Partial Delivered action triggered")),
                      );
                    },
                    icon: const Icon(Icons.delivery_dining),
                    label: const Text("Partial Delivered"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement Delivered action logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Delivered action triggered")),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text("Delivered"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _downloadChallan(context);
                    },
                    icon: const Icon(Icons.download),
                    label: const Text("Download Challan"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _downloadBill(context);
                    },
                    icon: const Icon(Icons.download),
                    label: const Text("Download Bill"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Additional Details Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Order Details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(thickness: 1.2),
                      // Add any further details here
                      Text("Company Name: $companyName",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text("Total Amount: \$${totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 16)),
                      // You can list additional information as needed.
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
