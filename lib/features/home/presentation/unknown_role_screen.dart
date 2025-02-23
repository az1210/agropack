import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/providers/auth_providers.dart';

class UnknownRoleScreen extends ConsumerStatefulWidget {
  const UnknownRoleScreen({super.key});

  @override
  ConsumerState<UnknownRoleScreen> createState() => _UnknownRoleScreenState();
}

class _UnknownRoleScreenState extends ConsumerState<UnknownRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Added for centering
        children: [
          Center(
            child: Text(
              'Your role is not recognized. Please contact admin.',
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () async {
              await signOutUser(ref);
              if (context.mounted) {
                Navigator.of(context).pop();
                context.goNamed('login');
              }
            },
            child: Text("Log out"),
          )
        ],
      ),
    );
  }
}
