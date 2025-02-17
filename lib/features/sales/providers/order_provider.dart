import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/quotation_model.dart';

final orderProvider = ChangeNotifierProvider<OrderController>((ref) {
  return OrderController();
});

class OrderController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String errorMessage = '';

  Future<void> confirmOrder(Quotation quotation, BuildContext context) async {
    if (quotation.id == null) {
      throw Exception('Quotation has no ID to confirm order from.');
    }

    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      // Create a new order document in the "orders" collection.
      final orderDocRef = _firestore.collection('orders').doc();
      final String orderId = orderDocRef.id;
      final DateTime currentDateTime = DateTime.now();

      // Prepare the quotation data.
      // Override its status to "confirmed_order" so that in the order document it won't be "pending_for_verification".
      final Map<String, dynamic> quotationData = quotation.toMap();
      quotationData['status'] = 'confirmed_order';

      // Prepare the order document data.
      final orderData = {
        'orderId': orderId,
        'createdAt': Timestamp.fromDate(currentDateTime),
        'createdBy': quotation.createdByUid, // current user's id
        'quotation': quotationData,
      };

      // Save the new order document.
      await orderDocRef.set(orderData);

      // Update the original quotation's status to "confirmed_order".
      await _firestore.collection('quotations').doc(quotation.id).update({
        'status': 'confirmed_order',
      });

      Navigator.of(context).pop();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch orders from the "orders" collection.
  /// - Orders are sorted in descending order of creation date (last confirmed orders at top).
  /// - For non-admin users, only orders confirmed by that user (matching the "createdBy" field) are returned.
  Future<List<Map<String, dynamic>>> fetchOrders(String userId,
      {bool isAdmin = false}) async {
    try {
      // Delay state modification until after the current build completes.
      Future.microtask(() {
        isLoading = true;
        notifyListeners();
      });

      Query query = _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true);

      // For non-admin users, filter by the current user's id.
      if (!isAdmin) {
        query = query.where('createdBy', isEqualTo: userId);
        debugPrint("Fetching orders for user: $userId");
      } else {
        debugPrint("Fetching all orders for admin");
      }

      final snapshot = await query.get();
      debugPrint("Orders fetched: ${snapshot.docs.length}");

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error fetching orders: $errorMessage");
      return [];
    } finally {
      Future.microtask(() {
        isLoading = false;
        notifyListeners();
      });
    }
  }
}
