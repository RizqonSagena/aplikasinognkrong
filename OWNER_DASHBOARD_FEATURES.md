# Owner Dashboard - Feature Breakdown

Panduan lengkap untuk setiap fitur di Owner Dashboard Tongkrongan Mitra Shell.

---

## 🏠 DASHBOARD HOME SCREEN

### Layout Overview
```
┌─────────────────────────────────┐
│        [AppBar]                 │
│  Tongkrongan Mitra Shell        │  [🔔] [🔄]
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │   Welcome Section         │  │  ← Gradient Background
│  │   Selamat datang!         │  │  ← Greeting + Quick Stats
│  │   Owner Dashboard         │  │
│  │                           │  │
│  │   Revenue: Rp 50M         │  │
│  │   Booking: 120            │  │
│  │   Rating: 4.8⭐           │  │
│  └───────────────────────────┘  │
│                                 │
│  Key Metrics (2x2 Grid)         │
│  ┌──────────────┬──────────────┐ │
│  │ Total Rev.   │ Total Book.  │ │
│  │ Rp 500M      │ 1,200        │ │
│  ├──────────────┼──────────────┤ │
│  │ Active Venue │ Rating       │ │
│  │ 15/20        │ 4.8⭐        │ │
│  └──────────────┴──────────────┘ │
│                                 │
│  Status Reservasi               │
│  ┌──────────────┬──────────────┐ │
│  │ 23 Pending   │ 45 Confirmed │ │
│  └──────────────┴──────────────┘ │
│                                 │
│  Recent Reservations            │
│  ┌─────────────────────────────┐ │
│  │ 👤 John Doe     [PENDING]   │ │
│  │   Venue: Kafe A | Rp 500K   │ │
│  ├─────────────────────────────┤ │
│  │ 👤 Jane Smith   [CONFIRMED] │ │
│  │   Venue: Bar B  | Rp 750K   │ │
│  ├─────────────────────────────┤ │
│  │ 👤 Bob Wilson   [COMPLETED] │ │
│  │   Venue: Cafe C | Rp 600K   │ │
│  └─────────────────────────────┘ │
│                                 │
│  Venue Anda                     │
│  ┌─────────────────────────────┐ │
│  │ [IMG] Kafe A      [ACTIVE]  │ │
│  │      Jakarta | 4.9⭐ (150)  │ │
│  │      Booking: 120            │ │
│  │      Revenue: Rp 50M         │ │
│  ├─────────────────────────────┤ │
│  │ [IMG] Bar B       [ACTIVE]  │ │
│  │      Bandung | 4.7⭐ (120)  │ │
│  │      Booking: 95             │ │
│  │      Revenue: Rp 35M         │ │
│  ├─────────────────────────────┤ │
│  │ [IMG] Cafe C      [INACTIVE]│ │
│  │      Surabaya | 4.5⭐ (80)  │ │
│  │      Booking: 45             │ │
│  │      Revenue: Rp 18M         │ │
│  └─────────────────────────────┘ │
│                                 │
├─────────────────────────────────┤
│ [🏠] [🏪] [📅] [📊] [👤]        │  ← Bottom Navigation
│Dashboard│Venue│Reserv│Analytics│Profile│
└─────────────────────────────────┘
```

### Features
- **Welcome Section**: Gradient header dengan greeting dan key stats
- **Key Metrics**: 4-card grid menampilkan main KPIs
- **Status Cards**: Pending dan confirmed count
- **Recent Reservations**: 3 terbaru dengan status dan harga
- **Venue Preview**: 3 venue utama dengan rating dan stats
- **RefreshButton**: Di AppBar untuk reload semua data
- **Notification Bell**: Untuk alerts & notifications

### Interactions
```
Tap Venue Card          → Lihat detail di bottom sheet
Tap Reservasi Card     → Lihat detail di bottom sheet
Tap Refresh Icon       → Reload semua data
Tap Notification Bell  → Lihat notifikasi (placeholder)
Tap Tab di Bottom Nav  → Navigasi ke screen lain
```

---

## 🏪 MANAGE TONGKRONGAN SCREEN

### Layout Overview
```
┌─────────────────────────────────┐
│        [AppBar]                 │
│  Kelola Venue                   │
├─────────────────────────────────┤
│                                 │
│  Filter Chips (horizontal)      │
│  [Semua] [✓Aktif] [Tidak Aktif] │
│          [Pending]              │
│                                 │
│  Venue List                     │
│  ┌─────────────────────────────┐ │
│  │ ┌─────────────────────────┐ │ │
│  │ │ [IMG]  Kafe A  [ACTIVE] │ │ │
│  │ │ 100x100   Jakarta       │ │ │
│  │ │          4.9⭐ (150)    │ │ │
│  │ │                         │ │ │
│  │ │ 120 Book | Rp 50M | Cap:80 │ │ │
│  │ │                         │ │ │
│  │ │ [Edit]      [Analitik]  │ │ │
│  │ └─────────────────────────┘ │ │
│  ├─────────────────────────────┤ │
│  │ ┌─────────────────────────┐ │ │
│  │ │ [IMG]  Bar B   [ACTIVE] │ │ │
│  │ │ 100x100   Bandung       │ │ │
│  │ │          4.7⭐ (120)    │ │ │
│  │ │                         │ │ │
│  │ │ 95 Book | Rp 35M | Cap:100 │ │ │
│  │ │                         │ │ │
│  │ │ [Edit]      [Analitik]  │ │ │
│  │ └─────────────────────────┘ │ │
│  ├─────────────────────────────┤ │
│  │ ┌─────────────────────────┐ │ │
│  │ │ [IMG]  Cafe C  [PENDING]│ │ │
│  │ │ 100x100   Surabaya      │ │ │
│  │ │          4.5⭐ (80)     │ │ │
│  │ │                         │ │ │
│  │ │ 45 Book | Rp 18M | Cap:60 │ │ │
│  │ │                         │ │ │
│  │ │ [Edit]      [Analitik]  │ │ │
│  │ └─────────────────────────┘ │ │
│  └─────────────────────────────┘ │
│                                 │
│           [+] FAB               │
└─────────────────────────────────┘
```

### Detail Modal (Bottom Sheet)
```
┌─────────────────────────────────┐
│  Detail Venue         [X]        │
├─────────────────────────────────┤
│                                 │
│  Informasi Venue                │
│  ┌─────────────────────────────┐ │
│  │ Nama: Kafe A                │ │
│  │ Kategori: Coffee            │ │
│  │ Kota: Jakarta               │ │
│  │ Alamat: Jl. Sudirman No. 1  │ │
│  │ No. Telepon: 0812-3456-7890 │ │
│  │ Kapasitas: 80 orang         │ │
│  │ Jam Operasional: 08-23      │ │
│  └─────────────────────────────┘ │
│                                 │
│  Performa                       │
│  ┌─────────────────────────────┐ │
│  │ Rating: 4.9⭐               │ │
│  │ Total Review: 150           │ │
│  │ Total Booking: 1,200        │ │
│  │ Booking Bulan Ini: 120      │ │
│  │ Reservasi Aktif: 12         │ │
│  │ Revenue Bulan Ini: Rp 50M   │ │
│  └─────────────────────────────┘ │
│                                 │
│  Deskripsi                      │
│  Kafe dengan suasana modern...  │
│                                 │
│  [Tutup]     [Edit]             │
└─────────────────────────────────┘
```

### Features
- **Filter Chips**: Status filter (all, active, inactive, pending)
- **Infinite Scrolling**: Load more saat scroll ke bawah
- **Venue Cards**: Foto, nama, rating, stats, actions
- **Detail Modal**: Bottom sheet dengan lengkap info
- **Edit Button**: Buka form edit (placeholder)
- **Analytics Button**: View venue-specific analytics
- **FAB**: Tombol tambah venue baru

### Interactions
```
Tap Filter Chip        → Filter venue list
Scroll ke bawah        → Load more venues (infinite scroll)
Tap Venue Card         → Open detail bottom sheet
Tap Edit Button        → Open edit form
Tap Analitik Button    → View venue analytics (placeholder)
Tap FAB (+)            → Add new venue (placeholder)
Tap Close (X)          → Close detail sheet
```

---

## 📅 RESERVATIONS MANAGEMENT SCREEN

### Layout Overview
```
┌─────────────────────────────────┐
│        [AppBar]                 │
│  Reservasi                      │
│  [Semua][Pending][Confirmed]    │
│  [Selesai]                      │
├─────────────────────────────────┤
│                                 │
│  TAB CONTENT: Semua Reservasi   │
│  ┌─────────────────────────────┐ │
│  │ ┌───────────────────────────┐│ │
│  │ │ John Doe         [PENDING]││ │
│  │ │ Kafe A                    ││ │
│  │ │ 👥 4 orang | 📅 15/09    ││ │
│  │ │ 🕐 19:00 | Rp 500K       ││ │
│  │ │ [✓]       [✗]            ││ │ ← Approve/Reject
│  │ └───────────────────────────┘│ │
│  ├─────────────────────────────┤ │
│  │ ┌───────────────────────────┐│ │
│  │ │ Jane Smith      [CONFIRMED]││ │
│  │ │ Bar B                     ││ │
│  │ │ 👥 6 orang | 📅 16/09    ││ │
│  │ │ 🕐 20:00 | Rp 750K       ││ │
│  │ │ [ℹ️]                      ││ │ ← Info only
│  │ └───────────────────────────┘│ │
│  ├─────────────────────────────┤ │
│  │ ┌───────────────────────────┐│ │
│  │ │ Bob Wilson       [COMPLETED]││ │
│  │ │ Cafe C                    ││ │
│  │ │ 👥 2 orang | 📅 10/09    ││ │
│  │ │ 🕐 15:00 | Rp 300K       ││ │
│  │ │ [ℹ️]                      ││ │
│  │ └───────────────────────────┘│ │
│  └─────────────────────────────┘ │
│                                 │
│           [+] FAB               │
└─────────────────────────────────┘
```

### Detail Modal (Bottom Sheet)
```
┌─────────────────────────────────┐
│  Detail Reservasi     [X]        │
├─────────────────────────────────┤
│                                 │
│  Informasi Reservasi            │
│  ┌─────────────────────────────┐ │
│  │ ID Reservasi: RES-001       │ │
│  │ Tanggal: 15/09/2026         │ │
│  │ Jam: 19:00                  │ │
│  │ Jumlah Orang: 4             │ │
│  │ Status: PENDING             │ │
│  └─────────────────────────────┘ │
│                                 │
│  Informasi Pelanggan            │
│  ┌─────────────────────────────┐ │
│  │ Nama: John Doe              │ │
│  │ Email: john@example.com     │ │
│  │ No. Telepon: 0812-1111-1111 │ │
│  └─────────────────────────────┘ │
│                                 │
│  Venue                          │
│  ┌─────────────────────────────┐ │
│  │ Nama Venue: Kafe A          │ │
│  └─────────────────────────────┘ │
│                                 │
│  Permintaan Khusus              │
│  Meja di dekat jendela          │ │
│                                 │
│  ┌─────────────────────────────┐ │
│  │ Total Harga: Rp 500.000     │ │
│  └─────────────────────────────┘ │
│                                 │
│  [Tolak]      [Terima]          │
└─────────────────────────────────┘
```

### Features
- **Tab Navigation**: Semua, Pending, Confirmed, Selesai
- **Reservation Cards**: Customer name, venue, date, time, price, status
- **Status Badges**: Warna berbeda (orange=pending, green=confirmed, dll)
- **Approve/Reject Buttons**: Quick actions untuk pending
- **Detail Modal**: Lengkap reservation info + customer + special requests
- **Confirmation Dialog**: Confirm sebelum action
- **Infinite Scrolling**: Per tab

### Interactions
```
Tap Tab                → Filter by status
Scroll ke bawah        → Load more (infinite scroll)
Tap Reservasi Card     → Open detail modal
Tap Check (✓)          → Approve (pending only)
Tap Close (✗)          → Reject (pending only)
Tap Info (ℹ️)           → View detail
Double confirm dialog  → Confirm or cancel action
Tap FAB (+)            → Add manual reservation
```

---

## 📊 ANALYTICS SCREEN

### Layout Overview
```
┌─────────────────────────────────┐
│        [AppBar]                 │
│  Analitik                [🔄]   │
├─────────────────────────────────┤
│                                 │
│  Period Selector                │
│  [7 Hari] [30 Hari] [90 Hari]  │
│  [1 Tahun]                      │
│                                 │
│  REVENUE Section                │
│  ┌──────────────┬──────────────┐ │
│  │Total Revenue │ Bulan Ini    │ │
│  │ Rp 500M      │ Rp 50M       │ │
│  └──────────────┴──────────────┘ │
│                                 │
│  Revenue Chart (6 Bulan)        │
│  ┌─────────────────────────────┐ │
│  │                           ╱ │ │
│  │         Chart Area     ╱    │ │
│  │                    ╱        │ │
│  │  Placeholder Chart         │ │
│  │                            │ │
│  └─────────────────────────────┘ │
│                                 │
│  TREN BOOKING (2x2 Grid)        │
│  ┌──────────────┬──────────────┐ │
│  │ Total Book   │ Bulan Ini    │ │
│  │ 1,200        │ 120          │ │
│  ├──────────────┼──────────────┤ │
│  │ Pending      │ Confirmed    │ │
│  │ 23           │ 45           │ │
│  └──────────────┴──────────────┘ │
│                                 │
│  Booking Trends (30 Hari)       │
│  ┌─────────────────────────────┐ │
│  │                             │ │
│  │         Chart Area          │ │
│  │     Placeholder Chart       │ │
│  │                             │ │
│  └─────────────────────────────┘ │
│                                 │
│  METRIK PERFORMA                │
│  ┌─────────────────────────────┐ │
│  │ Rating Rata-rata: 4.8⭐    │ │
│  │ Total Review: 450           │ │
│  │ Venue Aktif: 15/20          │ │
│  └─────────────────────────────┘ │
│                                 │
│  REVIEW TERBARU                 │
│  ┌─────────────────────────────┐ │
│  │ ⭐⭐⭐⭐⭐ John Doe          │ │
│  │ Tempat yang bagus sekali... │ │
│  ├─────────────────────────────┤ │
│  │ ⭐⭐⭐⭐ Jane Smith          │ │
│  │ Pelayanan cepat dan ramah.. │ │
│  ├─────────────────────────────┤ │
│  │ ⭐⭐⭐⭐⭐ Bob Wilson       │ │
│  │ Rekomendasi terbaik untuk.. │ │
│  └─────────────────────────────┘ │
│                                 │
└─────────────────────────────────┘
```

### Features
- **Period Selector**: 7, 30, 90, 365 hari
- **Revenue Cards**: Total & monthly dengan currency formatting
- **Revenue Chart**: Placeholder untuk visualization (6 bulan)
- **Booking Trends Grid**: 4 KPI cards
- **Booking Trends Chart**: Placeholder untuk 30 hari
- **Performance Metrics**: Aligned metrics display
- **Top Reviews**: 5 reviews dengan rating stars
- **Refresh Icon**: Reload analytics data

### Interactions
```
Tap Period Chip        → Change analytics period
Scroll ke bawah        → View all sections
Tap Refresh Icon       → Reload analytics data
```

---

## 👤 PROFILE & SETTINGS SCREEN

### Layout Overview - View Mode
```
┌─────────────────────────────────┐
│        [AppBar]                 │
│  Profil                    [✏️] │
├─────────────────────────────────┤
│                                 │
│  Profile Header                 │
│  ┌─────────────────────────────┐ │
│  │          [Avatar]           │ │
│  │     👤 (100x100)            │ │
│  │   Tongkrongan Mitra         │ │
│  │   Owner ID: 12345           │ │
│  └─────────────────────────────┘ │
│                                 │
│  Informasi Profil               │
│  ┌─────────────────────────────┐ │
│  │ 👤 Nama Pemilik             │ │
│  │   Budi Santoso              │ │
│  ├─────────────────────────────┤ │
│  │ 🏪 Nama Bisnis              │ │
│  │   Tongkrongan Mitra Shell   │ │
│  ├─────────────────────────────┤ │
│  │ ✉️  Email                   │ │
│  │   budi@tongkrongan.com      │ │
│  ├─────────────────────────────┤ │
│  │ 📱 No. Telepon              │ │
│  │   0812-3456-7890            │ │
│  ├─────────────────────────────┤ │
│  │ 📅 Bergabung Sejak          │ │
│  │   01 Januari 2024           │ │
│  ├─────────────────────────────┤ │
│  │ ✅ Status                   │ │
│  │   Active                    │ │
│  └─────────────────────────────┘ │
│                                 │
│  PENGATURAN                     │
│  ┌─────────────────────────────┐ │
│  │ 🔔 Notifikasi          ➜    │ │
│  │    Kelola preferensi notif  │ │
│  ├─────────────────────────────┤ │
│  │ 🔐 Keamanan            ➜    │ │
│  │    Ubah password & settings │ │
│  ├─────────────────────────────┤ │
│  │ 💳 Metode Pembayaran   ➜    │ │
│  │    Kelola bank & pembayaran │ │
│  ├─────────────────────────────┤ │
│  │ ❓ Bantuan & Dukungan  ➜    │ │
│  │    Hubungi tim support      │ │
│  ├─────────────────────────────┤ │
│  │ 🚪 Logout              ➜    │ │
│  │    Keluar dari akun ini     │ │
│  └─────────────────────────────┘ │
│                                 │
└─────────────────────────────────┘
```

### Layout Overview - Edit Mode
```
┌─────────────────────────────────┐
│        [AppBar]                 │
│  Profil                    [✗]  │
├─────────────────────────────────┤
│                                 │
│  Edit Profil                    │
│  ┌─────────────────────────────┐ │
│  │ [👤] Nama Pemilik           │ │
│  │      [____________]         │ │
│  ├─────────────────────────────┤ │
│  │ [🏪] Nama Bisnis            │ │
│  │      [____________]         │ │
│  ├─────────────────────────────┤ │
│  │ [✉️] Email                  │ │
│  │      [____________]         │ │
│  ├─────────────────────────────┤ │
│  │ [📱] No. Telepon            │ │
│  │      [____________]         │ │
│  └─────────────────────────────┘ │
│                                 │
│  [Batal]      [Simpan]          │
└─────────────────────────────────┘
```

### Dialog Examples

#### Notifications Dialog
```
┌─────────────────────────────────┐
│  Notifikasi                     │
├─────────────────────────────────┤
│                                 │
│ ☑ Notifikasi Reservasi         │
│ ☑ Notifikasi Review            │
│ ☑ Notifikasi Pembayaran        │
│                                 │
│        [Tutup]                  │
└─────────────────────────────────┘
```

#### Security Dialog
```
┌─────────────────────────────────┐
│  Keamanan                       │
├─────────────────────────────────┤
│                                 │
│ Password Lama                   │
│ [•••••••••]                     │
│                                 │
│ Password Baru                   │
│ [•••••••••]                     │
│                                 │
│ Konfirmasi Password             │
│ [•••••••••]                     │
│                                 │
│  [Batal]     [Ubah]             │
└─────────────────────────────────┘
```

### Features
- **Profile Header**: Avatar placeholder + basic info
- **View Mode**: Display profile info dengan info cards
- **Edit Mode**: Form untuk edit nama, bisnis, email, phone
- **Settings Menu**: 5 items dengan icons
- **Notification Dialog**: Checkbox preferences
- **Security Dialog**: Password change form
- **Payment Dialog**: Bank account management
- **Help Dialog**: Support contact info
- **Logout Dialog**: Confirmation dialog

### Interactions
```
Tap Edit Icon (✏️)     → Enter edit mode
Tap Close (✗)          → Exit edit mode
Tap Simpan             → Save profile
Tap Setting Items      → Open respective dialog
Tap Logout             → Show confirmation
Tap Batal/Close        → Close dialog
```

---

## 🎨 Color Scheme

```
Primary Accent
├── Colors.deepPurple         → Main UI element
├── Colors.deepPurple.shade700 → Darker variant

Status Colors
├── Colors.green              → Success/Active (🟢)
├── Colors.orange             → Warning/Pending (🟠)
├── Colors.red                → Danger/Cancelled (🔴)
├── Colors.blue               → Info/Other (🔵)
└── Colors.amber              → Rating (⭐)

Neutral
├── Colors.grey[100-900]      → Various grays
├── Colors.white              → Background
└── Colors.black              → Text
```

---

## 🔑 Key Interactions Summary

### Navigation
```
Main Tabs (5):
1. Dashboard     → Overview
2. Venue         → Manage venues
3. Reservasi     → Manage bookings
4. Analitik      → View analytics
5. Profil        → Profile & settings
```

### Common Patterns
```
Detail View:
Card Tap → Bottom Sheet Modal → Close

List View:
Scroll Down → Load More → Infinite Scroll

Status Update:
Button Tap → Confirmation Dialog → API Call → SnackBar

Edit Mode:
Icon Tap → Form → Save/Cancel → Update UI
```

---

## 📝 Summary

Owner Dashboard menyediakan lengkap management tools untuk:
✅ Monitor bisnis secara real-time
✅ Manage venues dengan mudah
✅ Handle reservasi dengan approval flow
✅ Analisis performa dengan charts & metrics
✅ Manage profile & settings

Semua feature sudah siap dan responsif untuk berbagai ukuran device!
