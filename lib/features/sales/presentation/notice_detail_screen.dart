// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import '../../../models/notice_model.dart';
// import '../../../common/providers/notice_provider.dart';
// import '../../auth/providers/auth_providers.dart';

// class NoticeDetailScreen extends ConsumerStatefulWidget {
//   final Notice notice;
//   const NoticeDetailScreen({super.key, required this.notice});

//   @override
//   ConsumerState<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
// }

// class _NoticeDetailScreenState extends ConsumerState<NoticeDetailScreen> {
//   final TextEditingController _commentController = TextEditingController();

//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }

//   /// Create a stream that listens to updates for this notice.
//   Stream<Notice> _noticeStream(String noticeId) {
//     final firestore = FirebaseFirestore.instance;
//     return firestore.collection('notices').doc(noticeId).snapshots().map((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       data['id'] = doc.id;
//       return Notice.fromMap(data);
//     });
//   }

//   Future<void> _submitComment() async {
//     final commentText = _commentController.text.trim();
//     if (commentText.isEmpty) return;
//     // Get the current user.
//     final user = ref.watch(customAuthStateProvider);
//     if (user == null) return;
//     // Use the user's name if available; otherwise fallback to email.
//     final currentUsername =
//         (user.name?.trim().isNotEmpty ?? false) ? user.name! : user.email;
//     final comment = NoticeComment(
//       commenter: currentUsername,
//       comment: commentText,
//       commentedAt: DateTime.now(),
//     );
//     await ref
//         .read(noticeProvider.notifier)
//         .addComment(widget.notice.id!, comment);
//     _commentController.clear();
//     // No need to call setState as stream will update the UI.
//   }

//   Future<void> _deleteComment(Notice notice, NoticeComment comment) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Delete Comment'),
//           content: const Text('Are you sure you want to delete your comment?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: const Text('Delete', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//     if (confirm == true) {
//       await ref
//           .read(noticeProvider.notifier)
//           .deleteComment(notice.id!, comment);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Use a stream so that new comments appear instantly.
//     return StreamBuilder<Notice>(
//       stream: _noticeStream(widget.notice.id!),
//       initialData: widget.notice,
//       builder: (context, snapshot) {
//         final notice = snapshot.data;
//         if (notice == null) {
//           return Scaffold(
//             appBar: AppBar(title: const Text("Notice Detail")),
//             body: const Center(child: Text("Notice not found.")),
//           );
//         }
//         // Get current user to determine ownership of comments.
//         final user = ref.watch(customAuthStateProvider);
//         final currentUsername = (user?.name?.trim().isNotEmpty ?? false)
//             ? user!.name!
//             : user?.email ?? 'Unknown User';
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text("Notice Detail"),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => context.pop(),
//             ),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   notice.title,
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   DateFormat.yMMMd().add_jm().format(notice.createdAt),
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   notice.content,
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 const Divider(height: 32),
//                 const Text(
//                   "Comments",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: notice.comments?.length ?? 0,
//                     itemBuilder: (context, index) {
//                       final comment = notice.comments![index];
//                       return ListTile(
//                         title: Text(comment.commenter),
//                         subtitle: Text(comment.comment),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               DateFormat.yMMMd().format(comment.commentedAt),
//                               style: const TextStyle(fontSize: 12),
//                             ),
//                             // If this comment belongs to the current user, show a delete icon.
//                             if (comment.commenter == currentUsername)
//                               IconButton(
//                                 icon: const Icon(Icons.delete,
//                                     color: Colors.red, size: 20),
//                                 onPressed: () =>
//                                     _deleteComment(notice, comment),
//                               ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _commentController,
//                         decoration: const InputDecoration(
//                           hintText: "Enter your comment...",
//                           border: OutlineInputBorder(),
//                         ),
//                         // Allow multiple lines.
//                         maxLines: 3,
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       onPressed: _submitComment,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/notice_model.dart';
import '../../../common/providers/notice_provider.dart';
import '../../auth/providers/auth_providers.dart';

class NoticeDetailScreen extends ConsumerStatefulWidget {
  final Notice notice;
  const NoticeDetailScreen({super.key, required this.notice});

  @override
  ConsumerState<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends ConsumerState<NoticeDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// Listen to live updates of the notice.
  Stream<Notice> _noticeStream(String noticeId) {
    final firestore = FirebaseFirestore.instance;
    return firestore.collection('notices').doc(noticeId).snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Notice.fromMap(data);
    });
  }

  Future<void> _submitComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;
    final user = ref.watch(customAuthStateProvider);
    if (user == null) return;
    final currentUsername =
        (user.name?.trim().isNotEmpty ?? false) ? user.name! : user.email;
    final comment = NoticeComment(
      commenter: currentUsername,
      comment: commentText,
      commentedAt: DateTime.now(),
    );
    await ref
        .read(noticeProvider.notifier)
        .addComment(widget.notice.id!, comment);
    _commentController.clear();
  }

  Future<void> _deleteComment(Notice notice, NoticeComment comment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Comment'),
          content: const Text('Are you sure you want to delete your comment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      await ref
          .read(noticeProvider.notifier)
          .deleteComment(notice.id!, comment);
    }
  }

  // Redesigned comment card to show full comment text.
  Widget _buildCommentCard(
      Notice notice, NoticeComment comment, String currentUsername) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comment Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  comment.commenter,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat.yMMMd().format(comment.commentedAt),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Comment text
            Text(
              comment.comment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (comment.commenter == currentUsername)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () => _deleteComment(notice, comment),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Notice>(
      stream: _noticeStream(widget.notice.id!),
      initialData: widget.notice,
      builder: (context, snapshot) {
        final notice = snapshot.data;
        if (notice == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Notice Detail"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text("Notice not found.")),
          );
        }
        final user = ref.watch(customAuthStateProvider);
        final currentUsername = (user?.name?.trim().isNotEmpty ?? false)
            ? user!.name!
            : user?.email ?? 'Unknown User';
        return Scaffold(
          appBar: AppBar(
            title: const Text("Notice Detail"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Enlarged Notice Header with Gradient Background
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 56, 112, 207),
                            Color.fromARGB(255, 36, 137, 219)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notice.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat.yMMMd()
                                .add_jm()
                                .format(notice.createdAt),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            notice.content,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Comments Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Comments",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                // Comments List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final comment = notice.comments?[index];
                      if (comment == null) return const SizedBox();
                      return _buildCommentCard(
                          notice, comment, currentUsername);
                    },
                    childCount: notice.comments?.length ?? 0,
                  ),
                ),
                // Comment Input Area
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: "Add a comment...",
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: _submitComment,
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 3, 110, 197),
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
