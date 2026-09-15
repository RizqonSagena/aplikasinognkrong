/// Model untuk notifikasi promo dan acara
class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // 'promo', 'event', 'info'
  final String? imageUrl;
  final String? tongkronganId;
  final String? tongkronganName;
  final DateTime createdAt;
  final DateTime? expiresAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.imageUrl,
    this.tongkronganId,
    this.tongkronganName,
    required this.createdAt,
    this.expiresAt,
    this.isRead = false,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  
  String get typeDisplay {
    switch (type) {
      case 'promo':
        return '🎉 Promo';
      case 'event':
        return '📅 Acara';
      default:
        return 'ℹ️ Info';
    }
  }
}
