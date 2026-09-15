# Owner/Tenant Dashboard - Tongkrongan Mitra Shell

Dokumentasi lengkap untuk dashboard Owner/Tenant yang telah dibuat untuk aplikasi Tongkrongan Mitra Shell.

## 📋 Daftar Isi
- [Fitur Utama](#fitur-utama)
- [Struktur File](#struktur-file)
- [Model Data](#model-data)
- [Services](#services)
- [Screens](#screens)
- [Navigasi](#navigasi)
- [Integrasi API](#integrasi-api)

---

## ✨ Fitur Utama

### 1. **Dashboard Utama** (`owner_home_screen.dart`)
Dashboard yang menampilkan overview lengkap bisnis owner dengan fitur:
- **Welcome Section**: Greeting dan quick stats (revenue bulan ini, booking, rating)
- **Key Metrics**: Grid menampilkan total revenue, total booking, venue aktif, dan rating rata-rata
- **Status Reservasi**: Card pendek menampilkan jumlah pending dan confirmed reservations
- **Recent Reservations**: Preview 3 reservasi terbaru dengan status
- **Venue Overview**: Preview 3 venue utama dengan rating dan status

**Navigasi Tab:**
- Dashboard (default)
- Venue (Manage Tongkrongan)
- Reservasi
- Analitik
- Profil

### 2. **Manage Tongkrongan** (`owner_manage_tongkrongan_screen.dart`)
Screen untuk mengelola seluruh venue milik owner:
- **Filter Status**: Semua, Aktif, Tidak Aktif, Pending
- **Venue Cards**: Menampilkan:
  - Foto venue
  - Nama, kota, rating, review count
  - Stats: monthly bookings, revenue, kapasitas
  - Action buttons: Edit, Analitik
- **Detail Modal**: Bottom sheet untuk melihat detail lengkap venue
  - Informasi dasar (alamat, phone, jam operasional, kapasitas)
  - Performance metrics (rating, reviews, bookings, revenue)
  - Deskripsi venue
- **FAB**: Tombol tambah venue baru (placeholder untuk fitur mendatang)

### 3. **Reservations Management** (`owner_reservations_screen.dart`)
Screen untuk mengelola semua reservasi dengan fitur:
- **Tab Navigation**:
  - Semua reservasi
  - Pending
  - Confirmed
  - Selesai

- **Reservation Cards**: Menampilkan:
  - Nama customer
  - Venue name
  - Jumlah orang, tanggal, jam
  - Total harga
  - Status badge dengan warna berbeda
  - Action buttons untuk approve/reject (jika pending)

- **Detail Modal**: Menampilkan informasi lengkap:
  - Reservasi details (ID, tanggal, jam, orang, status)
  - Customer info (nama, email, phone)
  - Venue info
  - Special requests
  - Total harga
  - Action buttons untuk approve/reject

### 4. **Analytics Dashboard** (`owner_analytics_screen.dart`)
Dashboard analytics untuk menganalisis performa bisnis:
- **Period Selector**: Filter 7 hari, 30 hari, 90 hari, 1 tahun
- **Revenue Section**:
  - Total revenue card
  - Monthly revenue card
  - Revenue chart (6 bulan terakhir)
  
- **Booking Trends**:
  - Total booking
  - Monthly booking
  - Pending reservations
  - Confirmed reservations
  - Booking trends chart (30 hari)

- **Performance Metrics**:
  - Average rating
  - Total reviews
  - Active venues

- **Top Reviews**:
  - List 5 review terbaru
  - Rating stars
  - Customer comment

### 5. **Owner Profile** (`owner_profile_screen.dart`)
Screen untuk profile dan settings owner:
- **Profile Header**: Avatar, nama, owner ID
- **Profile Information** (View Mode):
  - Nama pemilik
  - Nama bisnis
  - Email
  - No. Telepon
  - Bergabung sejak
  - Status

- **Edit Mode**:
  - Edit semua field profile
  - Save/Cancel buttons

- **Settings**:
  - Notifikasi: Manage notification preferences
  - Keamanan: Change password
  - Metode Pembayaran: Manage bank accounts
  - Bantuan & Dukungan: Contact info
  - Logout: Keluar dari akun

---

## 📁 Struktur File

```
lib/
├── models/
│   ├── owner_tongkrongan.dart         # Model untuk venue dari perspektif owner
│   ├── owner_tongkrongan.g.dart       # JSON serialization (generated)
│   ├── owner_reservation.dart         # Model untuk reservasi
│   ├── owner_reservation.g.dart       # JSON serialization (generated)
│   ├── owner_stats.dart               # Model untuk statistik owner
│   └── owner_stats.g.dart             # JSON serialization (generated)
│
├── services/
│   ├── owner_api_service.dart         # API calls untuk owner
│   └── owner_provider.dart            # State management (Provider)
│
├── screens/
│   ├── owner_home_screen.dart         # Dashboard utama
│   ├── owner_manage_tongkrongan_screen.dart    # Manage venues
│   ├── owner_reservations_screen.dart # Manage reservasi
│   ├── owner_analytics_screen.dart    # Analytics
│   └── owner_profile_screen.dart      # Profile & settings
│
└── main.dart                          # Updated dengan Owner navigation
```

---

## 📊 Model Data

### OwnerTongkrongan
```dart
class OwnerTongkrongan {
  String id;
  String name;
  String description;
  String category;
  String city;
  double rating;
  int reviewCount;
  int totalBookings;
  int monthlyBookings;
  int activeReservations;
  String status;              // 'active', 'inactive', 'pending'
  String imageUrl;
  String address;
  String phone;
  String operatingHours;
  int capacity;
  double revenue;             // Monthly revenue
  DateTime createdAt;
  DateTime updatedAt;
}
```

### OwnerReservation
```dart
class OwnerReservation {
  String id;
  String tongkronganId;
  String tongkronganName;
  String customerName;
  String customerPhone;
  String customerEmail;
  int guestCount;
  DateTime reservationDate;
  String timeSlot;
  String specialRequest;
  String status;              // 'pending', 'confirmed', 'completed', 'cancelled'
  double totalPrice;
  DateTime createdAt;
  DateTime confirmedAt;
  DateTime completedAt;
}
```

### OwnerStats
```dart
class OwnerStats {
  double totalRevenue;
  double monthlyRevenue;
  int totalBookings;
  int monthlyBookings;
  int pendingReservations;
  int confirmedReservations;
  double averageRating;
  int totalReviews;
  int totalTongkrongan;
  int activeTongkrongan;
  DateTime lastUpdated;
}
```

---

## 🔌 Services

### OwnerApiService
Menangani semua API calls untuk owner dengan methods:

```dart
// Profile
getOwnerProfile(String token)

// Venue Management
getOwnerTongkrongan(String token, {int page, int limit})
getTongkronganDetail(String token, String tongkronganId)
updateTongkrongan(String token, String tongkronganId, Map data)

// Reservations
getReservations(String token, {int page, int limit, String status, String tongkronganId})
updateReservationStatus(String token, String reservationId, String status)

// Analytics
getStats(String token)
getRevenueChart(String token, {int months})
getBookingTrends(String token, {int days})

// Reviews
getReviews(String token, {int page, int limit, String tongkronganId})
```

### OwnerProvider
State management dengan ChangeNotifier:
- **Data Properties**: ownerProfile, tongkrongan, reservations, stats, reviews
- **Loading States**: isLoadingProfile, isLoadingTongkrongan, dll
- **Pagination**: hasMoreTongkrongan, hasMoreReservations, hasMoreReviews
- **Methods**:
  - `fetchOwnerProfile(token)`: Load profile
  - `fetchTongkrongan(token)`: Load venues dengan pagination
  - `fetchMoreTongkrongan(token)`: Load more venues
  - `fetchReservations(token)`: Load reservasi dengan filter
  - `updateReservationStatus(token, id, status)`: Update status
  - `fetchStats(token)`: Load statistik
  - `fetchReviews(token)`: Load reviews
  - `clearData()`: Clear semua data

---

## 📱 Screens

### Owner Home Screen (Dashboard)
**File:** `owner_home_screen.dart`

**Struktur:**
```
AppBar (dengan refresh & notification icons)
├── _DashboardView
│   ├── Welcome Section (gradient header)
│   ├── Key Metrics (4 cards grid)
│   ├── Status Reservasi (2 cards)
│   ├── Recent Reservations (preview)
│   └── Venue Overview (preview)
└── BottomNavigationBar (5 items)
```

### Owner Manage Tongkrongan Screen
**File:** `owner_manage_tongkrongan_screen.dart`

**Fitur:**
- Filter chips untuk status
- Infinite scrolling
- Detailed venue cards
- Bottom sheet untuk detail lengkap
- FAB untuk tambah venue baru

### Owner Reservations Screen
**File:** `owner_reservations_screen.dart`

**Fitur:**
- Tab navigation untuk filter status
- Infinite scrolling per tab
- Approve/Reject buttons untuk pending
- Bottom sheet untuk detail reservasi
- Status update dengan confirmation dialog

### Owner Analytics Screen
**File:** `owner_analytics_screen.dart`

**Fitur:**
- Period selector (7/30/90/365 hari)
- Revenue metrics & chart
- Booking trends
- Performance metrics
- Top reviews display

### Owner Profile Screen
**File:** `owner_profile_screen.dart`

**Fitur:**
- View/Edit mode toggle
- Profile information display
- Settings menu:
  - Notifications
  - Security (change password)
  - Payment methods
  - Help & Support
  - Logout

---

## 🗺️ Navigasi

### Role Selection Screen
```
┌─────────────────────────────┐
│  Aplikasi Nongkrong         │
├─────────────────────────────┤
│  Pilih Mode                 │
│  ┌───────────────────────┐  │
│  │ Mode Customer         │  │ → CustomerMainScreen
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │ Mode Owner/Tenant     │  │ → OwnerHomeScreen
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │ Mode Chat             │  │ → ChatScreen
│  └───────────────────────┘  │
└─────────────────────────────┘
```

### Owner Main Navigation
```
OwnerHomeScreen (dengan Bottom Navigation)
├── Dashboard (owner_home_screen.dart)
│   ├── Detail Venue → Bottom Sheet
│   └── Detail Reservasi → Bottom Sheet
├── Venue (owner_manage_tongkrongan_screen.dart)
│   ├── Filter Status
│   ├── Venue Cards
│   └── Detail Modal
├── Reservasi (owner_reservations_screen.dart)
│   ├── Tab Navigation
│   ├── Reservasi Cards
│   └── Detail Modal + Action
├── Analitik (owner_analytics_screen.dart)
│   ├── Period Selector
│   ├── Revenue Section
│   ├── Booking Trends
│   └── Top Reviews
└── Profil (owner_profile_screen.dart)
    ├── Profile Info
    └── Settings Menu
```

---

## 🔗 Integrasi API

Aplikasi owner mengharapkan API endpoints berikut:

### Authentication
```
POST /api/auth/login
POST /api/auth/logout
```

### Owner Profile
```
GET /api/owner/profile
PUT /api/owner/profile
```

### Venue Management
```
GET /api/owner/tongkrongan?page=1&limit=10
GET /api/owner/tongkrongan/{id}
PUT /api/owner/tongkrongan/{id}
POST /api/owner/tongkrongan
DELETE /api/owner/tongkrongan/{id}
```

### Reservations
```
GET /api/owner/reservations?page=1&limit=20&status=pending&tongkronganId={id}
PATCH /api/owner/reservations/{id}
```

### Analytics
```
GET /api/owner/stats
GET /api/owner/revenue-chart?months=6
GET /api/owner/booking-trends?days=30
GET /api/owner/reviews?page=1&limit=10&tongkronganId={id}
```

---

## 🚀 Quick Start

### 1. Mengakses Owner Dashboard
Dari Role Selection Screen, tap "Mode Owner/Tenant"

### 2. Provider Setup
Owner Provider sudah di-register di `main.dart`:
```dart
ChangeNotifierProvider(create: (_) => OwnerProvider()),
```

### 3. Fetch Data
```dart
// Di widget initState
context.read<OwnerProvider>().fetchStats(token);
context.read<OwnerProvider>().fetchTongkrongan(token);
context.read<OwnerProvider>().fetchReservations(token);
```

### 4. Consume Data
```dart
Consumer<OwnerProvider>(
  builder: (context, provider, child) {
    final stats = provider.stats;
    // Use data
  },
)
```

---

## 🎨 Design System

### Colors
- **Primary**: `Colors.deepPurple`
- **Success**: `Colors.green`
- **Warning**: `Colors.orange`
- **Error**: `Colors.red`
- **Info**: `Colors.blue`

### Text Styling
- **Heading**: 18px, fontWeight: bold
- **Subheading**: 14px, fontWeight: bold
- **Body**: 12-13px, color: grey
- **Value**: 14-24px, fontWeight: bold, color: brand color

### Components
- **Card**: Border dengan grey[300], borderRadius: 8-12px
- **Button**: Elevated/Outlined dengan deepPurple
- **Badge**: Colored background dengan rounded corners
- **Stats Card**: Grid dengan colored background + border

---

## ✅ Checklist Implementasi

- [x] Model data untuk Owner (Tongkrongan, Reservation, Stats)
- [x] JSON serialization untuk models
- [x] API Service untuk Owner
- [x] State Provider (ChangeNotifier)
- [x] Dashboard Screen dengan tabbed navigation
- [x] Venue Management Screen dengan filtering
- [x] Reservations Management Screen dengan tabs
- [x] Analytics Screen dengan period selector
- [x] Profile Screen dengan edit mode
- [x] Navigation integration di main.dart
- [x] Loading & error states
- [x] Infinite scrolling untuk list
- [x] Bottom sheets untuk detail
- [x] Status badges dengan warna
- [x] Responsive design

---

## 📝 TODO/Future Enhancements

- [ ] Chart visualization (revenue, booking trends)
- [ ] Real-time notifications
- [ ] Image upload untuk venue
- [ ] Export reports (PDF, Excel)
- [ ] Bulk operations (approve multiple reservations)
- [ ] Calendar view untuk reservasi
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Offline mode
- [ ] Push notifications
- [ ] Advanced filtering & search
- [ ] Customizable dashboard widgets

---

## 🐛 Troubleshooting

### Provider tidak update data
**Solusi**: Ensure `notifyListeners()` dipanggil setelah data berubah

### Infinite scroll tidak berfungsi
**Solusi**: Check `hasMoreTongkrongan` atau `hasMoreReservations` flag

### API error
**Solusi**: Check token validity dan API endpoint yang benar

### UI overflow/layout issues
**Solusi**: Use `SingleChildScrollView` atau `ListView` untuk content panjang

---

## 📚 Referensi

- [Flutter Provider Package](https://pub.dev/packages/provider)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [JSON Serialization](https://dart.dev/guides/json)
- [Material 3 Design](https://m3.material.io/)

---

**Last Updated:** September 2026
**Version:** 1.0
