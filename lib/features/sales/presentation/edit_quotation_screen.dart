import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import '../../../models/quotation_model.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/quotation_provider.dart';

class EditQuotationScreen extends ConsumerStatefulWidget {
  final Quotation quotation;
  const EditQuotationScreen({super.key, required this.quotation});

  @override
  ConsumerState<EditQuotationScreen> createState() =>
      _EditQuotationScreenState();
}

class _EditQuotationScreenState extends ConsumerState<EditQuotationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _companyNameCtrl;
  List<_QuotationItemData> _items = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize company name controller with the existing quotation company name.
    _companyNameCtrl =
        TextEditingController(text: widget.quotation.companyName);
    // Initialize item controllers from existing quotation items.
    if (widget.quotation.items != null && widget.quotation.items!.isNotEmpty) {
      _items = widget.quotation.items!
          .map((item) => _QuotationItemData.fromQuotationItem(item))
          .toList();
    } else {
      _items = [_QuotationItemData()];
    }
  }

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _addNewItem() {
    setState(() {
      _items.add(_QuotationItemData());
    });
  }

  Future<void> _pickItemDate(
      BuildContext context, _QuotationItemData itemData) async {
    final now = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: itemData.deliveryDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (newDate != null) {
      setState(() {
        itemData.deliveryDate = newDate;
      });
    }
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
      // Build list of updated QuotationItem objects.
      final List<QuotationItem> items = _items.map((itemData) {
        final double unitPrice =
            double.tryParse(itemData.unitPriceController.text.trim()) ?? 0;
        final int quantity =
            int.tryParse(itemData.quantityController.text.trim()) ?? 0;
        final double amount = unitPrice * quantity;
        return QuotationItem(
          // Preserve existing itemId if present; otherwise generate new.
          itemId:
              itemData.itemId.isNotEmpty ? itemData.itemId : const Uuid().v4(),
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

      // Sum total amount.
      final totalAmount =
          items.fold<double>(0, (sum, item) => sum + (item.amount ?? 0));

      // Create updated quotation.
      final updatedQuotation = widget.quotation.copyWith(
        companyName: _companyNameCtrl.text.trim(),
        items: items,
        totalAmount: totalAmount,
      );

      // Call updateQuotation on your provider.
      await ref
          .read(quotationProvider.notifier)
          .updateQuotation(updatedQuotation);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quotation updated successfully!')),
      );
      context.pop();
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
            border: const OutlineInputBorder(),
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

  /// Builds the form for a single quotation item.
  Widget _buildItemForm(int index, _QuotationItemData itemData) {
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
            Text("Item ${index + 1}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            // Film field using dropdown.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Film',
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
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
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
                    'Amount: \$${amount.toStringAsFixed(2)}',
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
                        : 'Delivery Date: ${DateFormat.yMMMd().format(itemData.deliveryDate!)}',
                    style: const TextStyle(fontSize: 14),
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
                  label: const Text('Remove Item',
                      style: TextStyle(color: Colors.red)),
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
        title: const Text('Edit Quotation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (role == 'admin') {
              context.goNamed('adminQuotations');
            } else {
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
                    // Company Name field.
                    _buildLabeledField(
                      heading: 'Company Name',
                      hint: 'Enter company name',
                      controller: _companyNameCtrl,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (context, index) =>
                          _buildItemForm(index, _items[index]),
                    ),
                    TextButton.icon(
                      onPressed: _addNewItem,
                      icon: const Icon(Icons.add),
                      label: const Text('Add another item'),
                    ),
                    const SizedBox(height: 24),
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
                          'Update Quotation',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.7),
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

/// Helper class to manage text controllers for a quotation item.
class _QuotationItemData {
  final String itemId;
  final TextEditingController productNameController;
  final TextEditingController manufacturerController;
  final TextEditingController markaController;
  final TextEditingController filmController;
  final TextEditingController fabricColorController;
  final TextEditingController weightController;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;
  DateTime? deliveryDate;

  _QuotationItemData({
    this.itemId = '',
    TextEditingController? productNameController,
    TextEditingController? manufacturerController,
    TextEditingController? markaController,
    TextEditingController? filmController,
    TextEditingController? fabricColorController,
    TextEditingController? weightController,
    TextEditingController? quantityController,
    TextEditingController? unitPriceController,
    this.deliveryDate,
  })  : productNameController =
            productNameController ?? TextEditingController(),
        manufacturerController =
            manufacturerController ?? TextEditingController(),
        markaController = markaController ?? TextEditingController(),
        filmController = filmController ?? TextEditingController(),
        fabricColorController =
            fabricColorController ?? TextEditingController(),
        weightController = weightController ?? TextEditingController(),
        quantityController = quantityController ?? TextEditingController(),
        unitPriceController = unitPriceController ?? TextEditingController();

  factory _QuotationItemData.fromQuotationItem(QuotationItem item) {
    return _QuotationItemData(
      itemId: item.itemId,
      productNameController: TextEditingController(text: item.productName),
      manufacturerController:
          TextEditingController(text: item.manufacturer ?? ''),
      markaController: TextEditingController(text: item.marka ?? ''),
      filmController: TextEditingController(text: item.film ?? ''),
      fabricColorController:
          TextEditingController(text: item.fabricColor ?? ''),
      weightController:
          TextEditingController(text: item.weight?.toString() ?? ''),
      quantityController:
          TextEditingController(text: item.quantity?.toString() ?? ''),
      unitPriceController:
          TextEditingController(text: item.unitPrice?.toString() ?? ''),
      deliveryDate: item.deliveryDate,
    );
  }

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

/// Custom Tab Indicator that rounds the left side for the first tab
/// and the right side for the second tab.
class CustomTabIndicator extends Decoration {
  final Color color;
  final double radius;
  const CustomTabIndicator({required this.color, this.radius = 30});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(color: color, radius: radius);
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final Color color;
  final double radius;
  _CustomTabIndicatorPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    RRect rrect;
    if (offset.dx == 0) {
      // First tab: round the left side.
      rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      );
    } else {
      // Second tab: round the right side.
      rrect = RRect.fromRectAndCorners(
        rect,
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
    }
    final paint = Paint()..color = color;
    canvas.drawRRect(rrect, paint);
  }
}
