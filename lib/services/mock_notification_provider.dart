import '../models/notification.dart';

/// Mock notification data provider
class MockNotificationProvider {
  static List<AppNotification> getMockNotifications() {
    return [
      AppNotification(
        id: 'notif_1',
        title: 'Diskon Spesial 30%',
        message: 'Dapatkan diskon 30% untuk semua minuman di Warung Kopi Tradisional hari ini!',
        type: 'promo',
        imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400&h=400&fit=crop',
        tongkronganId: '1',
        tongkronganName: 'Warung Kopi Tradisional',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        expiresAt: DateTime.now().add(const Duration(days: 1)),
      ),
      AppNotification(
        id: 'notif_2',
        title: 'Live Music Night',
        message: 'Nikmati live music acoustic setiap Jumat malam mulai jam 20:00 di Kedai Soto Ayam Bu Rin',
        type: 'event',
        imageUrl: 'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=400&h=400&fit=crop',
        tongkronganId: '2',
        tongkronganName: 'Kedai Soto Ayam Bu Rin',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        expiresAt: DateTime.now().add(const Duration(days: 7)),
      ),
      AppNotification(
        id: 'notif_3',
        title: 'Grand Opening Cabang Baru',
        message: 'Toko Oleh-Oleh Nusantara membuka cabang baru di Blok M. Dapatkan voucher diskon untuk pembeli pertama!',
        type: 'event',
        imageUrl: 'https://images.unsplash.com/photo-1551632786-de41ec16a980?w=400&h=400&fit=crop',
        tongkronganId: '3',
        tongkronganName: 'Toko Oleh-Oleh Nusantara',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        expiresAt: DateTime.now().add(const Duration(days: 3)),
      ),
      AppNotification(
        id: 'notif_4',
        title: 'Member Loyalty Reward',
        message: 'Anda telah mengumpulkan 500 poin! Tukarkan dengan voucher senilai Rp 50.000',
        type: 'info',
        createdAt: DateTime.now().subtract(const Duration(hours: 24)),
      ),
      AppNotification(
        id: 'notif_5',
        title: 'Flash Sale - Pastry Segar',
        message: 'Beli 2 Pastry gratis 1! Penawaran terbatas hanya untuk 50 pembeli pertama di Cafe Pastry Sederhana',
        type: 'promo',
        imageUrl: 'https://images.unsplash.com/photo-1533134242443-742379baae39?w=400&h=400&fit=crop',
        tongkronganId: '5',
        tongkronganName: 'Cafe Pastry Sederhana',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        expiresAt: DateTime.now().add(const Duration(hours: 8)),
      ),
    ];
  }

  static List<AppNotification> getActiveNotifications() {
    return getMockNotifications()
        .where((notif) => !notif.isExpired && !notif.isRead)
        .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static List<AppNotification> getPromoNotifications() {
    return getActiveNotifications()
        .where((notif) => notif.type == 'promo')
        .toList();
  }

  static List<AppNotification> getEventNotifications() {
    return getActiveNotifications()
        .where((notif) => notif.type == 'event')
        .toList();
  }
}
