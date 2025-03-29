// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../models/payment_model.dart';

// class PaymentController extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<PaymentModel> payments = [];
//   DocumentSnapshot? lastDocument;
//   bool isLoading = false;
//   bool hasMore = true;
//   final int limit = 10;

//   /// Fetch payments with pagination.
//   /// If [createdBy] is provided and is not empty, filter payments to those created by that user.
//   Future<void> fetchPayments({bool refresh = false, String? createdBy}) async {
//     if (refresh) {
//       payments = [];
//       lastDocument = null;
//       hasMore = true;
//     }
//     if (!hasMore || isLoading) return;
//     isLoading = true;
//     notifyListeners();

//     Query query =
//         _firestore.collection('payments').orderBy('paymentId').limit(limit);

//     // If createdBy is provided (and not admin), filter by it.
//     if (createdBy != null && createdBy.isNotEmpty) {
//       query = query.where('createdBy', isEqualTo: createdBy);
//     }

//     if (lastDocument != null) {
//       query = query.startAfterDocument(lastDocument!);
//     }

//     QuerySnapshot snapshot = await query.get();
//     if (snapshot.docs.isNotEmpty) {
//       lastDocument = snapshot.docs.last;
//       payments.addAll(snapshot.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         return PaymentModel.fromMap(data);
//       }).toList());
//       if (snapshot.docs.length < limit) {
//         hasMore = false;
//       }
//     } else {
//       hasMore = false;
//     }

//     isLoading = false;
//     notifyListeners();
//   }
// }

// final paymentProvider = ChangeNotifierProvider<PaymentController>((ref) {
//   return PaymentController();
// });

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/payment_model.dart';

class PaymentController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<PaymentModel> payments = [];
  bool isLoading = false;
  String errorMessage = '';

  /// Fetch all payments. If [createdBy] is provided (and non-empty),
  /// only payments created by that user are fetched.
  Future<void> fetchPayments({bool refresh = false, String? createdBy}) async {
    if (refresh) {
      payments = [];
      notifyListeners();
    }
    isLoading = true;
    notifyListeners();

    try {
      Query query = _firestore.collection('payments').orderBy('paymentId');
      if (createdBy != null && createdBy.isNotEmpty) {
        query = query.where('createdBy', isEqualTo: createdBy);
      }
      final snapshot = await query.get();
      payments = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PaymentModel.fromMap(data);
      }).toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

final paymentProvider = ChangeNotifierProvider<PaymentController>((ref) {
  return PaymentController();
});
