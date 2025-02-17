import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/quotation_model.dart';
import '../../sales/providers/quotation_provider.dart';

class EditQuotationScreen extends ConsumerStatefulWidget {
  final Quotation quotation;
  const EditQuotationScreen({Key? key, required this.quotation})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditQuotationScreenState();
}

class _EditQuotationScreenState extends ConsumerState<EditQuotationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyNameCtrl;
  late TextEditingController _productNameCtrl;
  // ... add more controllers as needed

  @override
  void initState() {
    super.initState();
    _companyNameCtrl =
        TextEditingController(text: widget.quotation.companyName);
    // _productNameCtrl =
    //     TextEditingController(text: widget.quotation.productName);
    // ... initialize other fields similarly
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(quotationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Quotation')),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _companyNameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Company Name'),
                    ),
                    TextFormField(
                      controller: _productNameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Product Name'),
                    ),
                    // ... more fields to edit

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // Update Quotation
                        final updated = widget.quotation.copyWith(
                          companyName: _companyNameCtrl.text.trim(),
                          // productName: _productNameCtrl.text.trim(),
                          // ... other fields
                        );
                        await controller.updateQuotation(updated);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save Changes'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // Approve Quotation
                        await controller.approveQuotation(widget.quotation);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: const Text('Approve'),
                    ),

                    if (controller.errorMessage.isNotEmpty)
                      Text(
                        controller.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
