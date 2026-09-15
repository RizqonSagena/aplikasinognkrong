# 📱 Customer Features Guide

## 🎯 Overview

Fitur Customer Role adalah modul lengkap untuk aplikasi Nongkrong yang memungkinkan pengguna untuk menemukan, melihat detail, melakukan booking, dan mengelola tongkrongan (hangout spots) favorit mereka.

---

## 🏗️ Arsitektur

### Folder Structure

```
lib/
├── models/
│   ├── tongkrongan.dart          # Model untuk tongkrongan
│   ├── review.dart               # Model untuk review
│   ├── booking.dart              # Model untuk booking
│   ├── favorite.dart             # Model untuk favorite
│   ├── customer_user.dart        # Model untuk user
│   └── api_response.dart         # Generic API response model
│
├── services/
│   ├── customer_api_service.dart # HTTP client untuk API calls
│   └── customer_provider.dart    # State management dengan Provider
│
├── screens/
│   ├── customer_home_screen.dart      # Halaman utama dengan daftar tongkrongan
│   ├── customer_detail_screen.dart    # Detail tongkrongan
│   ├── customer_search_screen.dart    # Search & Filter
│   ├── customer_booking_screen.dart   # Form booking
│   ├── customer_profile_screen.dart   # User profile
│   └── customer_favorites_screen.dart # Wishlist
│
└── widgets/
    ├── tongkrongan_card.dart     # Reusable card untuk tongkrongan
    ├── category_filter.dart      # Category filter chips
    └── loading_shimmer.dart      # Loading skeleton
```

### Design Pattern

- **MVC (Model-View-Controller)**: Pemisahan yang jelas antara data (models), logika (services), dan UI (screens)
- **Provider Pattern**: State management dengan ChangeNotifier untuk reactive UI updates
- **Repository Pattern**: CustomerApiService sebagai single point untuk semua API calls
- **Singleton**: CustomerProvider diprovide globally melalui MultiProvider

---

## 📊 Models

### Tongkrongan Model

```dart
Tongkrongan {
  String id,                      // Unique identifier
  String name,                    // Nama tongkrongan
  String description,             // Deskripsi
  String address,                 // Alamat lengkap
  String city,                    // Kota
  double latitude,                // Koordinat
  double longitude,
  String imageUrl,                // Main image
  List<String> imageUrls,         // Gallery images
  double rating,                  // Rating 1-5
  int reviewCount,                // Jumlah review
  String category,                // coffee, food, bar, dll
  List<String> amenities,         // wifi, parking, ac, dll
  String openingTime,             // "09:00"
  String closingTime,             // "22:00"
  bool isOpen,                    // Status saat ini
  int capacity,                   // Kapasitas orang
  String priceRange,              // "$", "$$", "$$$"
  double distance,                // Jarak dalam km
  DateTime createdAt,
  DateTime updatedAt,
}
```

### Review Model

```dart
Review {
  String id,
  String tongkronganId,
  String userId,
  String userName,
  String userAvatar,
  double rating,                  // 1-5
  String title,
  String comment,
  List<String> imageUrls,         // Foto review
  int likes,
  bool isLikedByUser,
  DateTime createdAt,
  DateTime updatedAt,
}
```

### Booking Model

```dart
Booking {
  String id,
  String userId,
  String tongkronganId,
  String tongkronganName,
  DateTime bookingDate,
  String bookingTime,             // "14:00"
  int numberOfPeople,
  String notes,
  String status,                  // pending, confirmed, completed, cancelled
  double totalPrice,
  DateTime createdAt,
  DateTime updatedAt,
}
```

### Favorite Model

```dart
Favorite {
  String id,
  String userId,
  String tongkronganId,
  String tongkronganName,
  String tongkronganImage,
  double tongkronganRating,
  DateTime createdAt,
}
```

### CustomerUser Model

```dart
CustomerUser {
  String id,
  String email,
  String name,
  String phone,
  String avatar,
  String bio,
  String address,
  String city,
  double latitude,
  double longitude,
  int totalBookings,
  int totalReviews,
  double averageRating,
  List<String> favoriteIds,       // List tongkrongan IDs yang favorit
  DateTime createdAt,
  DateTime updatedAt,
}
```

---

## 🔧 Services

### CustomerApiService

HTTP client untuk semua API calls. Menyediakan methods untuk:

**Tongkrongan Endpoints:**
```dart
getTongkrongan({page, pageSize, city, category, query})
getTongkronganDetail(id)
searchTongkrongan(query)
```

**Review Endpoints:**
```dart
getReviews(tongkronganId, {page})
createReview(tongkronganId, {rating, title, comment, token, imageUrls})
```

**Booking Endpoints:**
```dart
getMyBookings({token, status})
getBookingDetail(bookingId, {token})
createBooking({tongkronganId, bookingDate, bookingTime, numberOfPeople, token, notes})
cancelBooking(bookingId, {token, reason})
```

**Favorite Endpoints:**
```dart
getFavorites({token})
addToFavorites(tongkronganId, {token})
removeFromFavorites(tongkronganId, {token})
```

**User Endpoints:**
```dart
getUserProfile({token})
updateUserProfile({token, name, phone, bio, address, city, avatar})
```

### CustomerProvider

State management untuk customer features dengan ChangeNotifier.

**Getters:**
- `tongkronganList` - Daftar tongkrongan
- `selectedTongkrongan` - Tongkrongan yang dipilih
- `reviews` - Daftar review
- `bookings` - Daftar booking user
- `favorites` - Daftar favorit
- `currentUser` - User profile saat ini
- `isFavorite(id)` - Check apakah tongkrongan adalah favorit

**Methods:**
- `fetchTongkrongan()` - Load daftar tongkrongan
- `getTongkronganDetail(id)` - Load detail tongkrongan
- `searchTongkrongan(query)` - Search tongkrongan
- `fetchReviews(tongkronganId)` - Load review
- `createReview()` - Buat review baru
- `fetchMyBookings()` - Load booking user
- `createBooking()` - Buat booking baru
- `cancelBooking()` - Batalkan booking
- `fetchFavorites()` - Load favorit
- `addToFavorites()` - Tambah ke favorit
- `removeFromFavorites()` - Hapus dari favorit
- `fetchUserProfile()` - Load profile user
- `updateUserProfile()` - Update profile user

---

## 📱 Screens

### 1. CustomerHomeScreen (Beranda)
Halaman utama yang menampilkan daftar tongkrongan.

**Features:**
- Grid layout dengan 2 kolom
- Search bar untuk mencari tongkrongan
- Filter kategori dengan chips
- Loading skeleton saat loading
- Empty state
- Error handling dengan retry button
- Infinite scroll dengan load more

**Navigation:**
- Tap card → DetailScreen
- Favorite button → Toggle favorite (TODO: integrate with auth)
- Profile icon → ProfileScreen
- Favorite icon → FavoritesScreen

### 2. CustomerDetailScreen (Detail Tongkrongan)
Menampilkan detail lengkap tongkrongan.

**Features:**
- Image carousel dengan indicators
- Status badge (Buka/Tutup)
- Favorite button
- Rating & review count
- Info cards (jam operasional, lokasi, kapasitas)
- Deskripsi lengkap
- Fasilitas chips
- Alamat
- Tab navigation untuk:
  - Review: Daftar review dari user lain
  - Gallery: Grid foto tongkrongan
  - Info: Informasi operasional, harga, kapasitas
- Bottom action buttons: Hubungi & Booking

### 3. CustomerSearchScreen (Cari & Filter)
Halaman untuk mencari dan filter tongkrongan dengan criteria advanced.

**Features:**
- Search bar
- Filter panel dengan:
  - Kota (chips)
  - Kategori (chips)
  - Rentang harga (chips)
  - Rating minimal (slider)
  - Jarak maksimal (slider)
  - Status (hanya buka)
  - Fasilitas (chips)
- Sort options
- Grid hasil dengan infinite scroll
- Empty state & error handling

### 4. CustomerBookingScreen (Booking)
Form untuk membuat reservasi.

**Features:**
- Tongkrongan info card
- Date picker
- Time picker
- Number picker untuk jumlah orang
- Notes field (optional)
- Operasional info box
- Validation sebelum submit
- Loading state saat submit

### 5. CustomerProfileScreen (Profil User)
Halaman untuk melihat & edit profil user.

**Features:**
- Avatar dengan status badge
- User info (nama, email)
- Stats (total booking, review, rating)
- Tab navigation:
  - About: Informasi personal
  - Booking: Daftar booking user
- Edit mode dengan form fields
- Save & cancel buttons

### 6. CustomerFavoritesScreen (Favorit)
Halaman untuk melihat wishlist.

**Features:**
- Sort options (terbaru, rating tertinggi/terendah, nama A-Z)
- Grid layout favorites
- Remove button pada setiap card
- Empty state dengan action button
- Loading & error states

---

## 🎨 Widgets

### TongkronganCard
Reusable card untuk menampilkan tongkrongan dalam grid/list.

```dart
TongkronganCard(
  tongkrongan: tongkrongan,
  onTap: () {},
  onFavoriteTap: () {},
  isFavorite: false,
)
```

**Features:**
- Image with skeleton loading
- Status badge
- Favorite button
- Category chip
- Distance
- Rating & review count
- Price range
- Address

### CategoryFilter
Filter chips untuk kategori.

```dart
CategoryFilter(
  categories: ['Coffee', 'Food', ...],
  selectedCategory: 'Coffee',
  onCategoryChanged: (category) {},
)
```

### LoadingShimmer & SkeletonCard
Loading placeholder dengan shimmer animation.

```dart
SkeletonCard() // Standalone skeleton
LoadingShimmer(child: container) // Wrapper untuk any widget
```

---

## 🔄 Navigation Flow

```
RoleSelectionScreen
├── Customer Mode → CustomerMainScreen
│   ├── BottomNav Index 0 → CustomerHomeScreen
│   │   ├── Tap Card → CustomerDetailScreen
│   │   │   ├── Booking Button → CustomerBookingScreen
│   │   │   ├── Review Section
│   │   │   └── Gallery Section
│   │   ├── Profile Button → CustomerProfileScreen
│   │   └── Favorite Button → CustomerFavoritesScreen
│   │
│   ├── BottomNav Index 1 → CustomerSearchScreen
│   │   ├── Tap Card → CustomerDetailScreen
│   │   └── Filter & Sort
│   │
│   ├── BottomNav Index 2 → CustomerFavoritesScreen
│   │   ├── Tap Card → CustomerDetailScreen
│   │   └── Remove from Favorites
│   │
│   └── BottomNav Index 3 → CustomerProfileScreen
│       ├── View Profile & Stats
│       ├── Edit Profile
│       └── View My Bookings
│
└── Chat Mode → ChatScreen (Stitch AI)
```

---

## 🔌 API Integration

### Base URL
Ganti di `customer_api_service.dart`:
```dart
static const String _baseUrl = 'https://api.nongkrong.local/v1';
```

### Authentication
Semua API calls yang memerlukan authentication menggunakan Bearer token:
```dart
Authorization: Bearer {token}
```

**TODO:** Integrate dengan auth provider untuk mendapatkan token.

### Response Format
Semua endpoints mengembalikan format:
```json
{
  "success": true,
  "message": "Success message",
  "data": { ... }
}
```

---

## 📋 Usage Examples

### Fetch Tongkrongan List

```dart
final provider = context.read<CustomerProvider>();
await provider.fetchTongkrongan(
  page: 1,
  pageSize: 20,
  city: 'Jakarta',
  category: 'Coffee',
);

// Access data
final list = provider.tongkronganList;
final isLoading = provider.isLoadingTongkrongan;
final error = provider.tongkronganError;
```

### Search Tongkrongan

```dart
await provider.searchTongkrongan('Kopi Enak');
```

### Create Booking

```dart
await provider.createBooking(
  tongkronganId: '123',
  bookingDate: DateTime.now().add(Duration(days: 1)),
  bookingTime: '14:00',
  numberOfPeople: 3,
  token: 'YOUR_AUTH_TOKEN',
  notes: 'Preferensi window seat',
);
```

### Manage Favorites

```dart
// Add to favorites
await provider.addToFavorites(
  '123',
  token: 'YOUR_AUTH_TOKEN',
);

// Check if favorite
bool isFav = provider.isFavorite('123');

// Remove from favorites
await provider.removeFromFavorites(
  '123',
  token: 'YOUR_AUTH_TOKEN',
);
```

### Update User Profile

```dart
await provider.updateUserProfile(
  token: 'YOUR_AUTH_TOKEN',
  name: 'John Doe',
  phone: '08123456789',
  bio: 'Coffee lover',
  city: 'Jakarta',
);
```

---

## 🎯 TODO & Enhancement Ideas

### High Priority
- [ ] Integrate dengan authentication system
- [ ] Implement image upload untuk avatar & booking notes
- [ ] Add location-based features (map integration)
- [ ] Implement real-time booking status updates
- [ ] Add payment integration
- [ ] Database persistence (local cache)

### Medium Priority
- [ ] Add push notifications untuk booking status
- [ ] Implement review photos upload
- [ ] Add rating filter UI
- [ ] Booking cancellation policies
- [ ] Review moderation features
- [ ] User reviews history

### Low Priority
- [ ] Social features (follow, share)
- [ ] Recommendation algorithm
- [ ] Advanced analytics
- [ ] Multi-language support
- [ ] Accessibility improvements
- [ ] Performance optimization

---

## 🧪 Testing Checklist

### Manual Testing
- [ ] App launches to role selection
- [ ] Customer mode navigates to home
- [ ] Tongkrongan list loads
- [ ] Search functionality works
- [ ] Filter options apply correctly
- [ ] Detail screen opens and loads reviews
- [ ] Image carousel works
- [ ] Favorite toggle works locally
- [ ] Booking form validates input
- [ ] Profile edit form works
- [ ] Favorites list displays and sorts
- [ ] Navigation between tabs works
- [ ] Back button behavior correct
- [ ] Loading states show properly
- [ ] Error states show with retry

### Edge Cases
- [ ] Empty list scenarios
- [ ] Network error handling
- [ ] Very long text truncation
- [ ] Large image handling
- [ ] Fast navigation between screens
- [ ] Multiple quick API calls

---

## 📚 Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  http: ^1.1.0              # HTTP client
  provider: ^6.1.1          # State management
  flutter_dotenv: ^5.1.0    # Environment variables
  json_annotation: ^4.8.1   # JSON serialization
  cupertino_icons: ^1.0.2   # Icons

dev_dependencies:
  build_runner: ^2.4.6      # Code generation
  json_serializable: ^6.7.1 # JSON code generator
```

---

## 📞 Support & Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [HTTP Package](https://pub.dev/packages/http)
- [Material 3 Design](https://m3.material.io/)

---

## 📝 Notes

- Semua API calls menggunakan timeout 30 detik
- Images di-fetch dari URL (pastikan URL accessible)
- Date formatting menggunakan DateTime.parse()
- Rating adalah double dengan range 0-5
- Token harus diintegrasikan dari auth provider
- Local favorites check tidak memerlukan API call

---

**Last Updated:** September 15, 2026  
**Version:** 1.0.0  
**Status:** Complete & Ready for Integration
