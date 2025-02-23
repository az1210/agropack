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

      // Generate a new document and set its data using the model's toMap.
      final docRef = _firestore.collection('quotations').doc();
      await docRef.set(quotation.toMap());

      // Optionally, you could update the quotation instance with docRef.id if needed.
      Navigator.of(context).pop();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch quotations created by a specific user (for sales users).
  Future<List<Quotation>> fetchQuotationsForUser(String createdByUid) async {
    // Defer state update until after the build frame.
    Future.microtask(() {
      isLoading = true;
      notifyListeners();
    });
    try {
      final snapshot = await _firestore
          .collection('quotations')
          .where('createdByUid', isEqualTo: createdByUid)
          .get();
      // return snapshot.docs.map((doc) => Quotation.fromDoc(doc)).toList();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Quotation.fromMap(data);
      }).toList();
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

  /// Fetch all quotations (for admin users).
  Future<List<Quotation>> fetchAllQuotations() async {
    try {
      isLoading = true;
      notifyListeners();

      final snapshot = await _firestore.collection('quotations').get();
      // return snapshot.docs.map((doc) => Quotation.fromDoc(doc)).toList();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Quotation.fromMap(data);
      }).toList();
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

  /// Confirm an order for a quotation (for sales users).
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
    // Check if the quotation's status is approved. If yes, sales users should not delete it.
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
