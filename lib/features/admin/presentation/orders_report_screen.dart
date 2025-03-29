// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import '../../auth/providers/auth_providers.dart';
// import '../../sales/providers/order_provider.dart';

// class OrdersReportScreen extends ConsumerStatefulWidget {
//   const OrdersReportScreen({super.key});

//   @override
//   ConsumerState<OrdersReportScreen> createState() => _OrdersReportScreenState();
// }

// class _OrdersReportScreenState extends ConsumerState<OrdersReportScreen> {
//   DateTime? _fromDate;
//   DateTime? _toDate;

//   Future<void> _selectFromDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _fromDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _fromDate = picked;
//       });
//     }
//   }

//   Future<void> _selectToDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _toDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _toDate = picked;
//       });
//     }
//   }

//   Future<void> _generateReport() async {
//     if (_fromDate == null || _toDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select both From and To dates")),
//       );
//       return;
//     }
//     if (_fromDate!.isAfter(_toDate!)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("From date cannot be after To date")),
//       );
//       return;
//     }

//     // Fetch orders for the current user (or all, if admin).
//     final currentUser = ref.read(customAuthStateProvider);
//     final bool isAdmin = currentUser != null && currentUser.role == 'admin';
//     final String userId = currentUser?.id ?? '';

//     final orders = await ref
//         .read(orderProvider.notifier)
//         .fetchOrders(userId, isAdmin: isAdmin);

//     // Build table data by filtering each order's items based on delivery date.
//     List<List<String>> tableData = [];

//     for (var order in orders) {
//       final quotation = order['quotation'] as Map<String, dynamic>? ?? {};
//       final companyName = quotation['companyName']?.toString() ?? 'N/A';
//       if (quotation['items'] is List) {
//         for (var item in quotation['items']) {
//           DateTime? deliveryDate;
//           try {
//             if (item['deliveryDate'] != null) {
//               deliveryDate = DateTime.parse(item['deliveryDate'].toString());
//             }
//           } catch (e) {
//             deliveryDate = null;
//           }
//           if (deliveryDate != null &&
//               !deliveryDate.isBefore(_fromDate!) &&
//               !deliveryDate.isAfter(_toDate!)) {
//             final productName = item['productName']?.toString() ?? 'N/A';
//             final marka = item['marka']?.toString() ?? 'N/A';
//             final film = item['film']?.toString() ?? 'N/A';
//             final fabricColor = item['fabricColor']?.toString() ?? 'N/A';
//             final weight = item['weight'] != null
//                 ? (item['weight'] as num).toStringAsFixed(2)
//                 : 'N/A';
//             final quantity = item['quantity']?.toString() ?? 'N/A';
//             final unitPrice = item['unitPrice'] != null
//                 ? (item['unitPrice'] as num).toStringAsFixed(2)
//                 : 'N/A';
//             final totalPrice = item['amount'] != null
//                 ? (item['amount'] as num).toStringAsFixed(2)
//                 : 'N/A';
//             final deliveryDateStr = DateFormat.yMMMd().format(deliveryDate);

//             tableData.add([
//               companyName,
//               productName,
//               marka,
//               film,
//               fabricColor,
//               weight,
//               quantity,
//               unitPrice,
//               totalPrice,
//               deliveryDateStr,
//             ]);
//           }
//         }
//       }
//     }

//     // Define table headers.
//     final tableHeaders = [
//       'Company Name',
//       'Product Name',
//       'Marka',
//       'Film',
//       'Fabric Color',
//       'Weight',
//       'Quantity',
//       'Unit Price',
//       'Total Price',
//       'Delivery Date',
//     ];

//     // Create a PDF document in A4 landscape.
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4.landscape,
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Center(
//                 child: pw.Text(
//                   'Orders Report',
//                   style: pw.TextStyle(
//                       fontSize: 22, fontWeight: pw.FontWeight.bold),
//                 ),
//               ),
//               pw.SizedBox(height: 12),
//               pw.Center(
//                 child: pw.Text(
//                   'From: ${DateFormat.yMMMd().format(_fromDate!)}  To: ${DateFormat.yMMMd().format(_toDate!)}',
//                   style: pw.TextStyle(fontSize: 16),
//                 ),
//               ),
//               pw.SizedBox(height: 12),
//               pw.TableHelper.fromTextArray(
//                 headers: tableHeaders,
//                 data: tableData,
//                 headerStyle: pw.TextStyle(
//                   fontSize: 10,
//                   fontWeight: pw.FontWeight.bold,
//                   color: PdfColors.white,
//                 ),
//                 headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
//                 cellStyle: const pw.TextStyle(fontSize: 9),
//                 cellHeight: 30,
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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Orders Report by Delivery Date'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Row for selecting date range.
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => _selectFromDate(context),
//                     child: Text(
//                       _fromDate == null
//                           ? 'Select From Date'
//                           : 'From: ${DateFormat.yMMMd().format(_fromDate!)}',
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => _selectToDate(context),
//                     child: Text(
//                       _toDate == null
//                           ? 'Select To Date'
//                           : 'To: ${DateFormat.yMMMd().format(_toDate!)}',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: _generateReport,
//               icon: const Icon(Icons.download),
//               label: const Text('Generate Report'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//                 backgroundColor: Colors.deepPurple,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// import '../../auth/providers/auth_providers.dart';
// import '../../sales/providers/order_provider.dart';

// enum ReportType { all, delivery, confirmed }

// class OrdersReportScreen extends ConsumerStatefulWidget {
//   const OrdersReportScreen({super.key});

//   @override
//   ConsumerState<OrdersReportScreen> createState() => _OrdersReportScreenState();
// }

// class _OrdersReportScreenState extends ConsumerState<OrdersReportScreen> {
//   // Report type selection.
//   ReportType _selectedReportType = ReportType.all;
//   DateTime? _fromDate;
//   DateTime? _toDate;

//   // For pie chart interactivity.
//   int touchedIndex = -1;

//   Future<void> _selectFromDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _fromDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _fromDate = picked;
//       });
//     }
//   }

//   Future<void> _selectToDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _toDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _toDate = picked;
//       });
//     }
//   }

//   /// Generates the PDF report based on selected report type.
//   Future<void> _generateReport() async {
//     // For delivery and confirmed reports, ensure dates are selected.
//     if (_selectedReportType != ReportType.all) {
//       if (_fromDate == null || _toDate == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please select both From and To dates")),
//         );
//         return;
//       }
//       if (_fromDate!.isAfter(_toDate!)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("From date cannot be after To date")),
//         );
//         return;
//       }
//     }

//     // Get the current user.
//     final currentUser = ref.read(customAuthStateProvider);
//     final bool isAdmin = currentUser != null && currentUser.role == 'admin';
//     final String userId = currentUser?.id ?? '';

//     // Fetch orders from provider.
//     final orders = await ref
//         .read(orderProvider.notifier)
//         .fetchOrders(userId, isAdmin: isAdmin);

//     // Prepare table data and headers based on report type.
//     List<List<String>> tableData = [];
//     List<String> tableHeaders = [
//       'Company Name',
//       'Product Name',
//       'Marka',
//       'Film',
//       'Fabric Color',
//       'Weight',
//       'Quantity',
//       'Unit Price',
//       'Total Price',
//       'Date',
//     ];

//     switch (_selectedReportType) {
//       case ReportType.all:
//         for (var order in orders) {
//           final quotation = order['quotation'] as Map<String, dynamic>? ?? {};
//           final companyName = quotation['companyName']?.toString() ?? 'N/A';
//           if (quotation['items'] is List) {
//             for (var item in quotation['items']) {
//               String dateStr = 'N/A';
//               if (item['deliveryDate'] != null) {
//                 try {
//                   final dt = DateTime.parse(item['deliveryDate'].toString());
//                   dateStr = DateFormat.yMMMd().format(dt);
//                 } catch (e) {
//                   dateStr = 'N/A';
//                 }
//               }
//               tableData.add([
//                 companyName,
//                 item['productName']?.toString() ?? 'N/A',
//                 item['marka']?.toString() ?? 'N/A',
//                 item['film']?.toString() ?? 'N/A',
//                 item['fabricColor']?.toString() ?? 'N/A',
//                 item['weight'] != null
//                     ? (item['weight'] as num).toStringAsFixed(2)
//                     : 'N/A',
//                 item['quantity']?.toString() ?? 'N/A',
//                 item['unitPrice'] != null
//                     ? (item['unitPrice'] as num).toStringAsFixed(2)
//                     : 'N/A',
//                 item['amount'] != null
//                     ? (item['amount'] as num).toStringAsFixed(2)
//                     : 'N/A',
//                 dateStr,
//               ]);
//             }
//           }
//         }
//         break;
//       case ReportType.delivery:
//         for (var order in orders) {
//           final quotation = order['quotation'] as Map<String, dynamic>? ?? {};
//           final companyName = quotation['companyName']?.toString() ?? 'N/A';
//           if (quotation['items'] is List) {
//             for (var item in quotation['items']) {
//               if (item['deliveryDate'] != null) {
//                 try {
//                   final dt = DateTime.parse(item['deliveryDate'].toString());
//                   if (!dt.isBefore(_fromDate!) && !dt.isAfter(_toDate!)) {
//                     tableData.add([
//                       companyName,
//                       item['productName']?.toString() ?? 'N/A',
//                       item['marka']?.toString() ?? 'N/A',
//                       item['film']?.toString() ?? 'N/A',
//                       item['fabricColor']?.toString() ?? 'N/A',
//                       item['weight'] != null
//                           ? (item['weight'] as num).toStringAsFixed(2)
//                           : 'N/A',
//                       item['quantity']?.toString() ?? 'N/A',
//                       item['unitPrice'] != null
//                           ? (item['unitPrice'] as num).toStringAsFixed(2)
//                           : 'N/A',
//                       item['amount'] != null
//                           ? (item['amount'] as num).toStringAsFixed(2)
//                           : 'N/A',
//                       DateFormat.yMMMd().format(dt),
//                     ]);
//                   }
//                 } catch (e) {
//                   // Skip item if date parsing fails.
//                 }
//               }
//             }
//           }
//         }
//         break;
//       case ReportType.confirmed:
//         for (var order in orders) {
//           final Timestamp? ts = order['createdAt'] as Timestamp?;
//           if (ts != null) {
//             final dt = ts.toDate();
//             if (!dt.isBefore(_fromDate!) && !dt.isAfter(_toDate!)) {
//               final quotation =
//                   order['quotation'] as Map<String, dynamic>? ?? {};
//               final companyName = quotation['companyName']?.toString() ?? 'N/A';
//               if (quotation['items'] is List) {
//                 for (var item in quotation['items']) {
//                   tableData.add([
//                     companyName,
//                     item['productName']?.toString() ?? 'N/A',
//                     item['marka']?.toString() ?? 'N/A',
//                     item['film']?.toString() ?? 'N/A',
//                     item['fabricColor']?.toString() ?? 'N/A',
//                     item['weight'] != null
//                         ? (item['weight'] as num).toStringAsFixed(2)
//                         : 'N/A',
//                     item['quantity']?.toString() ?? 'N/A',
//                     item['unitPrice'] != null
//                         ? (item['unitPrice'] as num).toStringAsFixed(2)
//                         : 'N/A',
//                     item['amount'] != null
//                         ? (item['amount'] as num).toStringAsFixed(2)
//                         : 'N/A',
//                     DateFormat.yMMMd().format(dt),
//                   ]);
//                 }
//               }
//             }
//           }
//         }
//         break;
//     }

//     // Create PDF document in A4 landscape.
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4.landscape,
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text(
//                 'Orders Report',
//                 style: pw.TextStyle(
//                   fontSize: 22,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 8),
//               if (_selectedReportType != ReportType.all)
//                 pw.Text(
//                   'From: ${DateFormat.yMMMd().format(_fromDate!)}   To: ${DateFormat.yMMMd().format(_toDate!)}',
//                   style: pw.TextStyle(fontSize: 16),
//                 ),
//               pw.SizedBox(height: 12),
//               pw.TableHelper.fromTextArray(
//                 headers: tableHeaders,
//                 data: tableData,
//                 headerStyle: pw.TextStyle(
//                     fontSize: 10,
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColors.white),
//                 headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
//                 cellStyle: const pw.TextStyle(fontSize: 9),
//                 cellHeight: 30,
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

//   Widget _buildOrdersPieChart(List<Map<String, dynamic>> orders) {
//     final now = DateTime.now();
//     Map<String, int> monthCounts = {};
//     for (int i = 0; i < 6; i++) {
//       final monthDate = DateTime(now.year, now.month - i, 1);
//       final monthLabel = DateFormat.MMM().format(monthDate);
//       monthCounts[monthLabel] = 0;
//     }

//     for (var order in orders) {
//       final Timestamp? ts = order['createdAt'] as Timestamp?;
//       if (ts != null) {
//         final orderDate = ts.toDate();
//         if (orderDate.isAfter(DateTime(now.year, now.month - 6, 1))) {
//           final monthLabel = DateFormat.MMM().format(orderDate);
//           if (monthCounts.containsKey(monthLabel)) {
//             monthCounts[monthLabel] = monthCounts[monthLabel]! + 1;
//           }
//         }
//       }
//     }

//     List<PieChartSectionData> showingSections() {
//       List<PieChartSectionData> sections = [];
//       int index = 0;
//       monthCounts.forEach((month, count) {
//         final isTouched = index == touchedIndex;
//         final fontSize = isTouched ? 20.0 : 16.0;
//         final radius = isTouched ? 110.0 : 100.0;
//         sections.add(
//           PieChartSectionData(
//             color: Colors.primaries[index % Colors.primaries.length],
//             value: count.toDouble(),
//             title: "$month\n$count",
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         );
//         index++;
//       });
//       return sections;
//     }

//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: PieChart(
//         PieChartData(
//           pieTouchData: PieTouchData(
//             touchCallback: (FlTouchEvent event, pieTouchResponse) {
//               setState(() {
//                 if (!event.isInterestedForInteractions ||
//                     pieTouchResponse == null ||
//                     pieTouchResponse.touchedSection == null) {
//                   touchedIndex = -1;
//                   return;
//                 }
//                 touchedIndex =
//                     pieTouchResponse.touchedSection!.touchedSectionIndex;
//               });
//             },
//           ),
//           borderData: FlBorderData(show: false),
//           sectionsSpace: 2,
//           centerSpaceRadius: 40,
//           sections: showingSections(),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = ref.watch(customAuthStateProvider);
//     final bool isAdmin = currentUser != null && currentUser.role == 'admin';
//     final String userId = currentUser?.id ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Advanced Orders Report',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 30,
//               ),
//               DropdownButtonFormField<ReportType>(
//                 value: _selectedReportType,
//                 decoration: const InputDecoration(
//                   labelText: 'Select Report Type',
//                   border: OutlineInputBorder(),
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 ),
//                 items: const [
//                   DropdownMenuItem(
//                       value: ReportType.all, child: Text("All Orders Report")),
//                   DropdownMenuItem(
//                       value: ReportType.delivery,
//                       child: Text("Delivery Date Wise Report")),
//                   DropdownMenuItem(
//                       value: ReportType.confirmed,
//                       child: Text("Order Confirmation Date Wise Report")),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedReportType = value!;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//               // If report type is not 'all', show date pickers.
//               if (_selectedReportType != ReportType.all)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => _selectFromDate(context),
//                         child: Text(
//                           _fromDate == null
//                               ? 'Select From Date'
//                               : 'From: ${DateFormat.yMMMd().format(_fromDate!)}',
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => _selectToDate(context),
//                         child: Text(
//                           _toDate == null
//                               ? 'Select To Date'
//                               : 'To: ${DateFormat.yMMMd().format(_toDate!)}',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: _generateReport,
//                 icon: const Icon(
//                   Icons.download,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Generate Report',
//                   style: TextStyle(
//                       color: Colors.white, fontSize: 16, letterSpacing: 0.7),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               // If admin, display the pie chart.
//               if (isAdmin)
//                 FutureBuilder<List<Map<String, dynamic>>>(
//                   future: ref
//                       .read(orderProvider.notifier)
//                       .fetchOrders(userId, isAdmin: isAdmin),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     }
//                     final orders = snapshot.data ?? [];
//                     return Column(
//                       // crossAxisAlignment: CrossAxisAlignment.center,
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 60),
//                         const Text(
//                           'Orders by Month (Last 6 Months)',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 60),
//                         SizedBox(
//                           height: 200,
//                           child: _buildOrdersPieChart(orders),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../auth/providers/auth_providers.dart';
import '../../sales/providers/order_provider.dart';

enum ReportType { all, delivery, confirmed }

enum ReportFormat { pdf, xlsx }

class OrdersReportScreen extends ConsumerStatefulWidget {
  const OrdersReportScreen({super.key});

  @override
  ConsumerState<OrdersReportScreen> createState() => _OrdersReportScreenState();
}

class _OrdersReportScreenState extends ConsumerState<OrdersReportScreen> {
  ReportType _selectedReportType = ReportType.all;
  ReportFormat _selectedFormat = ReportFormat.pdf;
  DateTime? _fromDate;
  DateTime? _toDate;
  int touchedIndex = -1;

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  /// Generates the PDF report.
  Future<void> _generatePdfReport() async {
    if (_selectedReportType != ReportType.all) {
      if (_fromDate == null || _toDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select both From and To dates")),
        );
        return;
      }
      if (_fromDate!.isAfter(_toDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("From date cannot be after To date")),
        );
        return;
      }
    }
    final currentUser = ref.read(customAuthStateProvider);
    final bool isAdmin = currentUser != null && currentUser.role == 'admin';
    final String userId = currentUser?.id ?? '';

    final orders = await ref
        .read(orderProvider.notifier)
        .fetchOrders(userId, isAdmin: isAdmin);

    List<List<String>> tableData = [];
    List<String> tableHeaders = [
      'Company Name',
      'Product Name',
      'Marka',
      'Film',
      'Fabric Color',
      'Weight',
      'Quantity',
      'Unit Price',
      'Total Price',
      'Date',
    ];

    switch (_selectedReportType) {
      case ReportType.all:
        for (var order in orders) {
          final quotation = order['quotation'] as Map<String, dynamic>? ?? {};
          final companyName = quotation['companyName']?.toString() ?? 'N/A';
          if (quotation['items'] is List) {
            for (var item in quotation['items']) {
              String dateStr = 'N/A';
              if (item['deliveryDate'] != null) {
                try {
                  final dt = DateTime.parse(item['deliveryDate'].toString());
                  dateStr = DateFormat.yMMMd().format(dt);
                } catch (e) {
                  dateStr = 'N/A';
                }
              }
              tableData.add([
                companyName,
                item['productName']?.toString() ?? 'N/A',
                item['marka']?.toString() ?? 'N/A',
                item['film']?.toString() ?? 'N/A',
                item['fabricColor']?.toString() ?? 'N/A',
                item['weight'] != null
                    ? (item['weight'] as num).toStringAsFixed(2)
                    : 'N/A',
                item['quantity']?.toString() ?? 'N/A',
                item['unitPrice'] != null
                    ? (item['unitPrice'] as num).toStringAsFixed(2)
                    : 'N/A',
                item['amount'] != null
                    ? (item['amount'] as num).toStringAsFixed(2)
                    : 'N/A',
                dateStr,
              ]);
            }
          }
        }
        break;
      case ReportType.delivery:
        for (var order in orders) {
          final quotation = order['quotation'] as Map<String, dynamic>? ?? {};
          final companyName = quotation['companyName']?.toString() ?? 'N/A';
          if (quotation['items'] is List) {
            for (var item in quotation['items']) {
              if (item['deliveryDate'] != null) {
                try {
                  final dt = DateTime.parse(item['deliveryDate'].toString());
                  if (!dt.isBefore(_fromDate!) && !dt.isAfter(_toDate!)) {
                    tableData.add([
                      companyName,
                      item['productName']?.toString() ?? 'N/A',
                      item['marka']?.toString() ?? 'N/A',
                      item['film']?.toString() ?? 'N/A',
                      item['fabricColor']?.toString() ?? 'N/A',
                      item['weight'] != null
                          ? (item['weight'] as num).toStringAsFixed(2)
                          : 'N/A',
                      item['quantity']?.toString() ?? 'N/A',
                      item['unitPrice'] != null
                          ? (item['unitPrice'] as num).toStringAsFixed(2)
                          : 'N/A',
                      item['amount'] != null
                          ? (item['amount'] as num).toStringAsFixed(2)
                          : 'N/A',
                      DateFormat.yMMMd().format(dt),
                    ]);
                  }
                } catch (e) {
                  // Skip if date parsing fails.
                }
              }
            }
          }
        }
        break;
      case ReportType.confirmed:
        for (var order in orders) {
          final Timestamp? ts = order['createdAt'] as Timestamp?;
          if (ts != null) {
            final dt = ts.toDate();
            if (!dt.isBefore(_fromDate!) && !dt.isAfter(_toDate!)) {
              final quotation =
                  order['quotation'] as Map<String, dynamic>? ?? {};
              final companyName = quotation['companyName']?.toString() ?? 'N/A';
              if (quotation['items'] is List) {
                for (var item in quotation['items']) {
                  tableData.add([
                    companyName,
                    item['productName']?.toString() ?? 'N/A',
                    item['marka']?.toString() ?? 'N/A',
                    item['film']?.toString() ?? 'N/A',
                    item['fabricColor']?.toString() ?? 'N/A',
                    item['weight'] != null
                        ? (item['weight'] as num).toStringAsFixed(2)
                        : 'N/A',
                    item['quantity']?.toString() ?? 'N/A',
                    item['unitPrice'] != null
                        ? (item['unitPrice'] as num).toStringAsFixed(2)
                        : 'N/A',
                    item['amount'] != null
                        ? (item['amount'] as num).toStringAsFixed(2)
                        : 'N/A',
                    DateFormat.yMMMd().format(dt),
                  ]);
                }
              }
            }
          }
        }
        break;
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Orders Report',
                style:
                    pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              if (_selectedReportType != ReportType.all)
                pw.Text(
                  'From: ${DateFormat.yMMMd().format(_fromDate!)}   To: ${DateFormat.yMMMd().format(_toDate!)}',
                  style: pw.TextStyle(fontSize: 16),
                ),
              pw.SizedBox(height: 12),
              pw.TableHelper.fromTextArray(
                headers: tableHeaders,
                data: tableData,
                headerStyle: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
                cellStyle: const pw.TextStyle(fontSize: 9),
                cellHeight: 30,
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

  /// Generates the XLSX report using updateCell.
  Future<void> _generateXlsxReport() async {
    if (_selectedReportType != ReportType.all) {
      if (_fromDate == null || _toDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select both From and To dates")),
        );
        return;
      }
      if (_fromDate!.isAfter(_toDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("From date cannot be after To date")),
        );
        return;
      }
    }

    final currentUser = ref.read(customAuthStateProvider);
    final bool isAdmin = currentUser != null && currentUser.role == 'admin';
    final String userId = currentUser?.id ?? '';

    final orders = await ref
        .read(orderProvider.notifier)
        .fetchOrders(userId, isAdmin: isAdmin);

    // Define headers and build table data as List<List<dynamic>>.
    List<dynamic> tableHeaders = [
      'Company Name',
      'Product Name',
      'Marka',
      'Film',
      'Fabric Color',
      'Weight',
      'Quantity',
      'Unit Price',
      'Total Price',
      'Date',
    ];

    List<List<dynamic>> tableData = [];

    switch (_selectedReportType) {
      case ReportType.all:
        for (var order in orders) {
          final quotation = order['quotation'] as Map<String, dynamic>? ?? {};
          final companyName = quotation['companyName']?.toString() ?? 'N/A';
          if (quotation['items'] is List) {
            for (var item in quotation['items']) {
              String dateStr = 'N/A';
              if (item['deliveryDate'] != null) {
                try {
                  final dt = DateTime.parse(item['deliveryDate'].toString());
                  dateStr = DateFormat.yMMMd().format(dt);
                } catch (e) {
                  dateStr = 'N/A';
                }
              }
              tableData.add([
                companyName,
                item['productName']?.toString() ?? 'N/A',
                item['marka']?.toString() ?? 'N/A',
                item['film']?.toString() ?? 'N/A',
                item['fabricColor']?.toString() ?? 'N/A',
                item['weight'] != null
                    ? (item['weight'] as num).toStringAsFixed(2)
                    : 'N/A',
                item['quantity']?.toString() ?? 'N/A',
                item['unitPrice'] != null
                    ? (item['unitPrice'] as num).toStringAsFixed(2)
                    : 'N/A',
                item['amount'] != null
                    ? (item['amount'] as num).toStringAsFixed(2)
                    : 'N/A',
                dateStr,
              ]);
            }
          }
        }
        break;
      case ReportType.delivery:
        for (var order in orders) {
          final quotation = order['quotation'] as Map<String, dynamic>? ?? {};
          final companyName = quotation['companyName']?.toString() ?? 'N/A';
          if (quotation['items'] is List) {
            for (var item in quotation['items']) {
              if (item['deliveryDate'] != null) {
                try {
                  final dt = DateTime.parse(item['deliveryDate'].toString());
                  if (!dt.isBefore(_fromDate!) && !dt.isAfter(_toDate!)) {
                    tableData.add([
                      companyName,
                      item['productName']?.toString() ?? 'N/A',
                      item['marka']?.toString() ?? 'N/A',
                      item['film']?.toString() ?? 'N/A',
                      item['fabricColor']?.toString() ?? 'N/A',
                      item['weight'] != null
                          ? (item['weight'] as num).toStringAsFixed(2)
                          : 'N/A',
                      item['quantity']?.toString() ?? 'N/A',
                      item['unitPrice'] != null
                          ? (item['unitPrice'] as num).toStringAsFixed(2)
                          : 'N/A',
                      item['amount'] != null
                          ? (item['amount'] as num).toStringAsFixed(2)
                          : 'N/A',
                      DateFormat.yMMMd().format(dt),
                    ]);
                  }
                } catch (e) {
                  // Skip if date parsing fails.
                }
              }
            }
          }
        }
        break;
      case ReportType.confirmed:
        for (var order in orders) {
          final Timestamp? ts = order['createdAt'] as Timestamp?;
          if (ts != null) {
            final dt = ts.toDate();
            if (!dt.isBefore(_fromDate!) && !dt.isAfter(_toDate!)) {
              final quotation =
                  order['quotation'] as Map<String, dynamic>? ?? {};
              final companyName = quotation['companyName']?.toString() ?? 'N/A';
              if (quotation['items'] is List) {
                for (var item in quotation['items']) {
                  tableData.add([
                    companyName,
                    item['productName']?.toString() ?? 'N/A',
                    item['marka']?.toString() ?? 'N/A',
                    item['film']?.toString() ?? 'N/A',
                    item['fabricColor']?.toString() ?? 'N/A',
                    item['weight'] != null
                        ? (item['weight'] as num).toStringAsFixed(2)
                        : 'N/A',
                    item['quantity']?.toString() ?? 'N/A',
                    item['unitPrice'] != null
                        ? (item['unitPrice'] as num).toStringAsFixed(2)
                        : 'N/A',
                    item['amount'] != null
                        ? (item['amount'] as num).toStringAsFixed(2)
                        : 'N/A',
                    DateFormat.yMMMd().format(dt),
                  ]);
                }
              }
            }
          }
        }
        break;
    }

    var excel = Excel.createExcel();
    String sheetName = excel.sheets.keys.first;
    Sheet sheetObject = excel[sheetName];

    // Write header row using updateCell.
    for (int col = 0; col < tableHeaders.length; col++) {
      sheetObject.updateCell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
          tableHeaders[col]);
    }
    // Write data rows using updateCell.
    for (int row = 0; row < tableData.length; row++) {
      for (int col = 0; col < tableData[row].length; col++) {
        sheetObject.updateCell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1),
            tableData[row][col]);
      }
    }

    var fileBytes = excel.encode();

    if (fileBytes != null) {
      final Uint8List uint8List = Uint8List.fromList(fileBytes);
      final res = await FileSaver.instance.saveFile(
        name: "OrdersReport",
        bytes: uint8List,
        ext: "xlsx",
        mimeType: MimeType.microsoftExcel,
        // filePath: path,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("XLSX report saved: $res")),
      );
    }
  }

  Future<void> _generateReport() async {
    if (_selectedFormat == ReportFormat.pdf) {
      await _generatePdfReport();
    } else {
      await _generateXlsxReport();
    }
  }

  Widget _buildOrdersPieChart(List<Map<String, dynamic>> orders) {
    final now = DateTime.now();
    Map<String, int> monthCounts = {};
    for (int i = 0; i < 6; i++) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthLabel = DateFormat.MMM().format(monthDate);
      monthCounts[monthLabel] = 0;
    }

    for (var order in orders) {
      final Timestamp? ts = order['createdAt'] as Timestamp?;
      if (ts != null) {
        final orderDate = ts.toDate();
        if (orderDate.isAfter(DateTime(now.year, now.month - 6, 1))) {
          final monthLabel = DateFormat.MMM().format(orderDate);
          if (monthCounts.containsKey(monthLabel)) {
            monthCounts[monthLabel] = monthCounts[monthLabel]! + 1;
          }
        }
      }
    }

    List<PieChartSectionData> showingSections() {
      List<PieChartSectionData> sections = [];
      int index = 0;
      monthCounts.forEach((month, count) {
        final isTouched = index == touchedIndex;
        final fontSize = isTouched ? 20.0 : 16.0;
        final radius = isTouched ? 110.0 : 100.0;
        sections.add(
          PieChartSectionData(
            color: Colors.primaries[index % Colors.primaries.length],
            value: count.toDouble(),
            title: "$month\n$count",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
        index++;
      });
      return sections;
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: showingSections(),
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
      appBar: AppBar(
        title: const Text(
          'Advanced Orders Report',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButtonFormField<ReportType>(
                value: _selectedReportType,
                decoration: const InputDecoration(
                  labelText: 'Select Report Type',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: const [
                  DropdownMenuItem(
                      value: ReportType.all, child: Text("All Orders Report")),
                  DropdownMenuItem(
                      value: ReportType.delivery,
                      child: Text("Delivery Date Wise Report")),
                  DropdownMenuItem(
                      value: ReportType.confirmed,
                      child: Text("Order Confirmation Date Wise Report")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedReportType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<ReportFormat>(
                    value: ReportFormat.pdf,
                    groupValue: _selectedFormat,
                    onChanged: (value) {
                      setState(() {
                        _selectedFormat = value!;
                      });
                    },
                  ),
                  const Text("PDF"),
                  const SizedBox(width: 16),
                  Radio<ReportFormat>(
                    value: ReportFormat.xlsx,
                    groupValue: _selectedFormat,
                    onChanged: (value) {
                      setState(() {
                        _selectedFormat = value!;
                      });
                    },
                  ),
                  const Text("XLSX"),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedReportType != ReportType.all)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectFromDate(context),
                        child: Text(
                          _fromDate == null
                              ? 'Select From Date'
                              : 'From: ${DateFormat.yMMMd().format(_fromDate!)}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectToDate(context),
                        child: Text(
                          _toDate == null
                              ? 'Select To Date'
                              : 'To: ${DateFormat.yMMMd().format(_toDate!)}',
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _generateReport,
                icon: const Icon(
                  Icons.download,
                  color: Colors.white,
                ),
                label: const Text(
                  'Generate Report',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, letterSpacing: 0.7),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
                ),
              ),
              const SizedBox(height: 24),
              if (isAdmin)
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: ref
                      .read(orderProvider.notifier)
                      .fetchOrders(userId, isAdmin: isAdmin),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final orders = snapshot.data ?? [];
                    return Column(
                      children: [
                        const SizedBox(height: 60),
                        const Text(
                          'Orders by Month (Last 6 Months)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 60),
                        SizedBox(
                          height: 200,
                          child: _buildOrdersPieChart(orders),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
