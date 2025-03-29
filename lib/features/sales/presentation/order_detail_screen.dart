// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:go_router/go_router.dart';

// class OrderDetailScreen extends ConsumerWidget {
//   final Map<String, dynamic> orderData;

//   const OrderDetailScreen({Key? key, required this.orderData})
//       : super(key: key);

//   // PDF generator for Challan
//   Future<void> _downloadChallan(BuildContext context) async {
//     final pdf = pw.Document();
//     final data = await rootBundle
//         .load('assets/images/challan_bg.png'); // Ensure asset exists
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
//                 child: pw.Text(
//                   'Challan',
//                   style: pw.TextStyle(
//                       fontSize: 30, fontWeight: pw.FontWeight.bold),
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

//   // PDF generator for Bill
//   Future<void> _downloadBill(BuildContext context) async {
//     final pdf = pw.Document();
//     final data = await rootBundle
//         .load('assets/images/bill_bg.png'); // Ensure asset exists
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
//                 child: pw.Text(
//                   'Bill',
//                   style: pw.TextStyle(
//                       fontSize: 30, fontWeight: pw.FontWeight.bold),
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

//   Widget _buildDetailRow(String title, String value, BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text("$title:",
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//           ),
//           Expanded(
//             flex: 5,
//             child: Text(value, style: const TextStyle(color: Colors.black54)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildItemCard(
//       BuildContext context, int index, Map<String, dynamic> item) {
//     final productName = item['productName'] ?? 'N/A';
//     final quantity =
//         item['quantity'] != null ? item['quantity'].toString() : 'N/A';
//     final unitPrice = item['unitPrice'] != null
//         ? (item['unitPrice'] as num).toStringAsFixed(0)
//         : 'N/A';
//     final amount = item['amount'] != null
//         ? (item['amount'] as num).toStringAsFixed(0)
//         : 'N/A';

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Item ${index + 1}",
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             _buildDetailRow("Product", productName, context),
//             _buildDetailRow("Quantity", quantity, context),
//             _buildDetailRow("Unit Price", unitPrice, context),
//             _buildDetailRow("Amount", amount, context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton(BuildContext context, IconData icon, String label,
//       VoidCallback onPressed) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       onPressed: onPressed,
//       icon: Icon(icon, size: 20),
//       label: Text(label, style: const TextStyle(fontSize: 14)),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final String orderId = orderData['orderId'] ?? 'N/A';
//     final Timestamp? ts = orderData['createdAt'] as Timestamp?;
//     final DateTime? createdAt = ts?.toDate();
//     final Map<String, dynamic> quotation =
//         orderData['quotation'] as Map<String, dynamic>? ?? {};
//     final String companyName = quotation['companyName'] ?? 'N/A';
//     final double totalAmount = quotation['totalAmount'] != null
//         ? (quotation['totalAmount'] as num).toDouble()
//         : 0.0;
//     final List<dynamic> items = quotation['items'] as List<dynamic>? ?? [];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Order Details"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             context.goNamed('orders');
//           },
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: [
//           // Header with Gradient Background
//           SliverToBoxAdapter(
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Theme.of(context).primaryColor, Colors.blueAccent],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(24),
//                   bottomRight: Radius.circular(24),
//                 ),
//               ),
//               padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Order #$orderId",
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyLarge
//                         ?.copyWith(color: Colors.white),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Placed on: ${createdAt != null ? DateFormat.yMMMd().add_jm().format(createdAt) : 'N/A'}",
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodySmall
//                         ?.copyWith(color: Colors.white70),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     companyName,
//                     style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                         color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Total: ${totalAmount.toStringAsFixed(2)}",
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium
//                         ?.copyWith(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Main Content: Details, Items, and Actions (all in one card)
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16)),
//                 elevation: 3,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Order Items",
//                           style: Theme.of(context).textTheme.bodyLarge),
//                       const Divider(thickness: 1.2),
//                       if (items.isNotEmpty)
//                         ...List.generate(items.length, (index) {
//                           final item = items[index] as Map<String, dynamic>;
//                           return _buildItemCard(context, index, item);
//                         })
//                       else
//                         const Text("No items found."),
//                       const SizedBox(height: 16),
//                       // Actions Section inside the same card
//                       const Divider(thickness: 1.2),
//                       Wrap(
//                         alignment: WrapAlignment.spaceEvenly,
//                         spacing: 12,
//                         runSpacing: 12,
//                         children: [
//                           _buildActionButton(context, Icons.payment, "Payment",
//                               () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text("Payment action triggered")));
//                           }),
//                           _buildActionButton(
//                               context, Icons.local_shipping, "Shipped", () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text("Shipped action triggered")));
//                           }),
//                           _buildActionButton(context, Icons.delivery_dining,
//                               "Partial Delivered", () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text(
//                                         "Partial Delivered action triggered")));
//                           }),
//                           _buildActionButton(
//                               context, Icons.check_circle, "Delivered", () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content:
//                                         Text("Delivered action triggered")));
//                           }),
//                           _buildActionButton(context, Icons.download, "Challan",
//                               () async {
//                             await _downloadChallan(context);
//                           }),
//                           _buildActionButton(context, Icons.download, "Bill",
//                               () async {
//                             await _downloadBill(context);
//                           }),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';

import '../../auth/providers/auth_providers.dart';

class OrderDetailScreen extends ConsumerWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailScreen({super.key, required this.orderData});

  // PDF generator for Challan
  Future<void> _downloadChallan(BuildContext context) async {
    final pdf = pw.Document();
    final data = await rootBundle
        .load('assets/images/challan_bg.png'); // Ensure asset exists
    final bgImage = pw.MemoryImage(data.buffer.asUint8List());
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                  child: pw.Image(bgImage, fit: pw.BoxFit.cover)),
              pw.Center(
                child: pw.Text(
                  'Challan',
                  style: pw.TextStyle(
                      fontSize: 30, fontWeight: pw.FontWeight.bold),
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

  // PDF generator for Bill
  Future<void> _downloadBill(BuildContext context) async {
    final pdf = pw.Document();
    final data = await rootBundle
        .load('assets/images/bill_bg.png'); // Ensure asset exists
    final bgImage = pw.MemoryImage(data.buffer.asUint8List());
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                  child: pw.Image(bgImage, fit: pw.BoxFit.cover)),
              pw.Center(
                child: pw.Text(
                  'Bill',
                  style: pw.TextStyle(
                      fontSize: 30, fontWeight: pw.FontWeight.bold),
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

  Widget _buildDetailRow(String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text("$title:",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 5,
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
      BuildContext context, int index, Map<String, dynamic> item) {
    // Basic fields.
    final productName = item['productName'] ?? 'N/A';
    final quantity =
        item['quantity'] != null ? item['quantity'].toString() : 'N/A';
    final unitPrice = item['unitPrice'] != null
        ? (item['unitPrice'] as num).toStringAsFixed(0)
        : 'N/A';
    final amount = item['amount'] != null
        ? (item['amount'] as num).toStringAsFixed(0)
        : 'N/A';

    final marka = item['marka'] ?? 'N/A';
    final film = item['film'] ?? 'N/A';
    final fabricColor = item['fabricColor'] ?? 'N/A';
    final itemId = item['itemId'] ?? 'N/A';
    final weight = item['weight'] != null ? item['weight'].toString() : 'N/A';
    final deliveryDateStr = item['deliveryDate'] ?? 'N/A';
    String formattedDeliveryDate = 'N/A';
    if (deliveryDateStr != 'N/A') {
      final parsedDate = DateTime.tryParse(deliveryDateStr);
      if (parsedDate != null) {
        formattedDeliveryDate = DateFormat.yMMMd().format(parsedDate);
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Item ${index + 1}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildDetailRow("Item ID", itemId, context),
            _buildDetailRow("Product", productName, context),
            _buildDetailRow("Amount", amount, context),
            _buildDetailRow("Marka", marka, context),
            _buildDetailRow("Film/Block", film, context),
            _buildDetailRow("Fabric Color", fabricColor, context),
            _buildDetailRow("Weight (gm)", weight, context),
            _buildDetailRow("Quantity", quantity, context),
            _buildDetailRow("Unit Price", unitPrice, context),
            _buildDetailRow("Delivery Date", formattedDeliveryDate, context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      label: Text(label,
          style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(customAuthStateProvider);
    final bool isAdmin = currentUser != null && currentUser.role == 'admin';
    final String orderId = orderData['orderId'] ?? 'N/A';
    final Timestamp? ts = orderData['createdAt'] as Timestamp?;
    final DateTime? createdAt = ts?.toDate();
    final Map<String, dynamic> quotation =
        orderData['quotation'] as Map<String, dynamic>? ?? {};
    final String companyName = quotation['companyName'] ?? 'N/A';
    final double totalAmount = quotation['totalAmount'] != null
        ? (quotation['totalAmount'] as num).toDouble()
        : 0.0;
    final List<dynamic> items = quotation['items'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (isAdmin) {
              context.goNamed('adminOrders');
            } else {
              context.goNamed('orders');
            }
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Header with Gradient Background.
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #$orderId",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Placed on: ${createdAt != null ? DateFormat.yMMMd().add_jm().format(createdAt) : 'N/A'}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    companyName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Total: ${totalAmount.toStringAsFixed(2)}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          // Main Content: Details, Items, and Actions.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order Items",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const Divider(thickness: 1.2),
                      if (items.isNotEmpty)
                        ...List.generate(items.length, (index) {
                          final item = items[index] as Map<String, dynamic>;
                          return _buildItemCard(context, index, item);
                        })
                      else
                        const Text("No items found."),
                      const SizedBox(height: 16),
                      // Actions Section inside the same card.
                      const Divider(thickness: 1.2),
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildActionButton(context, Icons.payment, "Payment",
                              () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Payment action triggered")));
                          }),
                          _buildActionButton(
                            context,
                            Icons.local_shipping,
                            "Shipped",
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Shipped action triggered")));
                            },
                          ),
                          _buildActionButton(context, Icons.delivery_dining,
                              "Partial Delivered", () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Partial Delivered action triggered")));
                          }),
                          _buildActionButton(
                              context, Icons.check_circle, "Delivered", () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Delivered action triggered")));
                          }),
                          _buildActionButton(
                            context,
                            Icons.download,
                            "Challan",
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Challan action triggered")));
                            },
                          ),
                          _buildActionButton(
                            context,
                            Icons.download,
                            "Bill",
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Bill action triggered")));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
