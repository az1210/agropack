import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../models/quotation_model.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/quotation_provider.dart';

/// A helper class to hold form controllers for a single quotation item.
class _QuotationItemData {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController markaController = TextEditingController();
  // We'll use the filmController to store the dropdown value.
  final TextEditingController filmController = TextEditingController();
  final TextEditingController fabricColorController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
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
          itemId: const Uuid().v4(),
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
          context.pop();
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

  /// Helper method to build a labeled text field.
  Widget _buildLabeledField({
    required String heading,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          validator: validator,
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildItemForm(int index, _QuotationItemData itemData) {
    // Calculate current amount (if valid values exist)
    final double unitPrice =
        double.tryParse(itemData.unitPriceController.text) ?? 0;
    final int quantity = int.tryParse(itemData.quantityController.text) ?? 0;
    final double amount = unitPrice * quantity;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item ${index + 1}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildLabeledField(
              heading: 'Product Name',
              hint: 'Enter product name',
              controller: itemData.productNameController,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            _buildLabeledField(
              heading: 'Manufacturer',
              hint: 'Enter manufacturer',
              controller: itemData.manufacturerController,
            ),
            const SizedBox(height: 12),
            _buildLabeledField(
              heading: 'Marka',
              hint: 'Enter marka',
              controller: itemData.markaController,
            ),
            const SizedBox(height: 12),
            // Film field replaced with Dropdown.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Film/Block',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: itemData.filmController.text.isNotEmpty
                      ? itemData.filmController.text
                      : null,
                  items: const [
                    DropdownMenuItem(value: 'Film', child: Text('Film')),
                    DropdownMenuItem(value: 'Block', child: Text('Block')),
                    DropdownMenuItem(
                        value: 'Film+Block', child: Text('Film+Block')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      itemData.filmController.text = value ?? '';
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select film option',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  validator: (value) {
                    // Optional validator; add if required.
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildLabeledField(
              heading: 'Fabric Color',
              hint: 'Enter fabric color',
              controller: itemData.fabricColorController,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledField(
                    heading: 'Weight (gm)',
                    hint: 'Enter weight',
                    controller: itemData.weightController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLabeledField(
                    heading: 'Quantity',
                    hint: 'Enter quantity',
                    controller: itemData.quantityController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledField(
                    heading: 'Unit Price',
                    hint: 'Enter unit price',
                    controller: itemData.unitPriceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Amount: ${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    itemData.deliveryDate == null
                        ? 'Delivery Date: Not Selected'
                        : 'Delivery Date: ${DateFormat.yMd().format(itemData.deliveryDate!)}',
                    style: const TextStyle(fontSize: 16),
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
    final customUser = ref.watch(customAuthStateProvider);
    final role = customUser?.role;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quotation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (role == 'admin') {
              context.goNamed('adminQuotations');
            } else if (role == 'sales') {
              context.goNamed('quotations');
            }
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Company Name field with heading.
                    _buildLabeledField(
                      heading: 'Company Name',
                      hint: 'Enter company name',
                      controller: _companyNameCtrl,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 12),
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
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                      ),
                      label: const Text('Add another item',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 24),
                    // "Submit Quotation" button.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitQuotation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 0, 128, 1),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text(
                          'Submit Quotation',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
