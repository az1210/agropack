// import 'package:cloud_firestore/cloud_firestore.dart';

// class Quotation {
//   final String? id; // Firestore document ID
//   final String? companyName;
//   final String? productName;
//   final String? marka;
//   final String? film;
//   final String? fabricColor;
//   final double? weight;
//   final int? quantity;
//   final DateTime? deliveryDate;
//   final String? createdByUid;
//   final String? status;
//   final DateTime? createdAt;

//   Quotation({
//     this.id,
//     this.companyName,
//     this.productName,
//     this.marka,
//     this.film,
//     this.fabricColor,
//     this.weight,
//     this.quantity,
//     this.deliveryDate,
//     this.createdByUid,
//     this.status,
//     this.createdAt,
//   });

//   /// Convert this object to a Map for Firestore.
//   Map<String, dynamic> toMap() {
//     return {
//       'companyName': companyName,
//       'productName': productName,
//       'marka': marka,
//       'film': film,
//       'fabricColor': fabricColor,
//       'weight': weight,
//       'quantity': quantity,
//       'deliveryDate': deliveryDate?.toIso8601String(),
//       'status': status ?? 'pending_admin_verification',
//       'createdByUid': createdByUid,
//       'createdAt': createdAt != null
//           ? Timestamp.fromDate(createdAt!)
//           : FieldValue.serverTimestamp(),
//     };
//   }

//   /// Create a Quotation object from a Firestore document snapshot.
//   factory Quotation.fromDoc(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Quotation(
//       id: doc.id,
//       companyName: data['companyName'] as String?,
//       productName: data['productName'] as String?,
//       marka: data['marka'] as String?,
//       film: data['film'] as String?,
//       fabricColor: data['fabricColor'] as String?,
//       weight:
//           (data['weight'] != null) ? (data['weight'] as num).toDouble() : null,
//       quantity: data['quantity'] as int?,
//       deliveryDate: data['deliveryDate'] != null
//           ? DateTime.parse(data['deliveryDate'] as String)
//           : null,
//       status: data['status'] as String?,
//       createdByUid: data['createdByUid'] as String?,
//       createdAt: data['createdAt'] != null
//           ? (data['createdAt'] as Timestamp).toDate()
//           : null,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Quotation {
  final String? id;
  final String? companyName;
  final String? productName;
  final String? marka;
  final String? film;
  final String? fabricColor;
  final double? weight;
  final int? quantity;
  final DateTime? deliveryDate;
  final String? createdByUid;
  final String? status;
  final DateTime? createdAt;

  Quotation({
    this.id,
    this.companyName,
    this.productName,
    this.marka,
    this.film,
    this.fabricColor,
    this.weight,
    this.quantity,
    this.deliveryDate,
    this.createdByUid,
    this.status,
    this.createdAt,
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'productName': productName,
      'marka': marka,
      'film': film,
      'fabricColor': fabricColor,
      'weight': weight,
      'quantity': quantity,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'status': status ?? 'pending_admin_verification',
      'createdByUid': createdByUid,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore doc
  factory Quotation.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Quotation(
      id: doc.id,
      companyName: data['companyName'] as String?,
      productName: data['productName'] as String?,
      marka: data['marka'] as String?,
      film: data['film'] as String?,
      fabricColor: data['fabricColor'] as String?,
      weight:
          data['weight'] != null ? (data['weight'] as num).toDouble() : null,
      quantity: data['quantity'] as int?,
      deliveryDate: data['deliveryDate'] != null
          ? DateTime.parse(data['deliveryDate'] as String)
          : null,
      status: data['status'] as String?,
      createdByUid: data['createdByUid'] as String?,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // A helpful copyWith method
  Quotation copyWith({
    String? id,
    String? companyName,
    String? productName,
    String? marka,
    String? film,
    String? fabricColor,
    double? weight,
    int? quantity,
    DateTime? deliveryDate,
    String? createdByUid,
    String? status,
    DateTime? createdAt,
  }) {
    return Quotation(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      productName: productName ?? this.productName,
      marka: marka ?? this.marka,
      film: film ?? this.film,
      fabricColor: fabricColor ?? this.fabricColor,
      weight: weight ?? this.weight,
      quantity: quantity ?? this.quantity,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      createdByUid: createdByUid ?? this.createdByUid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
