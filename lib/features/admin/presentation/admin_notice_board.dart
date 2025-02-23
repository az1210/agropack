import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../models/notice_model.dart';
import '../../../models/user.dart';
import '../../../common/providers/notice_provider.dart';
import './notice_publish_screen.dart';
import '../../sales/presentation/notice_detail_screen.dart';

class AdminNoticeBoardScreen extends ConsumerWidget {
  const AdminNoticeBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsyncValue = ref.watch(adminNoticesStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Notice Board"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.goNamed('adminPublishNotice');
            },
          ),
        ],
      ),
      body: noticesAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (notices) {
          if (notices.isEmpty) {
            return const Center(child: Text("No notices available."));
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(adminNoticesStreamProvider);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                // Adjust childAspectRatio to provide more vertical space (lower value => taller cells)
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: notices.length,
                itemBuilder: (context, index) {
                  final notice = notices[index];
                  Widget targetedUsersWidget;
                  if (notice.targetUserIds == 'all') {
                    targetedUsersWidget = const Text(
                      "Target: All Users",
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  } else if (notice.targetUserIds is List) {
                    final List<String> userIds =
                        List<String>.from(notice.targetUserIds);
                    final usersAsyncValue = ref.watch(allUsersProvider);
                    targetedUsersWidget = usersAsyncValue.when(
                      loading: () => const Text(
                        "Target: Loading...",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      error: (err, stack) => Text(
                        "Error: $err",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white70),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      data: (users) {
                        final targetedUsers = users
                            .where((user) => userIds.contains(user.id))
                            .toList();
                        final names = targetedUsers
                            .map((user) => (user.name?.isNotEmpty ?? false)
                                ? user.name!
                                : user.email)
                            .toList();
                        return Text(
                          "Target: ${names.join(', ')}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    );
                  } else {
                    targetedUsersWidget = const SizedBox();
                  }
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
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Notice details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notice.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                const SizedBox(height: 12),
                                Container(
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
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                targetedUsersWidget,
                              ],
                            ),
                            // Action Icons Row using Wrap to handle potential overflow
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              alignment: WrapAlignment.end,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white, size: 20),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text(
                                            'Are you sure you want to delete this notice?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirm == true) {
                                      try {
                                        await ref
                                            .read(noticeProvider.notifier)
                                            .deleteNotice(notice);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Notice deleted successfully')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text('Error: $e')),
                                        );
                                      }
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 35,
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.arrow_forward,
                                      color: Colors.white, size: 20),
                                  onPressed: () {
                                    context.goNamed(
                                      'noticeDetail',
                                      pathParameters: {'id': notice.id!},
                                      extra: notice,
                                    );
                                  },
                                ),
                              ],
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
