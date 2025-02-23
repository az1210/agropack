import 'package:cloud_firestore/cloud_firestore.dart';

class Quotation {
  final String? id;
  final String companyName; // The company providing the quotation (required)
  final List<QuotationItem>? items; // List of items in this quotation
  final String? createdByUid;
  final String? status;
  final DateTime? createdAt;
  final double? totalAmount; // New field for total amount

  Quotation({
    this.id,
    required this.companyName,
    this.items,
    this.createdByUid,
    this.status,
    this.createdAt,
    this.totalAmount,
  });

  /// Convert the Quotation to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'items': items?.map((item) => item.toMap()).toList(),
      'createdByUid': createdByUid,
      'status': status ?? 'pending_admin_verification',
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'totalAmount': totalAmount,
    };
  }

  /// Create a Quotation from a Firestore document.
  // factory Quotation.fromDoc(DocumentSnapshot doc) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return Quotation(
  //     id: doc.id,
  //     companyName: data['companyName'] as String,
  //     items: data['items'] != null
  //         ? (data['items'] as List)
  //             .map(
  //                 (item) => QuotationItem.fromMap(item as Map<String, dynamic>))
  //             .toList()
  //         : null,
  //     createdByUid: data['createdByUid'] as String?,
  //     status: data['status'] as String?,
  //     createdAt: data['createdAt'] != null
  //         ? (data['createdAt'] as Timestamp).toDate()
  //         : null,
  //     totalAmount: data['totalAmount'] != null
  //         ? (data['totalAmount'] as num).toDouble()
  //         : null,
  //   );
  // }

  factory Quotation.fromMap(Map<String, dynamic> map) {
    return Quotation(
      id: map['id'] as String?,
      companyName: map['companyName'] as String,
      items: map['items'] != null
          ? (map['items'] as List)
              .map(
                  (item) => QuotationItem.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      createdByUid: map['createdByUid'] as String?,
      status: map['status'] as String?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is String
              ? DateTime.parse(map['createdAt'] as String)
              : (map['createdAt'] as Timestamp).toDate())
          : null,
      totalAmount: map['totalAmount'] != null
          ? (map['totalAmount'] as num).toDouble()
          : null,
    );
  }

  /// A helper method for creating an updated copy.
  Quotation copyWith({
    String? id,
    String? companyName,
    List<QuotationItem>? items,
    String? createdByUid,
    String? status,
    DateTime? createdAt,
    double? totalAmount,
  }) {
    return Quotation(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      items: items ?? this.items,
      createdByUid: createdByUid ?? this.createdByUid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}

class QuotationItem {
  final String itemId; // Unique ID for this item (required)
  final String productName; // Product name for this item (required)
  final String? manufacturer; // New field
  final String? marka;
  final String? film;
  final String? fabricColor;
  final double? weight;
  final int? quantity;
  final DateTime? deliveryDate;
  final double? unitPrice; // New field for unit price
  final double? amount; // New field for amount

  QuotationItem({
    required this.itemId,
    required this.productName,
    this.manufacturer,
    this.marka,
    this.film,
    this.fabricColor,
    this.weight,
    this.quantity,
    this.deliveryDate,
    this.unitPrice,
    this.amount,
  });

  /// Convert this item to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'productName': productName,
      'manufacturer': manufacturer,
      'marka': marka,
      'film': film,
      'fabricColor': fabricColor,
      'weight': weight,
      'quantity': quantity,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'unitPrice': unitPrice,
      'amount': amount,
    };
  }

  /// Create a QuotationItem from a Map.
  factory QuotationItem.fromMap(Map<String, dynamic> map) {
    return QuotationItem(
      itemId: map['itemId'] as String,
      productName: map['productName'] as String,
      manufacturer: map['manufacturer'] as String?,
      marka: map['marka'] as String?,
      film: map['film'] as String?,
      fabricColor: map['fabricColor'] as String?,
      weight: map['weight'] != null ? (map['weight'] as num).toDouble() : null,
      quantity: map['quantity'] as int?,
      deliveryDate: map['deliveryDate'] != null
          ? DateTime.parse(map['deliveryDate'] as String)
          : null,
      unitPrice: map['unitPrice'] != null
          ? (map['unitPrice'] as num).toDouble()
          : null,
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : null,
    );
  }

  /// A helper method for creating an updated copy of a QuotationItem.
  QuotationItem copyWith({
    String? itemId,
    String? productName,
    String? manufacturer,
    String? marka,
    String? film,
    String? fabricColor,
    double? weight,
    int? quantity,
    DateTime? deliveryDate,
    double? unitPrice,
    double? amount,
  }) {
    return QuotationItem(
      itemId: itemId ?? this.itemId,
      productName: productName ?? this.productName,
      manufacturer: manufacturer ?? this.manufacturer,
      marka: marka ?? this.marka,
      film: film ?? this.film,
      fabricColor: fabricColor ?? this.fabricColor,
      weight: weight ?? this.weight,
      quantity: quantity ?? this.quantity,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      unitPrice: unitPrice ?? this.unitPrice,
      amount: amount ?? this.amount,
    );
  }
}
