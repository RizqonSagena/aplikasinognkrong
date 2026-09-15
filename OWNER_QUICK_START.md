# Owner Dashboard - Quick Start Guide

Panduan cepat untuk memulai menggunakan Owner Dashboard.

---

## 🚀 Mulai dalam 3 Langkah

### 1. Akses Dashboard
```
Aplikasi → Role Selection → "Mode Owner/Tenant" → Dashboard Terbuka
```

### 2. Navigasi Tab
```
Bottom Navigation (5 Tab):
🏠 Dashboard    → Overview bisnis
🏪 Venue        → Manage venue
📅 Reservasi    → Manage booking
📊 Analitik     → View analytics
👤 Profil       → Profile & settings
```

### 3. Mulai Manage
```
Pilih salah satu tab → Lihat data/list → Interact (approve/edit/view)
```

---

## 📊 Dashboard (Home)

### Apa yang Dilihat?
- Overview semua bisnis Anda
- Quick stats (revenue, booking, rating)
- Recent reservations
- Venue overview

### Tombol Penting
```
🔄 Refresh         → Reload semua data
🔔 Notification    → Lihat alert (placeholder)
```

---

## 🏪 Venue Management

### Fitur Utama
```
Filter Status      → Semua / Aktif / Nonaktif / Pending
Edit Button        → Edit venue details
Analitik Button    → View venue-specific analytics
+ FAB              → Tambah venue baru
```

### Cara Pakai
```
1. Pilih filter status (optional)
2. Lihat list venue
3. Tap venue card → Detail modal
4. Tap Edit atau Analitik untuk action
```

---

## 📅 Reservations

### View Modes
```
Tab 1: Semua        → Semua reservasi
Tab 2: Pending      → Menunggu approval
Tab 3: Confirmed    → Sudah dikonfirmasi
Tab 4: Selesai      → Sudah completed
```

### Quick Actions (Pending Only)
```
✓ Green Button      → Approve reservasi
✗ Red Button        → Reject reservasi
```

### Detail View
```
Tap Card atau Info Button → Open detail modal
→ Lihat customer info, special requests, total price
→ Approve/Reject jika status = PENDING
```

---

## 📊 Analytics

### Pilih Periode
```
[7 Hari] [30 Hari] [90 Hari] [1 Tahun]
← Swipe atau tap untuk ubah
```

### Lihat Metrics
```
Revenue Section
├── Total revenue (all time)
├── Monthly revenue
└── Revenue chart (6 months)

Booking Trends
├── Total bookings
├── Monthly bookings
├── Pending count
├── Confirmed count
└── Booking trends chart (30 days)

Performance Metrics
├── Average rating
├── Total reviews
└── Active venues ratio

Top Reviews
└── 5 recent reviews dengan rating
```

---

## 👤 Profile & Settings

### View Profile
```
Default Mode
├── Lihat nama, bisnis, email, phone
├── Lihat joined date & status
└── All read-only
```

### Edit Profile
```
1. Tap Edit Icon (✏️) di AppBar
2. Form terbuka untuk edit
3. Tap Simpan untuk save
4. Tap Batal untuk cancel
```

### Settings Menu
```
🔔 Notifikasi
   → Manage notification preferences

🔐 Keamanan
   → Change password

💳 Metode Pembayaran
   → Manage bank accounts

❓ Bantuan & Dukungan
   → Contact info

🚪 Logout
   → Sign out dari akun
```

---

## 💡 Tips & Tricks

### Maximize Efficiency
```
1. Refresh di dashboard untuk latest data
2. Use filter chips di venue screen
3. Approve/reject reservasi langsung dari card (pending)
4. Check analytics regularly untuk track performa
5. Update profile regularly
```

### Best Practices
```
1. Respond to pending reservations quickly
2. Monitor revenue trends
3. Keep track of venue ratings
4. Update venue info when needed
5. Check notifications regularly
```

### Troubleshooting
```
Data tidak update?
→ Tap refresh icon di AppBar

Loading lama?
→ Check internet connection

Tidak bisa scroll?
→ Use SingleChildScrollView atau ListView

UI overflow?
→ Reduce font size atau use smaller device
```

---

## 🎯 Common Tasks

### Approve Pending Reservation
```
1. Go to Reservasi tab
2. Click Pending tab
3. Tap Green (✓) button on card
   OR tap card → modal → Terima button
4. Confirm di dialog
5. Status updated automatically
```

### View Venue Details
```
1. Go to Venue tab
2. Tap any venue card
3. Bottom sheet opens dengan detail
4. Scroll untuk lihat semua info
5. Tap Edit atau Analitik untuk action
```

### Check Monthly Revenue
```
1. Go to Analitik tab
2. Select [30 Hari] periode
3. View "Bulan Ini" revenue card
4. Scroll untuk lihat chart & trends
```

### Update Profile
```
1. Go to Profil tab
2. Tap Edit (✏️) icon
3. Update form fields
4. Tap Simpan
5. Confirmation message appears
```

---

## 🎨 UI Cheat Sheet

### Status Colors
```
🟢 Green = Active / Confirmed / Success
🟠 Orange = Pending / Warning
🔴 Red = Inactive / Cancelled / Danger
🔵 Blue = Info / Completed
⭐ Amber = Rating
```

### Button Types
```
[Solid Button]     → Primary action (approve, save)
[Outlined Button]  → Secondary action (cancel, edit)
[Text Button]      → Tertiary action (close, info)
[Chip]             → Filter (status, period)
[Icon Button]      → Quick action (edit, delete)
```

### Navigation
```
← Back          → Go previous screen
← Chevron       → More options/detail
🏠 Home Tab     → Go to home/dashboard
≡ Menu          → Open menu/settings
```

---

## 📱 Mobile vs Desktop

### Mobile Layout
```
✓ Full screen tabs
✓ Optimized buttons
✓ Bottom navigation
✓ Full modal height
✓ Touch-friendly spacing
```

### Desktop Layout
```
✓ Side navigation (if implemented)
✓ Larger cards
✓ Multi-column grids
✓ Floating modals
✓ Keyboard navigation
```

---

## ⚡ Shortcuts

### Keyboard Shortcuts (Desktop)
```
Tab              → Navigate between elements
Enter            → Confirm/Submit action
Escape           → Close modal/dialog
Arrow Keys       → Scroll (when available)
```

### Touch Gestures
```
Tap             → Click element
Swipe           → Scroll list / switch tab
Long Press      → Context menu (if available)
Pinch           → Zoom (if available)
```

---

## 🔐 Important Notes

### Data Privacy
```
✓ Token stored securely
✓ API calls use HTTPS
✓ Personal data encrypted
✓ No sensitive data in logs
```

### Offline Capability
```
Current: Online only
Future: Offline mode (planned)
→ Sync when online again
```

---

## 📞 Need Help?

### In-App Support
```
Profil Tab → Bantuan & Dukungan
├── Email: support@tongkrongan.com
├── Phone: +62-800-1234-5678
└── Website: www.tongkrongan.com
```

### Documentation
```
OWNER_DASHBOARD_README.md          → Detailed docs
OWNER_DASHBOARD_FEATURES.md         → Feature breakdown
OWNER_DASHBOARD_SUMMARY.md          → Implementation summary
OWNER_QUICK_START.md                → This file
```

---

## ✅ Checklist - First Time Setup

- [ ] Accessed dashboard successfully
- [ ] Explored all 5 tabs
- [ ] Viewed dashboard overview
- [ ] Checked venue list
- [ ] Viewed pending reservations
- [ ] Checked analytics
- [ ] Updated profile info
- [ ] Understood menu options
- [ ] Know how to approve/reject
- [ ] Bookmarked help documents

---

## 🎉 You're Ready!

Anda sudah siap menggunakan Owner Dashboard. Nikmati kemudahan manage bisnis Tongkrongan Anda!

### Enjoy! 🎊

---

**Tips:**
- Refresh frequently untuk data terbaru
- Monitor reservasi untuk quick response
- Check analytics untuk growth insights
- Keep profile updated untuk professional image

**Last Updated:** September 2026
**Version:** 1.0
