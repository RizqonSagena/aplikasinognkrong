# 🚀 Customer Features - Quick Start Guide

## ✅ Setup & Installation

### 1. Install Dependencies
```bash
flutter pub get
dart run build_runner build
```

### 2. Run Application
```bash
flutter run
```

### 3. Select Mode
Saat app launch, pilih **"Mode Customer"** di role selection screen.

---

## 📱 Screens Overview

### 🏠 Home Screen (Beranda)
- Daftar tongkrongan dalam grid 2 kolom
- Search bar untuk mencari
- Filter kategori
- Tap card untuk lihat detail

**Quick Actions:**
```
Icon Top-Right:
- ❤️ Favorite → Go to Favorites
- 👤 Profile → Go to Profile
```

### 🔍 Search Screen (Cari)
- Advanced filter dengan:
  - Kota
  - Kategori
  - Rentang Harga
  - Rating (slider)
  - Jarak (slider)
  - Amenities
  - Status (buka/tutup)
- Sort options: Terbaru, Rating, Nama

### ❤️ Favorites Screen (Favorit)
- Lihat semua tongkrongan yang difavoritkan
- Sort by: Terbaru, Rating Tertinggi/Terendah, Nama
- Remove dengan click ❌

### 👤 Profile Screen (Profil)
- View profile info
- Edit profile dengan click ✏️
- Lihat bookmark history
- View my bookings

---

## 💾 Key Data Models

### Tongkrongan
```
id, name, description, address, city
imageUrl, rating, reviewCount, category
amenities, openingTime, closingTime, isOpen
capacity, priceRange, distance, latitude, longitude
```

### Booking
```
id, tongkronganId, userId, bookingDate, bookingTime
numberOfPeople, status (pending/confirmed/completed/cancelled)
notes, totalPrice
```

### Review
```
id, tongkronganId, userId, userName, rating (1-5)
title, comment, imageUrls[], likes
```

### Favorite
```
id, userId, tongkronganId, tongkronganName, tongkronganImage
tongkronganRating, createdAt
```

---

## 🔗 Navigation Shortcuts

### From Home Screen
```
Home (Grid) → Tap Card → Detail Screen
            → Profile Icon → Profile Screen
            → Favorite Icon → Favorites Screen
            → Search Icon → Search Screen
```

### From Detail Screen
```
Detail → Booking Button → Booking Form → Submit → Back
      → Review Section → Read Reviews
      → Gallery Tab → View Photos
      → Info Tab → Operating Hours, Address, Capacity
```

### From Search Screen
```
Search → Apply Filters → View Results → Tap Card → Detail
      → Sort by → Reorder Results
```

### Bottom Navigation
```
🏠 Beranda    🔍 Cari    ❤️ Favorit    👤 Profil
```

---

## 🎯 Common Tasks

### 1. Search Tongkrongan
```
1. Go to Search (🔍)
2. Type keyword in search box
3. Click Search button
4. Or use Filters for advanced search
```

### 2. Make a Booking
```
1. Find tongkrongan (Home or Search)
2. Click on card → Detail Screen
3. Click "Booking" button
4. Select Date, Time, Number of People
5. Add notes (optional)
6. Click "Konfirmasi Booking"
```

### 3. Add to Favorites
```
1. Open tongkrongan detail
2. Click ❤️ button (top right)
3. Or use favorite button on card
```

### 4. View Bookings
```
1. Go to Profile (👤)
2. Click "Booking" tab
3. View all bookings with status
4. Filter by status if needed
```

### 5. Edit Profile
```
1. Go to Profile (👤)
2. Click ✏️ edit button (top right)
3. Update fields: Name, Phone, Bio, Address, City
4. Click "Simpan" to save
```

---

## 🔧 Configuration

### API Base URL
Edit di `lib/services/customer_api_service.dart`:
```dart
static const String _baseUrl = 'https://api.nongkrong.local/v1';
```

### Authentication Token
Semua API calls memerlukan token. Saat ini hardcoded sebagai:
```dart
token: 'YOUR_TOKEN_HERE'
```

**TODO:** Integrate dengan auth provider untuk get token from SharedPreferences atau Secure Storage.

---

## 📊 State Management Flow

```
UI Widget (Consumer<CustomerProvider>)
    ↓ onPressed() → provider.fetchTongkrongan()
CustomerProvider (ChangeNotifier)
    ↓ setState() → listener updated
CustomerApiService
    ↓ HTTP GET request
Backend API
    ↓ Response JSON
Tongkrongan Model (fromJson)
    ↓ Store in provider._tongkronganList
UI rebuilt with new data
```

---

## 🐛 Troubleshooting

### Issue: "Unauthorized - Please login again"
**Solution:** Token kadaluarsa atau tidak valid. Perlu integrate dengan auth system.

### Issue: "Error: Failed to load image"
**Solution:** Image URL tidak accessible. Pastikan URL valid dan CORS enabled.

### Issue: "Could not connect to API"
**Solution:** Periksa base URL dan pastikan API server running.

### Issue: Favorites tidak tersimpan
**Solution:** Fitur favorites belum terintegrasi dengan database. Semua favorites hanya lokal di provider.

---

## 📚 File Structure

```
lib/
├── main.dart                      # Entry point dengan navigation
├── config/
│   └── app_config.dart           # App configuration
├── models/
│   ├── tongkrongan.dart
│   ├── review.dart
│   ├── booking.dart
│   ├── favorite.dart
│   ├── customer_user.dart
│   └── api_response.dart
├── services/
│   ├── customer_api_service.dart  # API client
│   ├── customer_provider.dart     # State management
│   └── stitch_chat_provider.dart  # (untuk chat mode)
├── screens/
│   ├── customer_home_screen.dart
│   ├── customer_detail_screen.dart
│   ├── customer_search_screen.dart
│   ├── customer_booking_screen.dart
│   ├── customer_profile_screen.dart
│   ├── customer_favorites_screen.dart
│   └── chat_screen.dart           # (untuk chat mode)
└── widgets/
    ├── tongkrongan_card.dart
    ├── category_filter.dart
    ├── loading_shimmer.dart
    └── message_bubble.dart        # (untuk chat mode)
```

---

## 🎨 UI Components Used

- **Material 3 Design** - Modern, responsive UI
- **Bottom Navigation** - Easy navigation between main screens
- **Sliver Layout** - Efficient scrolling for detail screen
- **Tabs** - Organize content in detail view
- **Chips** - Filter selection
- **Cards** - Content containers
- **Dialogs** - Confirmations & pickers
- **Form Fields** - Data input

---

## ⚡ Performance Tips

1. **Use Provider.select()** untuk optimize rebuilds
2. **Lazy load images** dengan NetworkImage
3. **Pagination** di list untuk reduce initial load
4. **Cache API responses** dengan local storage
5. **Avoid rebuilding entire screen** - use Consumer strategically

---

## 🔐 Security Considerations

1. **Never hardcode tokens** - Get from secure storage
2. **HTTPS only** untuk API calls
3. **Validate user input** sebelum submit
4. **Rate limiting** untuk API calls
5. **Secure image URLs** - tidak store sensitive data di images
6. **Clear cache** saat logout

---

## 📈 Next Steps

1. **Integration Checklist:**
   - [ ] Connect dengan backend API
   - [ ] Implement authentication
   - [ ] Setup database for favorites
   - [ ] Add image upload feature
   - [ ] Implement payment system
   - [ ] Add push notifications

2. **Testing:**
   - [ ] Unit tests untuk models
   - [ ] Widget tests untuk UI
   - [ ] Integration tests untuk API calls

3. **Deployment:**
   - [ ] Build APK untuk Android
   - [ ] Build IPA untuk iOS
   - [ ] Setup CI/CD pipeline
   - [ ] Monitor crash & errors

---

## 💡 Quick Reference

### Get Provider
```dart
final provider = context.read<CustomerProvider>();
```

### Watch Provider (rebuild on change)
```dart
Consumer<CustomerProvider>(
  builder: (context, provider, _) {
    return Text(provider.tongkronganList.length.toString());
  }
)
```

### Access Data
```dart
provider.tongkronganList        // List<Tongkrongan>
provider.selectedTongkrongan   // Tongkrongan?
provider.reviews               // List<Review>
provider.bookings              // List<Booking>
provider.favorites             // List<Favorite>
provider.currentUser           // CustomerUser?
```

### Check Loading State
```dart
if (provider.isLoadingTongkrongan) {
  // Show loading indicator
}
```

### Check Error State
```dart
if (provider.tongkronganError != null) {
  // Show error message
}
```

---

## 🆘 Getting Help

1. Check **CUSTOMER_FEATURES.md** untuk detailed documentation
2. Review API examples di **API_EXAMPLES.md**
3. Check class implementations di source code
4. Debug dengan print statements atau debugger

---

## 📝 Notes

- Semua timestamps dalam format ISO 8601
- Rating adalah double 0.0 - 5.0
- Jarak dalam kilometer
- Harga range: "$", "$$", "$$$", "$$$$"
- Status booking: pending, confirmed, completed, cancelled

---

**Happy Coding! 🎉**

Untuk questions atau issues, review code comments dan documentation files.
