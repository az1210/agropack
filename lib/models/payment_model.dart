class PaymentModel {
  final String paymentId;
  final String companyName;
  final double paymentAmount;
  final String bankName;
  final String paymentMode;
  final String createdBy;

  PaymentModel({
    required this.paymentId,
    required this.companyName,
    required this.paymentAmount,
    required this.bankName,
    required this.paymentMode,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'companyName': companyName,
      'paymentAmount': paymentAmount,
      'bankName': bankName,
      'paymentMode': paymentMode,
      'createdBy': createdBy,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      paymentId: map['paymentId'] ?? '',
      companyName: map['companyName'] ?? '',
      paymentAmount: (map['paymentAmount'] as num).toDouble(),
      bankName: map['bankName'] ?? '',
      paymentMode: map['paymentMode'] ?? '',
      createdBy: map['createdBy'] ?? '',
    );
  }
}
