import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

      final orderDocRef = _firestore.collection('orders').doc();
      final String orderId = orderDocRef.id;
      final DateTime currentDateTime = DateTime.now();

      final Map<String, dynamic> quotationData = quotation.toMap();
      quotationData['status'] = 'confirmed_order';

      final orderData = {
        'orderId': orderId,
        'createdAt': Timestamp.fromDate(currentDateTime),
        'createdBy': quotation.createdByUid,
        'quotation': quotationData,
      };

      await orderDocRef.set(orderData);

      await _firestore.collection('quotations').doc(quotation.id).update({
        'status': 'confirmed_order',
      });

      context.pop();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrders(String userId,
      {bool isAdmin = false}) async {
    try {
      Future.microtask(() {
        isLoading = true;
        notifyListeners();
      });

      Query query = _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true);

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
