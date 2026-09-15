import 'package:flutter/material.dart';
import '../services/mock_tongkrongan_provider.dart';
import '../models/tongkrongan.dart';
import '../widgets/tongkrongan_card.dart';
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

  // Mock favorited items (IDs of favorited tongkrongan)
  final List<String> _favoritedIds = ['1', '3', '5', '8'];

  List<Tongkrongan> _getFavoritedTongkrongan() {
    final allTongkrongan = MockTongkronganProvider.getMockTongkrongan();
    return allTongkrongan.where((t) => _favoritedIds.contains(t.id)).toList();
  }

  List<Tongkrongan> _getSortedFavorites(List<Tongkrongan> favorites) {
    final sorted = List<Tongkrongan>.from(favorites);

    switch (_selectedSortBy) {
      case 'Rating Tertinggi':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Rating Terendah':
        sorted.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case 'Nama (A-Z)':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Terbaru':
      default:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return sorted;
  }

  void _toggleFavorite(String tongkronganId) {
    setState(() {
      if (_favoritedIds.contains(tongkronganId)) {
        _favoritedIds.remove(tongkronganId);
      } else {
        _favoritedIds.add(tongkronganId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _getSortedFavorites(_getFavoritedTongkrongan());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
            // Empty State
            if (favorites.isEmpty)
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final tongkrongan = favorites[index];
                    return TongkronganCard(
                      tongkrongan: tongkrongan,
                      isFavorite: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CustomerDetailScreen(tongkrongan: tongkrongan),
                          ),
                        );
                      },
                      onFavoriteTap: () => _toggleFavorite(tongkrongan.id),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
