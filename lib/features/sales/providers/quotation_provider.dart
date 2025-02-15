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

//   /// Create a new quotation in Firestore.
//   Future<void> createQuotation(
//       Quotation quotation, BuildContext context) async {
//     try {
//       isLoading = true;
//       errorMessage = '';
//       notifyListeners();

//       final docRef = _firestore.collection('quotations').doc();
//       // Optionally, assign the generated document id to quotation if needed.
//       await docRef.set(quotation.toMap());

//       Navigator.of(context).pop();
//     } catch (e) {
//       errorMessage = e.toString();
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<List<Quotation>> fetchQuotationsForUser(String createdByUid) async {
//     // Defer setting isLoading to true until after the build frame.
//     Future.microtask(() {
//       isLoading = true;
//       notifyListeners();
//     });

//     try {
//       final snapshot = await _firestore
//           .collection('quotations')
//           .where('createdByUid', isEqualTo: createdByUid)
//           .get();
//       return snapshot.docs.map((doc) => Quotation.fromDoc(doc)).toList();
//     } catch (e) {
//       Future.microtask(() {
//         errorMessage = e.toString();
//         notifyListeners();
//       });
//       return [];
//     } finally {
//       Future.microtask(() {
//         isLoading = false;
//         notifyListeners();
//       });
//     }
//   }

//   /// Fetch all quotations (for admin).
//   Future<List<Quotation>> fetchAllQuotations() async {
//     try {
//       isLoading = true;
//       notifyListeners();

//       final snapshot = await _firestore.collection('quotations').get();
//       return snapshot.docs.map((doc) => Quotation.fromDoc(doc)).toList();
//     } catch (e) {
//       errorMessage = e.toString();
//       notifyListeners();
//       return [];
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Update an existing quotation in Firestore.
//   Future<void> updateQuotation(Quotation updatedQuotation) async {
//     if (updatedQuotation.id == null) {
//       throw Exception('Quotation has no ID to update');
//     }
//     try {
//       isLoading = true;
//       errorMessage = '';
//       notifyListeners();

//       await _firestore
//           .collection('quotations')
//           .doc(updatedQuotation.id)
//           .update(updatedQuotation.toMap());
//     } catch (e) {
//       errorMessage = e.toString();
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Approve a quotation (admin functionality).
//   Future<void> approveQuotation(Quotation quotation) async {
//     if (quotation.id == null) {
//       throw Exception('Quotation has no ID to approve');
//     }
//     try {
//       isLoading = true;
//       errorMessage = '';
//       notifyListeners();

//       await _firestore.collection('quotations').doc(quotation.id).update({
//         'status': 'approved',
//       });
//     } catch (e) {
//       errorMessage = e.toString();
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Confirm an order for a quotation (for sales).
//   Future<void> confirmOrder(Quotation quotation) async {
//     if (quotation.id == null) {
//       throw Exception('Quotation has no ID to confirm');
//     }
//     try {
//       isLoading = true;
//       errorMessage = '';
//       notifyListeners();

//       await _firestore.collection('quotations').doc(quotation.id).update({
//         'status': 'confirmed_order',
//       });
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

  /// Create a new quotation in Firestore.
  Future<void> createQuotation(
      Quotation quotation, BuildContext context) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final docRef = _firestore.collection('quotations').doc();
      // Optionally, assign the generated document id to quotation if needed.
      await docRef.set(quotation.toMap());

      Navigator.of(context).pop();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch quotations created by the given user.
  Future<List<Quotation>> fetchQuotationsForUser(String createdByUid) async {
    Future.microtask(() {
      isLoading = true;
      notifyListeners();
    });

    try {
      final snapshot = await _firestore
          .collection('quotations')
          .where('createdByUid', isEqualTo: createdByUid)
          .get();
      return snapshot.docs.map((doc) => Quotation.fromDoc(doc)).toList();
    } catch (e) {
      Future.microtask(() {
        errorMessage = e.toString();
        notifyListeners();
      });
      return [];
    } finally {
      Future.microtask(() {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  /// Fetch all quotations (for admin).
  Future<List<Quotation>> fetchAllQuotations() async {
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

  /// Update an existing quotation in Firestore.
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

  /// Approve a quotation (admin functionality).
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

  /// Confirm an order for a quotation (for sales).
  Future<void> confirmOrder(Quotation quotation) async {
    if (quotation.id == null) {
      throw Exception('Quotation has no ID to confirm');
    }
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      await _firestore.collection('quotations').doc(quotation.id).update({
        'status': 'confirmed_order',
      });
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a quotation created by a sales user if its status is not approved.
  Future<void> deleteQuotation(Quotation quotation) async {
    if (quotation.id == null) {
      throw Exception('Quotation has no ID to delete');
    }
    // Check if quotation status is approved.
    if (quotation.status == 'approved') {
      throw Exception('Approved quotations cannot be deleted by sales users.');
    }
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      await _firestore.collection('quotations').doc(quotation.id).delete();
    } catch (e) {
      errorMessage = e.toString();
      throw Exception(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
