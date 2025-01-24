import 'package:cloud_firestore/cloud_firestore.dart';

class QuotationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createQuotation({
    required String companyName,
    required String productName,
    required String marka,
    required String film,
    required String fabricColor,
    required double weight,
    required int quantity,
    required DateTime deliveryDate,
    required String createdByUid,
  }) async {
    final docRef = _firestore.collection('quotations').doc();
    await docRef.set({
      'companyName': companyName,
      'productName': productName,
      'marka': marka,
      'film': film,
      'fabricColor': fabricColor,
      'weight': weight,
      'quantity': quantity,
      'deliveryDate': deliveryDate.toIso8601String(),
      'status': 'pending_admin_verification',
      'createdByUid': createdByUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
