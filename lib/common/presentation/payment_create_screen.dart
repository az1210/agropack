// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../features/auth/providers/auth_providers.dart';
// import '../../models/payment_model.dart';

// class PaymentAddEditScreen extends ConsumerStatefulWidget {
//   // If payment is provided, we are editing; otherwise, we're adding.
//   final PaymentModel? payment;
//   const PaymentAddEditScreen({super.key, this.payment});

//   @override
//   ConsumerState<PaymentAddEditScreen> createState() =>
//       _PaymentAddEditScreenState();
// }

// class _PaymentAddEditScreenState extends ConsumerState<PaymentAddEditScreen> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _paymentIdController;
//   late TextEditingController _companyNameController;
//   late TextEditingController _paymentAmountController;
//   late TextEditingController _bankNameController;

//   // Payment mode dropdown.
//   String? _selectedPaymentMode;

//   bool _isLoading = false;
//   String _errorMessage = '';

//   // Payment modes
//   final List<DropdownMenuItem<String>> _paymentModeItems = const [
//     DropdownMenuItem(value: 'Cash', child: Text('Cash')),
//     DropdownMenuItem(value: 'Online', child: Text('Online')),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // If editing, prefill controllers; else, create empty controllers.
//     _paymentIdController = TextEditingController(
//         text: widget.payment != null ? widget.payment!.paymentId : '');
//     _companyNameController = TextEditingController(
//         text: widget.payment != null ? widget.payment!.companyName : '');
//     _paymentAmountController = TextEditingController(
//         text: widget.payment != null
//             ? widget.payment!.paymentAmount.toString()
//             : '');
//     _bankNameController = TextEditingController(
//         text: widget.payment != null ? widget.payment!.bankName : '');
//     _selectedPaymentMode = widget.payment?.paymentMode;
//   }

//   @override
//   void dispose() {
//     _paymentIdController.dispose();
//     _companyNameController.dispose();
//     _paymentAmountController.dispose();
//     _bankNameController.dispose();
//     super.dispose();
//   }

//   Future<void> _savePayment() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedPaymentMode == null) {
//       setState(() {
//         _errorMessage = 'Please select a payment mode';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     try {
//       final paymentId = _paymentIdController.text.trim();
//       final companyName = _companyNameController.text.trim();
//       final paymentAmount = double.parse(_paymentAmountController.text.trim());
//       final bankName = _bankNameController.text.trim();
//       final paymentMode = _selectedPaymentMode!;
//       final currentUser = ref.read(customAuthStateProvider);

//       final createdBy = currentUser?.id ?? '';
//       final paymentData = PaymentModel(
//         paymentId: paymentId,
//         companyName: companyName,
//         paymentAmount: paymentAmount,
//         bankName: bankName,
//         paymentMode: paymentMode,
//         createdBy: createdBy,
//       );

//       final paymentsCollection =
//           FirebaseFirestore.instance.collection('payments');

//       if (widget.payment != null) {
//         // Edit mode: update the existing document.
//         await paymentsCollection.doc(paymentId).update(paymentData.toMap());
//       } else {
//         // Add mode: Create a new document.
//         await paymentsCollection.doc(paymentId).set(paymentData.toMap());
//       }

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(widget.payment != null
//               ? 'Payment updated successfully!'
//               : 'Payment added successfully!'),
//         ),
//       );
//       Navigator.of(context).pop();
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     bool isNumber = false,
//     bool obscureText = false,
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditMode = widget.payment != null;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEditMode ? 'Edit Payment' : 'Add Payment'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             context.pop();
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 _buildTextField(
//                   controller: _paymentIdController,
//                   label: 'Payment ID',
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter Payment ID';
//                     }
//                     return null;
//                   },
//                 ),
//                 _buildTextField(
//                   controller: _companyNameController,
//                   label: 'Company Name',
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter Company Name';
//                     }
//                     return null;
//                   },
//                 ),
//                 _buildTextField(
//                   controller: _paymentAmountController,
//                   label: 'Payment Amount',
//                   isNumber: true,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter Payment Amount';
//                     }
//                     if (double.tryParse(value.trim()) == null) {
//                       return 'Please enter a valid number';
//                     }
//                     return null;
//                   },
//                 ),
//                 _buildTextField(
//                   controller: _bankNameController,
//                   label: 'Bank Name',
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter Bank Name';
//                     }
//                     return null;
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: DropdownButtonFormField<String>(
//                     value: _selectedPaymentMode,
//                     items: _paymentModeItems,
//                     decoration: const InputDecoration(
//                       labelText: 'Payment Mode',
//                       border: OutlineInputBorder(),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedPaymentMode = value;
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please select a Payment Mode';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 _isLoading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: const Size(double.infinity, 50),
//                           backgroundColor: Colors.blue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: _savePayment,
//                         child: Text(
//                           isEditMode ? 'Update Payment' : 'Add Payment',
//                           style: const TextStyle(
//                               fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                 if (_errorMessage.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: Text(
//                       _errorMessage,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../models/payment_model.dart';

class PaymentAddEditScreen extends ConsumerStatefulWidget {
  // If payment is provided, we are editing; otherwise, we're adding.
  final PaymentModel? payment;
  const PaymentAddEditScreen({super.key, this.payment});

  @override
  ConsumerState<PaymentAddEditScreen> createState() =>
      _PaymentAddEditScreenState();
}

class _PaymentAddEditScreenState extends ConsumerState<PaymentAddEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _paymentIdController;
  late TextEditingController _companyNameController;
  late TextEditingController _paymentAmountController;
  late TextEditingController _bankNameController;

  // Payment mode dropdown.
  String? _selectedPaymentMode;

  bool _isLoading = false;
  String _errorMessage = '';

  // Payment modes
  final List<DropdownMenuItem<String>> _paymentModeItems = const [
    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
    DropdownMenuItem(value: 'Online', child: Text('Online')),
  ];

  @override
  void initState() {
    super.initState();
    // If editing, prefill controllers; else, create empty controllers.
    _paymentIdController = TextEditingController(
        text: widget.payment != null ? widget.payment!.paymentId : '');
    _companyNameController = TextEditingController(
        text: widget.payment != null ? widget.payment!.companyName : '');
    _paymentAmountController = TextEditingController(
        text: widget.payment != null
            ? widget.payment!.paymentAmount.toString()
            : '');
    _bankNameController = TextEditingController(
        text: widget.payment != null ? widget.payment!.bankName : '');
    _selectedPaymentMode = widget.payment?.paymentMode;
  }

  @override
  void dispose() {
    _paymentIdController.dispose();
    _companyNameController.dispose();
    _paymentAmountController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  Future<void> _savePayment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPaymentMode == null) {
      setState(() {
        _errorMessage = 'Please select a payment mode';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final currentUser = ref.read(customAuthStateProvider);
      final createdBy = currentUser?.id ?? '';
      final paymentId = _paymentIdController.text.trim();
      final companyName = _companyNameController.text.trim();
      final paymentAmount = double.parse(_paymentAmountController.text.trim());
      final bankName = _bankNameController.text.trim(); // now optional
      final paymentMode = _selectedPaymentMode!;

      final paymentData = PaymentModel(
        paymentId: paymentId,
        companyName: companyName,
        paymentAmount: paymentAmount,
        bankName: bankName,
        paymentMode: paymentMode,
        createdBy: createdBy,
      );

      final paymentsCollection =
          FirebaseFirestore.instance.collection('payments');

      if (widget.payment != null) {
        // Edit mode: update the existing document.
        await paymentsCollection.doc(paymentId).update(paymentData.toMap());
      } else {
        // Add mode: Create a new document.
        await paymentsCollection.doc(paymentId).set(paymentData.toMap());
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.payment != null
              ? 'Payment updated successfully!'
              : 'Payment added successfully!'),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isNumber = false,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.payment != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Payment' : 'Add Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _paymentIdController,
                  label: 'Payment ID',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Payment ID';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _companyNameController,
                  label: 'Company Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Company Name';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _paymentAmountController,
                  label: 'Payment Amount',
                  isNumber: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Payment Amount';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _bankNameController,
                  label: 'Bank Name (optional)',
                  // No validator here since bank name is optional.
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DropdownButtonFormField<String>(
                    value: _selectedPaymentMode,
                    items: _paymentModeItems,
                    decoration: const InputDecoration(
                      labelText: 'Payment Mode',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMode = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a Payment Mode';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _savePayment,
                        child: Text(
                          isEditMode ? 'Update Payment' : 'Add Payment',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
