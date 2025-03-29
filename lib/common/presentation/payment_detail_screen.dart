// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../../models/payment_model.dart';

// class PaymentDetailsScreen extends StatelessWidget {
//   final PaymentModel payment;
//   const PaymentDetailsScreen({super.key, required this.payment});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment Details"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             context.pop();
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Card(
//           elevation: 4,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Payment ID: ${payment.paymentId}",
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 Text("Company Name: ${payment.companyName}",
//                     style: const TextStyle(fontSize: 16)),
//                 const SizedBox(height: 8),
//                 Text(
//                     "Payment Amount: \$${payment.paymentAmount.toStringAsFixed(2)}",
//                     style: const TextStyle(fontSize: 16)),
//                 const SizedBox(height: 8),
//                 Text("Bank Name: ${payment.bankName}",
//                     style: const TextStyle(fontSize: 16)),
//                 const SizedBox(height: 8),
//                 Text("Payment Mode: ${payment.paymentMode}",
//                     style: const TextStyle(fontSize: 16)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/payment_model.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final PaymentModel payment;
  const PaymentDetailsScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey.shade200,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("Payment ID", payment.paymentId),
                const Divider(),
                _buildDetailRow("Company Name", payment.companyName),
                const Divider(),
                _buildDetailRow("Payment Amount",
                    "BDT ${payment.paymentAmount.toStringAsFixed(2)}"),
                const Divider(),
                _buildDetailRow("Bank Name",
                    payment.bankName.isEmpty ? "N/A" : payment.bankName),
                const Divider(),
                _buildDetailRow("Payment Mode", payment.paymentMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
