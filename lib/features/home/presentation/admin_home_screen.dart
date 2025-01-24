// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../auth/providers/auth_providers.dart';

// class AdminHomeScreen extends ConsumerWidget {
//   const AdminHomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authRepo = ref.watch(authRepositoryProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await authRepo.signOut();
//             },
//           )
//         ],
//       ),
//       body: const Center(
//         child: Text('Admin Dashboard Placeholder'),
//       ),
//     );
//   }
// }

// lib/features/home/presentation/admin_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_providers.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authRepo.signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Admin Dashboard Placeholder'),
      ),
    );
  }
}
