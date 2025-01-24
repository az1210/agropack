// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../auth/providers/auth_providers.dart';

// class SalesHomeScreen extends ConsumerWidget {
//   const SalesHomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authRepo = ref.watch(authRepositoryProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sales Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await authRepo.signOut();
//             },
//           )
//         ],
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Navigate to Quotation Creation
//             context.goNamed('createQuotation');
//           },
//           child: const Text('Create Quotation'),
//         ),
//       ),
//     );
//   }
// }

// lib/features/home/presentation/sales_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_providers.dart';

class SalesHomeScreen extends ConsumerWidget {
  const SalesHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authRepo.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.goNamed('createQuotation');
          },
          child: const Text('Create Quotation'),
        ),
      ),
    );
  }
}
