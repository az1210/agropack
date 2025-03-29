import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/quotation_model.dart';
import '../providers/quotation_provider.dart';
import '../../auth/providers/auth_providers.dart';

class QuotationScreen extends ConsumerStatefulWidget {
  const QuotationScreen({super.key});

  @override
  ConsumerState<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends ConsumerState<QuotationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      // Avoid unnecessary rebuilds by calling setState only when text actually changes.
      final newQuery = _searchController.text.toLowerCase();
      if (_searchQuery != newQuery) {
        setState(() {
          _searchQuery = newQuery;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter quotations based on status and search query.
  List<Quotation> _filterQuotations(List<Quotation> quotations, String status) {
    return quotations.where((q) {
      final matchesStatus = q.status?.toLowerCase() == status.toLowerCase();
      final matchesSearch = q.companyName.toLowerCase().contains(_searchQuery);
      return matchesStatus && matchesSearch;
    }).toList();
  }

  Future<List<Quotation>> _fetchQuotations(String role, String userId) async {
    if (role == 'admin') {
      return await ref.read(quotationProvider.notifier).fetchAllQuotations();
    } else {
      return await ref
          .read(quotationProvider.notifier)
          .fetchQuotationsForUser(userId);
    }
  }

  Future<void> _refreshData(String role, String userId) async {
    setState(() {});
    await _fetchQuotations(role, userId);
  }

  /// Build the search field widget, placed at the top of the screen.
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by Company Name...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _searchController.clear(),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
    );
  }

  /// Builds a list of quotation cards for a given status.
  Widget _buildQuotationList(List<Quotation> quotations,
      {required bool isPending}) {
    final customUser = ref.watch(customAuthStateProvider);
    final role = customUser?.role;
    if (quotations.isEmpty) {
      return const Center(child: Text('No quotations available.'));
    }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: quotations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final quotation = quotations[index];
        return GestureDetector(
          onTap: () {
            if (role == "admin") {
              context.goNamed(
                'adminQuotationDetail',
                pathParameters: {'id': quotation.id!},
                extra: quotation,
              );
            } else {
              context.goNamed(
                'quotationDetail',
                pathParameters: {'id': quotation.id!},
                extra: quotation,
              );
            }
          },
          child: SizedBox(
            height: 120, // Fixed height for the card widget.
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    // Company Avatar.
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        quotation.companyName.substring(0, 1).toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Quotation Details.
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quotation.companyName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Product: ${quotation.items != null && quotation.items!.isNotEmpty ? quotation.items![0].productName ?? 'N/A' : 'N/A'}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Status: ${quotation.status == 'pending_admin_verification' ? 'Pending' : 'Approved'}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Popup menu for edit and delete actions.
                    if (role == "admin" ||
                        (role == "sales" &&
                            quotation.status == 'pending_admin_verification'))
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            if (role == "admin") {
                              context.goNamed(
                                'editAdminQuotation',
                                pathParameters: {'id': quotation.id!},
                                extra: quotation,
                              );
                            } else if (role == "sales" &&
                                quotation.status ==
                                    'pending_admin_verification') {
                              context.goNamed(
                                'editQuotation',
                                pathParameters: {'id': quotation.id!},
                                extra: quotation,
                              );
                            }
                          } else if (value == 'delete') {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                      'Are you sure you want to delete this quotation?'),
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
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirm == true) {
                              try {
                                await ref
                                    .read(quotationProvider.notifier)
                                    .deleteQuotation(quotation);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.grey,
                                      content: Text(
                                          'Quotation deleted successfully')),
                                );
                                setState(() {});
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customUser = ref.watch(customAuthStateProvider);
    if (customUser == null) {
      return const Center(child: Text('No user logged in'));
    }
    final role = customUser.role;
    final userId = customUser.id;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          title: const Text(
            'Quotations',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (role == 'admin') {
                context.goNamed('adminHome');
              } else if (role == 'sales') {
                context.goNamed('salesHome');
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          onPressed: () {
            if (role == "admin") {
              context.goNamed("createAdminQuotation");
            } else if (role == "sales") {
              context.goNamed("createQuotation");
            }
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            // Place the search field at the top.
            _buildSearchField(),
            Expanded(
              child: FutureBuilder<List<Quotation>>(
                future: _fetchQuotations(role, userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final quotations = snapshot.data ?? [];
                    return RefreshIndicator(
                      onRefresh: () => _refreshData(role, userId),
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Custom TabBar with rounded indicators.
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TabBar(
                              labelStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: const CustomTabIndicator(
                                color: Colors.blueAccent,
                                radius: 30,
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.blueAccent,
                              tabs: const [
                                Tab(text: 'Pending'),
                                Tab(text: 'Approved'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // TabBarView containing filtered quotation lists.
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: TabBarView(
                              children: [
                                _buildQuotationList(
                                  _filterQuotations(
                                    quotations,
                                    'pending_admin_verification',
                                  ),
                                  isPending: true,
                                ),
                                _buildQuotationList(
                                  _filterQuotations(quotations, 'approved'),
                                  isPending: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Tab Indicator that rounds the left side for the first tab
/// and the right side for the second tab.
class CustomTabIndicator extends Decoration {
  final Color color;
  final double radius;
  const CustomTabIndicator({required this.color, this.radius = 30});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(color: color, radius: radius);
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final Color color;
  final double radius;
  _CustomTabIndicatorPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    RRect rrect;
    if (offset.dx == 0) {
      // First tab: round the left side.
      rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      );
    } else {
      // Second tab: round the right side.
      rrect = RRect.fromRectAndCorners(
        rect,
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
    }
    final paint = Paint()..color = color;
    canvas.drawRRect(rrect, paint);
  }
}
