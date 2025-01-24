import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../data/quotation_repository.dart';

class CreateQuotationScreen extends ConsumerStatefulWidget {
  const CreateQuotationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateQuotationScreenState();
}

class _CreateQuotationScreenState extends ConsumerState<CreateQuotationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameCtrl = TextEditingController();
  final _productNameCtrl = TextEditingController();
  final _markaCtrl = TextEditingController();
  final _filmCtrl = TextEditingController();
  final _fabricColorCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  DateTime? _deliveryDate;

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (newDate != null) {
      setState(() {
        _deliveryDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = QuotationRepository();
    final user = FirebaseAuth.instance.currentUser;

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
                    TextFormField(
                      controller: _companyNameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Company Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _productNameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Product Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _markaCtrl,
                      decoration: const InputDecoration(labelText: 'Marka'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _filmCtrl,
                      decoration: const InputDecoration(labelText: 'Film'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _fabricColorCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Fabric Color'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _weightCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Weight (gm)'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _quantityCtrl,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          _deliveryDate == null
                              ? 'Delivery Date: Not Selected'
                              : 'Delivery Date: ${DateFormat.yMd().format(_deliveryDate!)}',
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => _pickDate(context),
                          child: const Text('Pick Date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _deliveryDate != null &&
                            user != null) {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = '';
                          });
                          try {
                            await repository.createQuotation(
                              companyName: _companyNameCtrl.text.trim(),
                              productName: _productNameCtrl.text.trim(),
                              marka: _markaCtrl.text.trim(),
                              film: _filmCtrl.text.trim(),
                              fabricColor: _fabricColorCtrl.text.trim(),
                              weight:
                                  double.tryParse(_weightCtrl.text.trim()) ??
                                      0.0,
                              quantity:
                                  int.tryParse(_quantityCtrl.text.trim()) ?? 0,
                              deliveryDate: _deliveryDate!,
                              createdByUid: user.uid,
                            );
                            if (!mounted) return;
                            Navigator.of(context).pop(); // Return to Sales home
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
                      },
                      child: const Text('Submit Quotation'),
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
