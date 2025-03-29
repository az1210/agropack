// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../models/user.dart';
// import '../providers/create_user_provider.dart';

// class CreateUserScreen extends ConsumerStatefulWidget {
//   const CreateUserScreen({super.key});

//   @override
//   ConsumerState<CreateUserScreen> createState() => _CreateUserScreenState();
// }

// class _CreateUserScreenState extends ConsumerState<CreateUserScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _idController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   // Remove the role text controller.
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   // Dropdown selection for role.
//   String? _selectedRole;

//   bool _isLoading = false;
//   String _errorMessage = '';

//   @override
//   void dispose() {
//     _idController.dispose();
//     _emailController.dispose();
//     _nameController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _createUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_selectedRole == null) {
//       setState(() {
//         _errorMessage = 'Please select a role';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     try {
//       // Create a new UserModel from the input.
//       final newUser = UserModel(
//         id: _idController.text.trim(),
//         email: _emailController.text.trim(),
//         role: _selectedRole!,
//         name: _nameController.text.trim(),
//         phone: _phoneController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       // Call the createUserProvider.
//       await ref.read(createUserProvider(newUser).future);

//       // Show success message and navigate back.
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User created successfully!')),
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

//   List<DropdownMenuItem<String>> get _roleDropdownItems {
//     return const [
//       DropdownMenuItem(value: 'admin', child: Text('Admin')),
//       DropdownMenuItem(value: 'sales', child: Text('Sales')),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create User'),
//       ),
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
//                     // Dropdown for role selection.
//                     DropdownButtonFormField<String>(
//                       value: _selectedRole,
//                       items: _roleDropdownItems,
//                       decoration: const InputDecoration(
//                         labelText: 'Role',
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedRole = value;
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select a role';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(labelText: 'Full Name'),
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
//                       onPressed: _createUser,
//                       child: const Text('Create User'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user.dart';
import '../providers/create_user_provider.dart';

class CreateUserScreen extends ConsumerStatefulWidget {
  const CreateUserScreen({super.key});

  @override
  ConsumerState<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends ConsumerState<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dropdown selection for role.
  String? _selectedRole;
  String? _selectedZone;

  bool _isLoading = false;
  String _errorMessage = '';

  List<DropdownMenuItem<String>> get _roleDropdownItems {
    return const [
      DropdownMenuItem(value: 'admin', child: Text('Admin')),
      DropdownMenuItem(value: 'sales', child: Text('Sales')),
    ];
  }

  List<DropdownMenuItem<String>> get _zoneDropdownItems {
    return const [
      DropdownMenuItem(value: 'dhaka', child: Text('Dhaka')),
      DropdownMenuItem(value: 'chittagong', child: Text('Chittagong')),
      DropdownMenuItem(value: 'khulna', child: Text('Khulna')),
      DropdownMenuItem(value: 'rajshahi', child: Text('Rajshahi')),
      DropdownMenuItem(value: 'sylhet', child: Text('Sylhet')),
      DropdownMenuItem(value: 'barisal', child: Text('Barisal')),
      DropdownMenuItem(value: 'rangpur', child: Text('Rangpur')),
      DropdownMenuItem(value: 'mymensingh', child: Text('Mymensingh')),
    ];
  }

  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRole == null) {
      setState(() {
        _errorMessage = 'Please select a role';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final newUser = UserModel(
        id: _idController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole!,
        name: _nameController.text.trim(),
        zone: _selectedZone!,
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await ref.read(createUserProvider(newUser).future);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User created successfully!')),
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
    required String labelText,
    bool isObscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: _idController,
                  labelText: 'User ID',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a User ID';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: _roleDropdownItems,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
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
                ),
                _buildTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DropdownButtonFormField<String>(
                    value: _selectedZone,
                    items: _zoneDropdownItems,
                    decoration: const InputDecoration(
                      labelText: 'Zone',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedZone = value;
                      });
                    },
                  ),
                ),
                _buildTextField(
                  controller: _phoneController,
                  labelText: 'Phone (optional)',
                ),
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  isObscure: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _createUser,
                        child: const Text(
                          'Create User',
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
