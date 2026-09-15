/// Model untuk Konten/Media dari perspektif Admin
class AdminKonten {
  final String id;
  final String kedaiId;
  final String kedaiName;
  final String type; // 'photo', 'video'
  final String contentUrl;
  final String? thumbnailUrl;
  final String title;
  final String? description;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime uploadedAt;
  final String uploadedBy;
  final bool autoPostToSocmed;
  final String? rejectionReason;
  final String? moderatorNote;

  const AdminKonten({
    required this.id,
    required this.kedaiId,
    required this.kedaiName,
    required this.type,
    required this.contentUrl,
    this.thumbnailUrl,
    required this.title,
    this.description,
    required this.status,
    required this.uploadedAt,
    required this.uploadedBy,
    this.autoPostToSocmed = false,
    this.rejectionReason,
    this.moderatorNote,
  });

  factory AdminKonten.fromJson(Map<String, dynamic> json) {
    return AdminKonten(
      id: json['id'] as String,
      kedaiId: json['kedaiId'] as String,
      kedaiName: json['kedaiName'] as String,
      type: json['type'] as String,
      contentUrl: json['contentUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      uploadedBy: json['uploadedBy'] as String,
      autoPostToSocmed: (json['autoPostToSocmed'] as bool?) ?? false,
      rejectionReason: json['rejectionReason'] as String?,
      moderatorNote: json['moderatorNote'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kedaiId': kedaiId,
        'kedaiName': kedaiName,
        'type': type,
        'contentUrl': contentUrl,
        'thumbnailUrl': thumbnailUrl,
        'title': title,
        'description': description,
        'status': status,
        'uploadedAt': uploadedAt.toIso8601String(),
        'uploadedBy': uploadedBy,
        'autoPostToSocmed': autoPostToSocmed,
        'rejectionReason': rejectionReason,
        'moderatorNote': moderatorNote,
      };

  static List<AdminKonten> get sampleData => [
        AdminKonten(
          id: 'KNT-001',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          type: 'photo',
          contentUrl: '',
          thumbnailUrl: '',
          title: 'Suasana Interior Sore',
          description:
              'Foto suasana gerai saat golden hour, menampilkan corner nyaman untuk diskusi',
          status: 'approved',
          uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
          uploadedBy: 'Dimas Prasetyo',
          autoPostToSocmed: true,
          moderatorNote: 'Lighting bagus, cocok untuk feed Instagram.',
        ),
        AdminKonten(
          id: 'KNT-002',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          type: 'video',
          contentUrl: '',
          thumbnailUrl: '',
          title: 'Tutorial Barista - Pull Shot Espresso',
          description: 'Video tutorial singkat cara pull shot espresso yang benar',
          status: 'pending',
          uploadedAt: DateTime.now().subtract(const Duration(hours: 3)),
          uploadedBy: 'Dimas Prasetyo',
          autoPostToSocmed: false,
          moderatorNote: null,
        ),
        AdminKonten(
          id: 'KNT-003',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          type: 'photo',
          contentUrl: '',
          thumbnailUrl: '',
          title: 'Sajian Nasi Kulit Sambal Matah',
          description:
              'Close-up foto plating nasi kulit dengan sambal matah segar',
          status: 'rejected',
          uploadedAt: DateTime.now().subtract(const Duration(days: 5)),
          uploadedBy: 'Dimas Prasetyo',
          autoPostToSocmed: false,
          rejectionReason: 'Blur & lighting kurang optimal',
          moderatorNote: 'Coba ulang dengan pencahayaan lebih terang',
        ),
      ];
}
