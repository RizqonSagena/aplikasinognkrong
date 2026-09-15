/// Model untuk Statistik & KPI Admin
class AdminStats {
  final int totalKedai;
  final int activeKedai;
  final int kedaiInReview;
  final int totalProduk;
  final int totalUlasan;
  final double avgRating;
  final int totalChat;
  final int unreadChat;
  final int totalReservasi;
  final int reservasiPending;

  const AdminStats({
    required this.totalKedai,
    required this.activeKedai,
    required this.kedaiInReview,
    required this.totalProduk,
    required this.totalUlasan,
    required this.avgRating,
    required this.totalChat,
    required this.unreadChat,
    required this.totalReservasi,
    required this.reservasiPending,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalKedai: (json['totalKedai'] as int?) ?? 0,
      activeKedai: (json['activeKedai'] as int?) ?? 0,
      kedaiInReview: (json['kedaiInReview'] as int?) ?? 0,
      totalProduk: (json['totalProduk'] as int?) ?? 0,
      totalUlasan: (json['totalUlasan'] as int?) ?? 0,
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      totalChat: (json['totalChat'] as int?) ?? 0,
      unreadChat: (json['unreadChat'] as int?) ?? 0,
      totalReservasi: (json['totalReservasi'] as int?) ?? 0,
      reservasiPending: (json['reservasiPending'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalKedai': totalKedai,
        'activeKedai': activeKedai,
        'kedaiInReview': kedaiInReview,
        'totalProduk': totalProduk,
        'totalUlasan': totalUlasan,
        'avgRating': avgRating,
        'totalChat': totalChat,
        'unreadChat': unreadChat,
        'totalReservasi': totalReservasi,
        'reservasiPending': reservasiPending,
      };

  static const AdminStats sampleData = AdminStats(
    totalKedai: 4,
    activeKedai: 3,
    kedaiInReview: 1,
    totalProduk: 47,
    totalUlasan: 615,
    avgRating: 4.5,
    totalChat: 23,
    unreadChat: 3,
    totalReservasi: 12,
    reservasiPending: 2,
  );
}

/// Model untuk Urgent Task (Tugas Mendesak)
class UrgentTask {
  final String id;
  final String title;
  final String description;
  final String priority; // 'high', 'medium', 'low'
  final String type; // 'moderation', 'verification', 'escalation', 'review'
  final String? relatedKedaiId;
  final String? relatedKedaiName;
  final DateTime createdAt;
  final String? dueDate;

  const UrgentTask({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.type,
    this.relatedKedaiId,
    this.relatedKedaiName,
    required this.createdAt,
    this.dueDate,
  });

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as String,
      type: json['type'] as String,
      relatedKedaiId: json['relatedKedaiId'] as String?,
      relatedKedaiName: json['relatedKedaiName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'type': type,
        'relatedKedaiId': relatedKedaiId,
        'relatedKedaiName': relatedKedaiName,
        'createdAt': createdAt.toIso8601String(),
        'dueDate': dueDate,
      };

  static List<UrgentTask> get sampleData => [
        UrgentTask(
          id: 'UTK-001',
          title: 'Verifikasi Legalitas Kopi Titik Temu Senja',
          description:
              'Kedai baru perlu verifikasi dokumen kemitraan dan surat domisili sebelum aktivasi',
          priority: 'high',
          type: 'verification',
          relatedKedaiId: 'TNG-8773',
          relatedKedaiName: 'Kopi Titik Temu Senja',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          dueDate: 'Hari ini',
        ),
        UrgentTask(
          id: 'UTK-002',
          title: 'Review Keluhan Pelanggan - Selasar Kopi',
          description:
              'Ada 2 keluhan masuk tentang kebersihan gerai, butuh follow-up dengan owner',
          priority: 'high',
          type: 'escalation',
          relatedKedaiId: 'TNG-8492',
          relatedKedaiName: 'Selasar Kopi & Ruang Diskusi',
          createdAt: DateTime.now().subtract(const Duration(hours: 4)),
          dueDate: 'Besok',
        ),
        UrgentTask(
          id: 'UTK-003',
          title: 'Moderasi Konten Video - Kala Kopi',
          description:
              'Video tutorial barista menunggu review dan persetujuan untuk auto-post ke sosmed',
          priority: 'medium',
          type: 'moderation',
          relatedKedaiId: 'TNG-8211',
          relatedKedaiName: 'Kala Kopi & Ruang Cerita',
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
          dueDate: '2 hari',
        ),
      ];
}

/// Model untuk Activity Log
class ActivityLog {
  final String id;
  final String action; // 'created', 'updated', 'approved', 'rejected', 'deleted'
  final String entity; // 'kedai', 'produk', 'konten', 'reservasi'
  final String? entityId;
  final String? entityName;
  final String performedBy;
  final String? details;
  final DateTime timestamp;

  const ActivityLog({
    required this.id,
    required this.action,
    required this.entity,
    this.entityId,
    this.entityName,
    required this.performedBy,
    this.details,
    required this.timestamp,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as String,
      action: json['action'] as String,
      entity: json['entity'] as String,
      entityId: json['entityId'] as String?,
      entityName: json['entityName'] as String?,
      performedBy: json['performedBy'] as String,
      details: json['details'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'action': action,
        'entity': entity,
        'entityId': entityId,
        'entityName': entityName,
        'performedBy': performedBy,
        'details': details,
        'timestamp': timestamp.toIso8601String(),
      };

  static List<ActivityLog> get sampleData => [
        ActivityLog(
          id: 'ALG-001',
          action: 'approved',
          entity: 'konten',
          entityId: 'KNT-001',
          entityName: 'Suasana Interior Sore',
          performedBy: 'Admin Kurasi',
          details: 'Approved untuk auto-post ke Instagram',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        ActivityLog(
          id: 'ALG-002',
          action: 'created',
          entity: 'kedai',
          entityId: 'TNG-8773',
          entityName: 'Kopi Titik Temu Senja',
          performedBy: 'Reza Fahmi',
          details: 'Pendaftaran kedai baru dari owner',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ActivityLog(
          id: 'ALG-003',
          action: 'updated',
          entity: 'produk',
          entityId: 'PRD-002',
          entityName: 'Nasi Kulit Sambal Matah',
          performedBy: 'Dimas Prasetyo',
          details: 'Update harga dari Rp 30.000 menjadi Rp 32.000',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        ActivityLog(
          id: 'ALG-004',
          action: 'rejected',
          entity: 'konten',
          entityId: 'KNT-003',
          entityName: 'Sajian Nasi Kulit Sambal Matah',
          performedBy: 'Admin Kurasi',
          details: 'Blur & lighting kurang optimal',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];
}
