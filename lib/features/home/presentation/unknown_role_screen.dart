// import 'package:flutter/material.dart';

// class UnknownRoleScreen extends StatelessWidget {
//   const UnknownRoleScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Your role is not recognized. Contact Admin.'),
//       ),
//     );
//   }
// }

// lib/features/home/presentation/unknown_role_screen.dart

import 'package:flutter/material.dart';

class UnknownRoleScreen extends StatelessWidget {
  const UnknownRoleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Your role is not recognized. Please contact admin.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
