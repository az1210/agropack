// import 'package:agro_packaging/models/user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class EditUserScreen extends ConsumerStatefulWidget {
//   final UserModel user;
//   const EditUserScreen({super.key, required this.user});

//   @override
//   ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
// }

// class _EditUserScreenState extends ConsumerState<EditUserScreen> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _idController;
//   late TextEditingController _emailController;
//   late TextEditingController _roleController;
//   late TextEditingController _nameController;
//   late TextEditingController _phoneController;
//   late TextEditingController _passwordController;

//   bool _isLoading = false;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _idController = TextEditingController(text: widget.user.id);
//     _emailController = TextEditingController(text: widget.user.email);
//     _roleController = TextEditingController(text: widget.user.role);
//     _nameController = TextEditingController(text: widget.user.name);
//     _phoneController = TextEditingController(text: widget.user.phone);
//     _passwordController = TextEditingController(text: widget.user.password);
//   }

//   @override
//   void dispose() {
//     _idController.dispose();
//     _emailController.dispose();
//     _roleController.dispose();
//     _nameController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _updateUser() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//     try {
//       final updatedUser = UserModel(
//         id: _idController.text.trim(),
//         email: _emailController.text.trim(),
//         role: _roleController.text.trim(),
//         name: _nameController.text.trim(),
//         phone: _phoneController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(updatedUser.id)
//           .update(updatedUser.toMap());
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User updated successfully!')),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit User')),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     TextFormField(
//                       controller: _idController,
//                       decoration: const InputDecoration(labelText: 'User ID'),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter a User ID';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: const InputDecoration(labelText: 'Email'),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter an email';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _roleController,
//                       decoration: const InputDecoration(
//                           labelText: 'Role (admin, sales, client)'),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter a role';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _nameController,
//                       decoration:
//                           const InputDecoration(labelText: 'Name (optional)'),
//                     ),
//                     TextFormField(
//                       controller: _phoneController,
//                       decoration:
//                           const InputDecoration(labelText: 'Phone (optional)'),
//                     ),
//                     TextFormField(
//                       controller: _passwordController,
//                       decoration: const InputDecoration(labelText: 'Password'),
//                       obscureText: true,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter a password';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _updateUser,
//                       child: const Text('Update User'),
//                     ),
//                     if (_errorMessage.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 20),
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
import 'package:agro_packaging/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const EditUserScreen({super.key, required this.user});

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _idController;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _zoneController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  // Variable for dropdown selection.
  String? _selectedRole;

  bool _isLoading = false;
  String _errorMessage = '';

  List<DropdownMenuItem<String>> get _roleDropdownItems {
    return const [
      DropdownMenuItem(value: 'admin', child: Text('Admin')),
      DropdownMenuItem(value: 'sales', child: Text('Sales')),
    ];
  }

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.user.id);
    _emailController = TextEditingController(text: widget.user.email);
    _nameController = TextEditingController(text: widget.user.name);
    _zoneController = TextEditingController(text: widget.user.zone);
    _phoneController = TextEditingController(text: widget.user.phone);
    _passwordController = TextEditingController(text: widget.user.password);
    // Set default role to current user's role.
    _selectedRole = widget.user.role;
  }

  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _zoneController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final updatedUser = UserModel(
        id: _idController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole!, // use the selected dropdown value.
        name: _nameController.text.trim(),
        zone: _zoneController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser.id)
          .update(updatedUser.toMap());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _idController,
                      decoration: const InputDecoration(labelText: 'User ID'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a User ID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    // Dropdown for role selection.
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      items: _roleDropdownItems,
                      decoration: const InputDecoration(labelText: 'Role'),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a role';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    TextFormField(
                      controller: _zoneController,
                      decoration: const InputDecoration(labelText: 'Zone'),
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration:
                          const InputDecoration(labelText: 'Phone (optional)'),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _updateUser,
                      child: const Text(
                        'Update User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
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
