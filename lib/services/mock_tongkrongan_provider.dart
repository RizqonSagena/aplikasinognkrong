import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tongkrongan.dart';

/// Mock data provider untuk demo - menggunakan Riverpod
/// Ini menggantikan API calls dengan data dummy

class MockTongkronganProvider {
  /// Generate mock tongkrongan data
  static List<Tongkrongan> getMockTongkrongan() {
    return [
      Tongkrongan(
        id: '1',
        name: 'Warung Kopi Tradisional',
        description: 'Kopi signature dengan resep turun temurun, nyaman dan sejuk',
        address: 'Jl. Sudirman No. 123, Jakarta Pusat',
        city: 'Jakarta',
        latitude: -6.2088,
        longitude: 106.8456,
        imageUrl: 'https://images.unsplash.com/photo-1495521821757-a1efb6729352?w=500&h=500&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1495521821757-a1efb6729352?w=500&h=500&fit=crop',
          'https://images.unsplash.com/photo-1442512595331-e89e6a0ac069?w=500&h=500&fit=crop',
        ],
        rating: 4.8,
        reviewCount: 234,
        category: 'Cafe&Pastry',
        amenities: ['WiFi', 'AC', 'Kursi Empuk', 'Parkir'],
        openingTime: '08:00',
        closingTime: '22:00',
        isOpen: true,
        capacity: 50,
        priceRange: '\$\$',
        distance: 0.5,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        updatedAt: DateTime.now(),
      ),
      Tongkrongan(
        id: '2',
        name: 'Kedai Soto Ayam Bu Rin',
        description: 'Soto ayam kental dengan rasa tradisional yang autentik',
        address: 'Jl. Gatot Subroto No. 45, Jakarta Selatan',
        city: 'Jakarta',
        latitude: -6.2167,
        longitude: 106.8200,
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&h=500&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&h=500&fit=crop',
        ],
        rating: 4.6,
        reviewCount: 189,
        category: 'Kedai',
        amenities: ['Takeaway', 'Parkir Luas', 'Bersih'],
        openingTime: '10:00',
        closingTime: '21:00',
        isOpen: true,
        capacity: 30,
        priceRange: '\$',
        distance: 1.2,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        updatedAt: DateTime.now(),
      ),
      Tongkrongan(
        id: '3',
        name: 'Toko Oleh-Oleh Nusantara',
        description: 'Lengkap dengan souvenir dan makanan khas daerah Indonesia',
        address: 'Jl. Rasuna Said No. 89, Jakarta Selatan',
        city: 'Jakarta',
        latitude: -6.2206,
        longitude: 106.8371,
        imageUrl: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=500&h=500&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=500&h=500&fit=crop',
        ],
        rating: 4.9,
        reviewCount: 312,
        category: 'Oleh-oleh',
        amenities: ['Parkir', 'AC', 'Kemasan Menarik'],
        openingTime: '08:00',
        closingTime: '20:00',
        isOpen: true,
        capacity: 100,
        priceRange: '\$\$',
        distance: 2.8,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
      ),
      Tongkrongan(
        id: '4',
        name: 'Spot Foto Instagram',
        description: 'Tempat viral dengan dekorasi aesthetic dan instagramable',
        address: 'Jl. Bawah Tangki No. 23, Jakarta Utara',
        city: 'Jakarta',
        latitude: -6.2142,
        longitude: 106.8298,
        imageUrl: 'https://images.unsplash.com/photo-1514432324607-2e467f4af3e9?w=500&h=500&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1514432324607-2e467f4af3e9?w=500&h=500&fit=crop',
          'https://images.unsplash.com/photo-1521305573892-20b6849fad33?w=500&h=500&fit=crop',
        ],
        rating: 4.5,
        reviewCount: 156,
        category: 'Tempat Viral',
        amenities: ['WiFi', 'Photo Spot', 'AC'],
        openingTime: '11:00',
        closingTime: '23:00',
        isOpen: true,
        capacity: 80,
        priceRange: '\$\$\$',
        distance: 0.8,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
      ),
      Tongkrongan(
        id: '5',
        name: 'Cafe Pastry Sederhana',
        description: 'Pastry fresh setiap hari dengan kopi specialty',
        address: 'Jl. H. Agus Salim No. 12, Jakarta Pusat',
        city: 'Jakarta',
        latitude: -6.1905,
        longitude: 106.8106,
        imageUrl: 'https://images.unsplash.com/photo-1568291473672-0e0aadb0bece?w=500&h=500&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1568291473672-0e0aadb0bece?w=500&h=500&fit=crop',
        ],
        rating: 4.4,
        reviewCount: 145,
        category: 'Cafe&Pastry',
        amenities: ['WiFi', 'Outlet', 'Nyaman'],
        openingTime: '08:00',
        closingTime: '20:00',
        isOpen: true,
        capacity: 25,
        priceRange: '\$\$\$',
        distance: 0.3,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now(),
      ),
      Tongkrongan(
        id: '6',
        name: 'Kedai Makan Jaya',
        description: 'Menu nusantara lengkap, layanan cepat dan ramah',
        address: 'Jl. Kemang Raya No. 67, Jakarta Selatan',
        city: 'Jakarta',
        latitude: -6.2656,
        longitude: 106.7897,
        imageUrl: 'https://images.unsplash.com/photo-1645267514905-7c8c06c6d5d5?w=500&h=500&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1645267514905-7c8c06c6d5d5?w=500&h=500&fit=crop',
        ],
        rating: 4.9,
        reviewCount: 298,
        category: 'Kedai',
        amenities: ['Parkir Luas', 'AC', 'Menu Halal'],
        openingTime: '07:00',
        closingTime: '21:00',
        isOpen: true,
        capacity: 40,
        priceRange: '\$\$',
        distance: 2.5,
        createdAt: DateTime.now().subtract(const Duration(days: 75)),
        updatedAt: DateTime.now(),
      ),
      Tongkrongan(
        id: '7',
        name: 'Oleh-oleh Batik & Kerajinan',
        description: 'Batik asli dan kerajinan tangan berkualitas tinggi',
        address: 'Jl. Tebet Raya No. 34, Jakarta Selatan',
        city: 'Jakarta',
        latitude: -6.2418,
        longitude: 106.8395,
        imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=500&h=500&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=500&h=500&fit=crop',
        ],
        rating: 4.3,
        reviewCount: 98,
        category: 'Oleh-oleh',
        amenities: ['Parkir', 'AC', 'Garansi Keaslian'],
        openingTime: '08:00',
        closingTime: '18:00',
        isOpen: true,
        capacity: 30,
        priceRange: '\$\$\$',
        distance: 1.5,
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        updatedAt: DateTime.now(),
      ),
      Tongkrongan(
        id: '8',
        name: 'Tempat Makan Ramah Lingkungan',
        description: 'Konsep eco-friendly dengan suasana alam yang tenang',
        address: 'Jl. Pengangsaan Timur No. 5, Jakarta Pusat',
        city: 'Jakarta',
        latitude: -6.1950,
        longitude: 106.8250,
        imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=500&h=500&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=500&h=500&fit=crop',
        ],
        rating: 4.7,
        reviewCount: 267,
        category: 'Tempat Viral',
        amenities: ['Garden', 'WiFi', 'Photo Spot'],
        openingTime: '09:00',
        closingTime: '22:00',
        isOpen: true,
        capacity: 100,
        priceRange: '\$\$\$',
        distance: 3.2,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Get mock tongkrongan by category
  static List<Tongkrongan> getMockTongkronganByCategory(String category) {
    if (category == 'Semua') {
      return getMockTongkrongan();
    }
    return getMockTongkrongan()
        .where((t) => t.category == category)
        .toList();
  }

  /// Search mock tongkrongan
  static List<Tongkrongan> searchMockTongkrongan(String query) {
    final lowerQuery = query.toLowerCase();
    return getMockTongkrongan()
        .where((t) =>
            t.name.toLowerCase().contains(lowerQuery) ||
            t.description.toLowerCase().contains(lowerQuery) ||
            t.address.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

/// Riverpod provider untuk mock tongkrongan list
final mockTongkronganProvider =
    StateProvider<List<Tongkrongan>>((ref) {
  return MockTongkronganProvider.getMockTongkrongan();
});

/// Riverpod provider untuk selected category
final mockCategoryProvider = StateProvider<String>((ref) {
  return 'Semua';
});

/// Riverpod provider untuk filtered tongkrongan berdasarkan category
final filteredMockTongkronganProvider = StateProvider<List<Tongkrongan>>((ref) {
  final category = ref.watch(mockCategoryProvider);
  if (category == 'Semua') {
    return MockTongkronganProvider.getMockTongkrongan();
  }
  return MockTongkronganProvider.getMockTongkronganByCategory(category);
});
