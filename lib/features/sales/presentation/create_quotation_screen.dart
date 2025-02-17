// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';
// import '../../../models/quotation_model.dart';
// import '../../auth/providers/auth_providers.dart';
// import '../providers/quotation_provider.dart';

// // A helper class to hold form controllers for a single quotation item.
// class _QuotationItemData {
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController manufacturerController = TextEditingController();
//   final TextEditingController markaController = TextEditingController();
//   final TextEditingController filmController = TextEditingController();
//   final TextEditingController fabricColorController = TextEditingController();
//   final TextEditingController weightController = TextEditingController();
//   final TextEditingController quantityController = TextEditingController();
//   DateTime? deliveryDate;

//   void dispose() {
//     productNameController.dispose();
//     manufacturerController.dispose();
//     markaController.dispose();
//     filmController.dispose();
//     fabricColorController.dispose();
//     weightController.dispose();
//     quantityController.dispose();
//   }
// }

// class CreateQuotationScreen extends ConsumerStatefulWidget {
//   const CreateQuotationScreen({super.key});

//   @override
//   ConsumerState<CreateQuotationScreen> createState() =>
//       _CreateQuotationScreenState();
// }

// class _CreateQuotationScreenState extends ConsumerState<CreateQuotationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _companyNameCtrl = TextEditingController();

//   // List to hold dynamic item data.
//   final List<_QuotationItemData> _items = [_QuotationItemData()];

//   bool _isLoading = false;
//   String _errorMessage = '';

//   // Method to pick a delivery date for an individual item.
//   Future<void> _pickItemDate(
//       BuildContext context, _QuotationItemData itemData) async {
//     final now = DateTime.now();
//     final newDate = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: now,
//       lastDate: DateTime(now.year + 2),
//     );
//     if (newDate != null) {
//       setState(() {
//         itemData.deliveryDate = newDate;
//       });
//     }
//   }

//   // Method to add a new item to the list.
//   void _addNewItem() {
//     setState(() {
//       _items.add(_QuotationItemData());
//     });
//   }

//   // Dispose all controllers.
//   @override
//   void dispose() {
//     _companyNameCtrl.dispose();
//     for (final item in _items) {
//       item.dispose();
//     }
//     super.dispose();
//   }

//   Future<void> _submitQuotation() async {
//     if (!_formKey.currentState!.validate()) return;

//     // Validate that each item has a product name.
//     for (var i = 0; i < _items.length; i++) {
//       if (_items[i].productNameController.text.trim().isEmpty) {
//         setState(() {
//           _errorMessage = 'Product name is required for Item ${i + 1}.';
//         });
//         return;
//       }
//     }

//     // Get current user from custom auth state.
//     final customUser = ref.read(customAuthStateProvider);
//     if (customUser == null) {
//       setState(() {
//         _errorMessage = 'No user is signed in.';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     try {
//       // Build a list of QuotationItem objects.
//       final List<QuotationItem> items = _items.map((itemData) {
//         return QuotationItem(
//           itemId: const Uuid().v4(), // Generate a unique id for the item.
//           productName: itemData.productNameController.text.trim(),
//           manufacturer: itemData.manufacturerController.text.trim().isNotEmpty
//               ? itemData.manufacturerController.text.trim()
//               : null,
//           marka: itemData.markaController.text.trim().isNotEmpty
//               ? itemData.markaController.text.trim()
//               : null,
//           film: itemData.filmController.text.trim().isNotEmpty
//               ? itemData.filmController.text.trim()
//               : null,
//           fabricColor: itemData.fabricColorController.text.trim().isNotEmpty
//               ? itemData.fabricColorController.text.trim()
//               : null,
//           weight: double.tryParse(itemData.weightController.text.trim()),
//           quantity: int.tryParse(itemData.quantityController.text.trim()),
//           deliveryDate: itemData.deliveryDate,
//         );
//       }).toList();

//       // Create the Quotation object.
//       final newQuotation = Quotation(
//         companyName: _companyNameCtrl.text.trim(),
//         items: items,
//         createdByUid: customUser.id,
//       );

//       await ref
//           .read(quotationProvider.notifier)
//           .createQuotation(newQuotation, context);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Quotation created successfully!')),
//       );
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (Navigator.of(context).canPop()) {
//           Navigator.of(context).pop();
//         }
//       });
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

//   Widget _buildItemForm(int index, _QuotationItemData itemData) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Item ${index + 1}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             TextFormField(
//               controller: itemData.productNameController,
//               decoration: const InputDecoration(labelText: 'Product Name'),
//               validator: (value) =>
//                   value == null || value.isEmpty ? 'Required' : null,
//             ),
//             TextFormField(
//               controller: itemData.manufacturerController,
//               decoration: const InputDecoration(labelText: 'Manufacturer'),
//             ),
//             TextFormField(
//               controller: itemData.markaController,
//               decoration: const InputDecoration(labelText: 'Marka'),
//             ),
//             TextFormField(
//               controller: itemData.filmController,
//               decoration: const InputDecoration(labelText: 'Film'),
//             ),
//             TextFormField(
//               controller: itemData.fabricColorController,
//               decoration: const InputDecoration(labelText: 'Fabric Color'),
//             ),
//             TextFormField(
//               controller: itemData.weightController,
//               decoration: const InputDecoration(labelText: 'Weight (gm)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: itemData.quantityController,
//               decoration: const InputDecoration(labelText: 'Quantity'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     itemData.deliveryDate == null
//                         ? 'Delivery Date: Not Selected'
//                         : 'Delivery Date: ${DateFormat.yMd().format(itemData.deliveryDate!)}',
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => _pickItemDate(context, itemData),
//                   child: const Text('Pick Date'),
//                 ),
//               ],
//             ),
//             if (_items.length > 1)
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton.icon(
//                   onPressed: () {
//                     setState(() {
//                       _items.removeAt(index);
//                     });
//                   },
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   label: const Text(
//                     'Remove Item',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Quotation'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // Company Name field.
//                     TextFormField(
//                       controller: _companyNameCtrl,
//                       decoration:
//                           const InputDecoration(labelText: 'Company Name'),
//                       validator: (value) =>
//                           value == null || value.isEmpty ? 'Required' : null,
//                     ),
//                     const SizedBox(height: 16),
//                     // Section Title for Items.
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Items',
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleSmall
//                             ?.copyWith(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     // List of item forms.
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: _items.length,
//                       itemBuilder: (context, index) =>
//                           _buildItemForm(index, _items[index]),
//                     ),
//                     // "Add another item" button.
//                     TextButton.icon(
//                       onPressed: _addNewItem,
//                       icon: const Icon(Icons.add),
//                       label: const Text('Add another item'),
//                     ),
//                     const SizedBox(height: 24),
//                     // "Submit Quotation" block button.
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _submitQuotation,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         child: const Text(
//                           'Submit Quotation',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                     ),
//                     if (_errorMessage.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 16.0),
//                         child: Text(
//                           _errorMessage,
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../models/quotation_model.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/quotation_provider.dart';

// A helper class to hold form controllers for a single quotation item.
class _QuotationItemData {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController markaController = TextEditingController();
  final TextEditingController filmController = TextEditingController();
  final TextEditingController fabricColorController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitPriceController =
      TextEditingController(); // New field for unit price
  DateTime? deliveryDate;

  void dispose() {
    productNameController.dispose();
    manufacturerController.dispose();
    markaController.dispose();
    filmController.dispose();
    fabricColorController.dispose();
    weightController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
  }
}

class CreateQuotationScreen extends ConsumerStatefulWidget {
  const CreateQuotationScreen({super.key});

  @override
  ConsumerState<CreateQuotationScreen> createState() =>
      _CreateQuotationScreenState();
}

class _CreateQuotationScreenState extends ConsumerState<CreateQuotationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameCtrl = TextEditingController();

  // List to hold dynamic item data.
  final List<_QuotationItemData> _items = [_QuotationItemData()];

  bool _isLoading = false;
  String _errorMessage = '';

  // Method to pick a delivery date for an individual item.
  Future<void> _pickItemDate(
      BuildContext context, _QuotationItemData itemData) async {
    final now = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (newDate != null) {
      setState(() {
        itemData.deliveryDate = newDate;
      });
    }
  }

  // Method to add a new item to the list.
  void _addNewItem() {
    setState(() {
      _items.add(_QuotationItemData());
    });
  }

  // Dispose all controllers.
  @override
  void dispose() {
    _companyNameCtrl.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  Future<void> _submitQuotation() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate that each item has a product name.
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].productNameController.text.trim().isEmpty) {
        setState(() {
          _errorMessage = 'Product name is required for Item ${i + 1}.';
        });
        return;
      }
    }

    // Get current user from custom auth state.
    final customUser = ref.read(customAuthStateProvider);
    if (customUser == null) {
      setState(() {
        _errorMessage = 'No user is signed in.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Build a list of QuotationItem objects.
      final List<QuotationItem> items = _items.map((itemData) {
        final double unitPrice =
            double.tryParse(itemData.unitPriceController.text.trim()) ?? 0;
        final int quantity =
            int.tryParse(itemData.quantityController.text.trim()) ?? 0;
        final double amount = unitPrice * quantity;
        return QuotationItem(
          itemId: const Uuid().v4(), // Generate a unique id for the item.
          productName: itemData.productNameController.text.trim(),
          manufacturer: itemData.manufacturerController.text.trim().isNotEmpty
              ? itemData.manufacturerController.text.trim()
              : null,
          marka: itemData.markaController.text.trim().isNotEmpty
              ? itemData.markaController.text.trim()
              : null,
          film: itemData.filmController.text.trim().isNotEmpty
              ? itemData.filmController.text.trim()
              : null,
          fabricColor: itemData.fabricColorController.text.trim().isNotEmpty
              ? itemData.fabricColorController.text.trim()
              : null,
          weight: double.tryParse(itemData.weightController.text.trim()),
          quantity: quantity,
          deliveryDate: itemData.deliveryDate,
          unitPrice: unitPrice,
          amount: amount,
        );
      }).toList();

      // Sum all item amounts for totalAmount.
      final totalAmount =
          items.fold<double>(0, (sum, item) => sum + (item.amount ?? 0));

      // Create the Quotation object.
      final newQuotation = Quotation(
        companyName: _companyNameCtrl.text.trim(),
        items: items,
        createdByUid: customUser.id,
        totalAmount: totalAmount,
      );

      await ref
          .read(quotationProvider.notifier)
          .createQuotation(newQuotation, context);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quotation created successfully!')),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
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

  Widget _buildItemForm(int index, _QuotationItemData itemData) {
    // Calculate current amount (if valid values exist)
    final double unitPrice =
        double.tryParse(itemData.unitPriceController.text) ?? 0;
    final int quantity = int.tryParse(itemData.quantityController.text) ?? 0;
    final double amount = unitPrice * quantity;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item ${index + 1}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: itemData.productNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: itemData.manufacturerController,
              decoration: const InputDecoration(labelText: 'Manufacturer'),
            ),
            TextFormField(
              controller: itemData.markaController,
              decoration: const InputDecoration(labelText: 'Marka'),
            ),
            TextFormField(
              controller: itemData.filmController,
              decoration: const InputDecoration(labelText: 'Film'),
            ),
            TextFormField(
              controller: itemData.fabricColorController,
              decoration: const InputDecoration(labelText: 'Fabric Color'),
            ),
            TextFormField(
              controller: itemData.weightController,
              decoration: const InputDecoration(labelText: 'Weight (gm)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: itemData.quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (_) {
                setState(() {});
              },
            ),
            TextFormField(
              controller: itemData.unitPriceController,
              decoration: const InputDecoration(labelText: 'Unit Price'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) {
                setState(() {});
              },
            ),
            const SizedBox(height: 8),
            // Display the computed amount.
            Text(
              'Amount: \$${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    itemData.deliveryDate == null
                        ? 'Delivery Date: Not Selected'
                        : 'Delivery Date: ${DateFormat.yMd().format(itemData.deliveryDate!)}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _pickItemDate(context, itemData),
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            if (_items.length > 1)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _items.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Remove Item',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quotation'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Company Name field.
                    TextFormField(
                      controller: _companyNameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Company Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    // Section Title for Items.
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Items',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // List of item forms.
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (context, index) =>
                          _buildItemForm(index, _items[index]),
                    ),
                    // "Add another item" button.
                    TextButton.icon(
                      onPressed: _addNewItem,
                      icon: const Icon(Icons.add),
                      label: const Text('Add another item'),
                    ),
                    const SizedBox(height: 24),
                    // "Submit Quotation" block button.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitQuotation,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Submit Quotation',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
