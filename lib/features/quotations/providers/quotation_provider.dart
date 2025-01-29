// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../models/quotation_model.dart';

// final quotationProvider = ChangeNotifierProvider<QuotationController>((ref) {
//   return QuotationController();
// });

// class QuotationController extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool isLoading = false;
//   String errorMessage = '';

//   Future<void> createQuotation(
//       Quotation quotation, BuildContext context) async {
//     try {
//       isLoading = true;
//       errorMessage = '';
//       notifyListeners();

//       final docRef = _firestore.collection('quotations').doc();
//       await docRef.set(quotation.toMap());
//       Navigator.of(context).pop();
//     } catch (e) {
//       errorMessage = e.toString();
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/quotation_model.dart';

final quotationProvider = ChangeNotifierProvider<QuotationController>((ref) {
  return QuotationController();
});

class QuotationController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String errorMessage = '';

  Future<void> createQuotation(
      Quotation quotation, BuildContext context) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final docRef = _firestore.collection('quotations').doc();
      await docRef.set(quotation.toMap());

      Navigator.of(context).pop();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Quotation>> fetchQuotations() async {
    try {
      isLoading = true;
      notifyListeners();

      final snapshot = await _firestore.collection('quotations').get();
      return snapshot.docs.map((doc) => Quotation.fromDoc(doc)).toList();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateQuotation(Quotation updatedQuotation) async {
    if (updatedQuotation.id == null) {
      throw Exception('Quotation has no ID to update');
    }

    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      await _firestore
          .collection('quotations')
          .doc(updatedQuotation.id)
          .update(updatedQuotation.toMap());
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> approveQuotation(Quotation quotation) async {
    if (quotation.id == null) {
      throw Exception('Quotation has no ID to approve');
    }

    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      await _firestore.collection('quotations').doc(quotation.id).update({
        'status': 'approved',
      });
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
