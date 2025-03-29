import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/notice_model.dart';
import '../../../models/user.dart';
import '../../../common/providers/notice_provider.dart';

class AdminNoticePublishScreen extends ConsumerStatefulWidget {
  const AdminNoticePublishScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminNoticePublishScreen> createState() =>
      _AdminNoticePublishScreenState();
}

class _AdminNoticePublishScreenState
    extends ConsumerState<AdminNoticePublishScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // The selected target user IDs.
  List<String> _selectedUserIds = [];
  bool _sendToAll = false;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _publishNotice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Determine the target: either "all" or the selected user IDs.
    final target = _sendToAll ? 'all' : _selectedUserIds;

    final notice = Notice(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      createdAt: DateTime.now(),
      targetUserIds: target,
      comments: [],
    );

    try {
      await ref.read(noticeProvider.notifier).createNotice(notice);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notice published successfully!")),
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

  Widget _buildUserSelection(List<UserModel> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Target Users",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Checkbox(
              value: _sendToAll,
              onChanged: (value) {
                setState(() {
                  _sendToAll = value ?? false;
                  if (_sendToAll) {
                    _selectedUserIds = [];
                  }
                });
              },
            ),
            const Text("All Users"),
          ],
        ),
        if (!_sendToAll)
          Wrap(
            spacing: 8,
            children: users.map((user) {
              final isSelected = _selectedUserIds.contains(user.id);
              return FilterChip(
                label: Text(
                    (user.name?.isNotEmpty ?? false) ? user.name! : user.email),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedUserIds.add(user.id);
                    } else {
                      _selectedUserIds.remove(user.id);
                    }
                  });
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsyncValue = ref.watch(allUsersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice Publish"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Title",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: "Enter notice title",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Title is required"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Content",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: "Enter notice content",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      validator: (value) => value == null || value.isEmpty
                          ? "Content is required"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Use FutureBuilder to load real users.
                    usersAsyncValue.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Text("Error: $err"),
                      data: (users) => _buildUserSelection(users),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _publishNotice,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 56, 112, 207),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Create Notice",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
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
