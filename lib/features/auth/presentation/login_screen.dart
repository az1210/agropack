// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/auth_providers.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _isLoading = false;
//   String _errorMessage = '';

//   @override
//   Widget build(BuildContext context) {
//     final authRepo = ref.watch(authRepositoryProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: _emailController,
//                     decoration:
//                         const InputDecoration(labelText: 'Email Address'),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(labelText: 'Password'),
//                     obscureText: true,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () async {
//                       setState(() {
//                         _isLoading = true;
//                         _errorMessage = '';
//                       });
//                       try {
//                         await authRepo.signInWithEmailAndPassword(
//                           _emailController.text.trim(),
//                           _passwordController.text.trim(),
//                         );
//                       } on Exception catch (e) {
//                         setState(() {
//                           _errorMessage = e.toString();
//                         });
//                       } finally {
//                         setState(() {
//                           _isLoading = false;
//                         });
//                       }
//                     },
//                     child: const Text('Login'),
//                   ),
//                   if (_errorMessage.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         _errorMessage,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// lib/features/auth/presentation/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        setState(() {
                          _errorMessage = 'Please fill in all fields.';
                        });
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                        _errorMessage = '';
                      });

                      try {
                        await ref.read(signInProvider(
                            {'email': email, 'password': password}).future);

                        // Navigate based on role or home page.
                        if (context.mounted) {
                          // Replace with your desired navigation logic.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login successful!')),
                          );
                        }
                      } catch (e) {
                        setState(() {
                          _errorMessage = 'Login failed: ${e.toString()}';
                        });
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: const Text('Login'),
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
    );
  }
}
