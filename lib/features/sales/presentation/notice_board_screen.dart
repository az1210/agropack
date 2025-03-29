// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import '../../../common/providers/notice_provider.dart';
// import '../../auth/providers/auth_providers.dart';

// class NoticeBoardScreen extends ConsumerWidget {
//   const NoticeBoardScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Access the current user using the notifier so that we avoid nullability issues.
//     final currentUser = ref.watch(customAuthStateProvider.notifier).state;
//     if (currentUser == null) {
//       return const Scaffold(
//         body: Center(child: Text("No user logged in.")),
//       );
//     }
//     final noticesAsyncValue = ref.watch(userNoticesProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Notices"),
//       ),
//       body: noticesAsyncValue.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => Center(child: Text("Error: $err")),
//         data: (notices) {
//           if (notices.isEmpty) {
//             return const Center(child: Text("No notices assigned to you."));
//           }
//           return RefreshIndicator(
//             onRefresh: () async {
//               ref.refresh(userNoticesProvider);
//               await Future.delayed(const Duration(milliseconds: 500));
//             },
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: notices.length,
//               itemBuilder: (context, index) {
//                 final notice = notices[index];
//                 return Card(
//                   elevation: 3,
//                   margin: const EdgeInsets.only(bottom: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     title: Text(notice.title),
//                     subtitle: Text(
//                       DateFormat.yMMMd().add_jm().format(notice.createdAt),
//                     ),
//                     onTap: () {
//                       context.goNamed(
//                         'noticeDetail',
//                         pathParameters: {'id': notice.id!},
//                         extra: notice,
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../common/providers/notice_provider.dart';
import '../../auth/providers/auth_providers.dart';

class NoticeBoardScreen extends ConsumerWidget {
  const NoticeBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(customAuthStateProvider.notifier).state;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in.")),
      );
    }
    final noticesAsyncValue = ref.watch(userNoticesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notices"),
      ),
      body: noticesAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (notices) {
          if (notices.isEmpty) {
            return const Center(child: Text("No notices assigned to you."));
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(userNoticesProvider);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: notices.length,
                itemBuilder: (context, index) {
                  final notice = notices[index];
                  return Card(
                    color: const Color.fromARGB(255, 6, 105, 187),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        context.goNamed(
                          'noticeDetail',
                          pathParameters: {'id': notice.id!},
                          extra: notice,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Notice title
                            Text(
                              notice.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Created date
                            Text(
                              DateFormat.yMMMd()
                                  .add_jm()
                                  .format(notice.createdAt),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 12),
                            // Notice content snippet with highlight
                            Container(
                              height: 70,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                notice.content,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            // Navigation arrow
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
