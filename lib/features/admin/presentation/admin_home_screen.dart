import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';

import '../../auth/providers/auth_providers.dart';

// Example push notification provider that you might implement
final notificationCountProvider = StreamProvider<int>((ref) {
  // This could be a Firestore or FCM-based stream that reports # of new notifications
  // For now, let's simulate with a simple Stream.periodic
  return Stream<int>.periodic(
    const Duration(seconds: 5),
    (count) => (count % 5), // cycles through 0..4
  );
});

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(customAuthRepositoryProvider);

    // Example: Watch a stream of unread/pending notification counts.
    final notificationCount = ref.watch(notificationCountProvider).maybeWhen(
          data: (count) => count,
          orElse: () => 0,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          // Notification icon with a badge
          IconButton(
            onPressed: () {
              // Navigate to a notifications screen or show a dialog
            },
            icon: badges.Badge(
              badgeContent: Text(
                notificationCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              showBadge: notificationCount > 0,
              child: const Icon(Icons.notifications),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildCard(
              context,
              title: 'Quotations\nfor Approval',
              icon: Icons.list_alt_rounded,
              onTap: () {
                // 1. Navigate to a "Quotations for Approval" screen
                context.pushNamed('approvQuotation');
              },
            ),
            _buildCard(
              context,
              title: 'Confirmed\nOrders',
              icon: Icons.check_circle_outline,
              onTap: () {
                // 2. Navigate to "Confirmed Order Queue"
              },
            ),
            _buildCard(
              context,
              title: 'Order Placement\nto Factory',
              icon: Icons.local_shipping_outlined,
              onTap: () {
                // 3. Place order to factory screen
              },
            ),
            _buildCard(
              context,
              title: 'Product Received\nfrom Factory',
              icon: Icons.archive_outlined,
              onTap: () {
                // 4. Product Received screen
              },
            ),
            _buildCard(
              context,
              title: 'Product Received\nfrom Factory',
              icon: Icons.archive_outlined,
              onTap: () {
                // 4. Product Received screen
              },
            ),
            _buildCard(
              context,
              title: 'Notice Board',
              icon: Icons.notifications_active,
              onTap: () {
                context.goNamed('adminNoticeBoard');
              },
            ),
            _buildCard(
              context,
              title: 'Create Account',
              icon: Icons.person_add_alt_1,
              onTap: () {
                context.goNamed('createUser');
              },
            ),
            Center(
              child: TextButton(
                  onPressed: () async {
                    await signOutUser(ref);
                    context.goNamed('login');
                  },
                  child: Text('SignOut')),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build each menu item card.
  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon at top
              Icon(
                icon,
                size: 36,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 12),
              // Title text
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
