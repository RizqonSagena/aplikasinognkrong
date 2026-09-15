import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/customer_provider.dart';
import '../widgets/tongkrongan_card.dart';
import '../widgets/loading_shimmer.dart';
import 'customer_detail_screen.dart';

/// Favorites/Wishlist screen untuk tongkrongan yang disukai
class CustomerFavoritesScreen extends StatefulWidget {
  const CustomerFavoritesScreen({super.key});

  @override
  State<CustomerFavoritesScreen> createState() =>
      _CustomerFavoritesScreenState();
}

class _CustomerFavoritesScreenState extends State<CustomerFavoritesScreen> {
  String? _selectedSortBy;
  final List<String> _sortOptions = [
    'Terbaru',
    'Rating Tertinggi',
    'Rating Terendah',
    'Nama (A-Z)',
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    Future.delayed(Duration.zero, () {
      final provider = context.read<CustomerProvider>();
      // TODO: Fetch favorites with token
      // provider.fetchFavorites(token: 'YOUR_TOKEN');
    });
  }

  List<dynamic> _getSortedFavorites(List<dynamic> favorites) {
    final sorted = List.from(favorites);

    switch (_selectedSortBy) {
      case 'Rating Tertinggi':
        sorted.sort((a, b) =>
            b.tongkronganRating.compareTo(a.tongkronganRating));
        break;
      case 'Rating Terendah':
        sorted.sort((a, b) =>
            a.tongkronganRating.compareTo(b.tongkronganRating));
        break;
      case 'Nama (A-Z)':
        sorted.sort((a, b) =>
            a.tongkronganName.compareTo(b.tongkronganName));
        break;
      case 'Terbaru':
      default:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return sorted;
  }

  void _removeFavorite(String favoriteId, String tongkronganId) {
    final provider = context.read<CustomerProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Favorit?'),
        content: const Text('Apakah Anda yakin ingin menghapus dari favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              provider.removeFromFavorites(
                tongkronganId,
                token: 'YOUR_TOKEN_HERE', // TODO: Get from auth provider
              );
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        centerTitle: true,
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, _) {
          final favorites = _getSortedFavorites(provider.favorites);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Sort
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${favorites.length} Favorit',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<String>(
                        value: _selectedSortBy,
                        hint: const Text('Urutkan'),
                        items: _sortOptions.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedSortBy = value);
                        },
                      ),
                    ],
                  ),
                ),
                // Loading State
                if (provider.isLoadingFavorites)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) => const SkeletonCard(),
                    ),
                  ),
                // Error State
                if (provider.favoriteError != null)
                  Padding(
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
                            provider.favoriteError ?? 'Unknown error',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _loadFavorites,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Empty State
                if (favorites.isEmpty &&
                    !provider.isLoadingFavorites &&
                    provider.favoriteError == null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada favorit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tambahkan tongkrongan ke favorit untuk menyimpan pilihan terbaik Anda',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.explore),
                            label: const Text('Jelajahi Tongkrongan'),
                            onPressed: () {
                              // TODO: Navigate to home
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                // Favorites Grid
                if (favorites.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final favorite = favorites[index];
                        // TODO: Convert favorite to tongkrongan model
                        // For now, showing favorite info directly
                        return _FavoriteCard(
                          favorite: favorite,
                          onRemove: () => _removeFavorite(
                            favorite.id,
                            favorite.tongkronganId,
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Favorite Card Widget
class _FavoriteCard extends StatelessWidget {
  final dynamic favorite;
  final VoidCallback onRemove;

  const _FavoriteCard({
    required this.favorite,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to detail
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Remove Button
            Stack(
              children: [
                // Main Image
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(favorite.tongkronganImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Remove Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    favorite.tongkronganName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        favorite.tongkronganRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Save Date
                  Text(
                    'Ditambahkan ${_formatDate(favorite.createdAt)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'hari ini';
    } else if (difference.inDays == 1) {
      return 'kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} minggu lalu';
    } else {
      return '${(difference.inDays / 30).floor()} bulan lalu';
    }
  }
}
