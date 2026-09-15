import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/customer_provider.dart';
import '../services/mock_notification_provider.dart';
import '../models/notification.dart';
import '../widgets/tongkrongan_card.dart';
import '../widgets/category_filter.dart';
import '../widgets/loading_shimmer.dart';
import 'customer_detail_screen.dart';
import '../models/tongkrongan.dart';

/// Home screen untuk customer role - menampilkan daftar tongkrongan
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final List<String> categories = [
    'Semua',
    'Cafe&Pastry',
    'Kedai',
    'Oleh-oleh',
    'Tempat Viral',
  ];

  String? selectedCategory;
  String? selectedCity;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadTongkrongan();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTongkrongan() {
    final provider = context.read<CustomerProvider>();
    provider.fetchTongkrongan(
      page: _currentPage,
      category: selectedCategory,
      city: selectedCity,
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });
      _loadTongkrongan();
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      _loadTongkrongan();
    } else {
      context.read<CustomerProvider>().searchTongkrongan(query);
    }
  }

  void _toggleFavorite(Tongkrongan tongkrongan) {
    final provider = context.read<CustomerProvider>();
    final isFavorite = provider.isFavorite(tongkrongan.id);

    if (isFavorite) {
      // Remove from favorites
      // TODO: implement with token
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dihapus dari favorit')),
      );
    } else {
      // Add to favorites
      // TODO: implement with token
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ditambahkan ke favorit')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nongkrong'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {
              // Navigate to favorites
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Navigate to profile
            },
          ),
        ],
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, _) {
          final activeNotifications = MockNotificationProvider.getActiveNotifications();
          
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Notification Banner (if any)
              if (activeNotifications.isNotEmpty)
                SliverToBoxAdapter(
                  child: _NotificationBanner(
                    notification: activeNotifications.first,
                  ),
                ),
              // Search & Category Section
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search Field
                          TextField(
                            controller: _searchController,
                            onChanged: _onSearch,
                            decoration: InputDecoration(
                              hintText: 'Cari tongkrongan...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        _onSearch('');
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Category Filter
                          const Text(
                            'Kategori',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CategoryFilter(
                            categories: categories,
                            selectedCategory: selectedCategory,
                            onCategoryChanged: (category) {
                              setState(() {
                                selectedCategory = category;
                                _currentPage = 1;
                              });
                              _loadTongkrongan();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Error State
              if (provider.tongkronganError != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.tongkronganError ?? 'Unknown error',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _loadTongkrongan,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Loading State
              if (provider.isLoadingTongkrongan && provider.tongkronganList.isEmpty)
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const SkeletonCard(),
                    childCount: 6,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                ),
              // Empty State
              if (provider.tongkronganList.isEmpty &&
                  !provider.isLoadingTongkrongan &&
                  provider.tongkronganError == null)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_city,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada tongkrongan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Coba ubah filter atau cari dengan kata kunci lain',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Tongkrongan Grid
              if (provider.tongkronganList.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final tongkrongan = provider.tongkronganList[index];
                        final isFav = provider.isFavorite(tongkrongan.id);

                        return TongkronganCard(
                          tongkrongan: tongkrongan,
                          isFavorite: isFav,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomerDetailScreen(tongkrongan: tongkrongan),
                              ),
                            );
                          },
                          onFavoriteTap: () {
                            _toggleFavorite(tongkrongan);
                          },
                        );
                      },
                      childCount: provider.tongkronganList.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                  ),
                ),
              // Loading More Indicator
              if (_isLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              // Bottom Padding
              SliverToBoxAdapter(
                child: const SizedBox(height: 16),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Notification Banner Widget
class _NotificationBanner extends StatelessWidget {
  final AppNotification notification;

  const _NotificationBanner({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIcon(),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.typeDisplay,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _getTextColor(),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Close Button
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              // Handle dismiss
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (notification.type) {
      case 'promo':
        return Colors.orange.withOpacity(0.15);
      case 'event':
        return Colors.blue.withOpacity(0.15);
      default:
        return Colors.green.withOpacity(0.15);
    }
  }

  Color _getBorderColor() {
    switch (notification.type) {
      case 'promo':
        return Colors.orange.withOpacity(0.4);
      case 'event':
        return Colors.blue.withOpacity(0.4);
      default:
        return Colors.green.withOpacity(0.4);
    }
  }

  Color _getIconBackgroundColor() {
    switch (notification.type) {
      case 'promo':
        return Colors.orange;
      case 'event':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  Color _getTextColor() {
    switch (notification.type) {
      case 'promo':
        return Colors.orange.shade700;
      case 'event':
        return Colors.blue.shade700;
      default:
        return Colors.green.shade700;
    }
  }

  IconData _getIcon() {
    switch (notification.type) {
      case 'promo':
        return Icons.local_offer;
      case 'event':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }
}
