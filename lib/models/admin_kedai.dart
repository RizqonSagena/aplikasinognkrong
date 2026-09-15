/// Model untuk data Kedai dari perspektif Admin
class AdminKedai {
  final String id;
  final String name;
  final String category;
  final String area;
  final String city;
  final double rating;
  final int reviewCount;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  final int menuCount;
  final int photoCount;
  final int videoCount;
  final String status; // 'active', 'review', 'inactive'
  final String imageUrl;
  final String address;
  final String operatingHours;
  final String lastUpdated;
  final String? curatorNote;
  final String? submittedBy;
  final String? submittedAt;
  final double? lat;
  final double? lng;

  const AdminKedai({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.city,
    required this.rating,
    required this.reviewCount,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.menuCount,
    required this.photoCount,
    required this.videoCount,
    required this.status,
    required this.imageUrl,
    required this.address,
    required this.operatingHours,
    required this.lastUpdated,
    this.curatorNote,
    this.submittedBy,
    this.submittedAt,
    this.lat,
    this.lng,
  });

  factory AdminKedai.fromJson(Map<String, dynamic> json) {
    return AdminKedai(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      area: json['area'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as int?) ?? 0,
      ownerName: json['ownerName'] as String,
      ownerEmail: json['ownerEmail'] as String,
      ownerPhone: json['ownerPhone'] as String,
      menuCount: (json['menuCount'] as int?) ?? 0,
      photoCount: (json['photoCount'] as int?) ?? 0,
      videoCount: (json['videoCount'] as int?) ?? 0,
      status: json['status'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      address: json['address'] as String? ?? '',
      operatingHours: json['operatingHours'] as String? ?? '',
      lastUpdated: json['lastUpdated'] as String? ?? '',
      curatorNote: json['curatorNote'] as String?,
      submittedBy: json['submittedBy'] as String?,
      submittedAt: json['submittedAt'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'area': area,
        'city': city,
        'rating': rating,
        'reviewCount': reviewCount,
        'ownerName': ownerName,
        'ownerEmail': ownerEmail,
        'ownerPhone': ownerPhone,
        'menuCount': menuCount,
        'photoCount': photoCount,
        'videoCount': videoCount,
        'status': status,
        'imageUrl': imageUrl,
        'address': address,
        'operatingHours': operatingHours,
        'lastUpdated': lastUpdated,
        'curatorNote': curatorNote,
        'submittedBy': submittedBy,
        'submittedAt': submittedAt,
        'lat': lat,
        'lng': lng,
      };

  // Sample data untuk development
  static List<AdminKedai> get sampleData => [
        const AdminKedai(
          id: 'TNG-8492',
          name: 'Selasar Kopi & Ruang Diskusi',
          category: 'Coffee Shop & Coworking',
          area: 'Tebet',
          city: 'Jakarta Selatan',
          rating: 4.8,
          reviewCount: 312,
          ownerName: 'Dimas Prasetyo',
          ownerEmail: 'dimas.prasetyo@gmail.com',
          ownerPhone: '0812-8976-4321',
          menuCount: 28,
          photoCount: 6,
          videoCount: 1,
          status: 'active',
          imageUrl: '',
          address: 'Jl. Tebet Timur Dalam No. 42, Tebet, Jakarta Selatan',
          operatingHours: 'Buka Setiap Hari • 09.00 - 23.00 WIB',
          lastUpdated: '14:20',
        ),
        const AdminKedai(
          id: 'TNG-8211',
          name: 'Kala Kopi & Ruang Cerita',
          category: 'Specialty Coffee',
          area: 'Tebet Barat',
          city: 'Jakarta Selatan',
          rating: 4.7,
          reviewCount: 205,
          ownerName: 'Sarah Amalia',
          ownerEmail: 'sarah.amalia@gmail.com',
          ownerPhone: '0821-4567-8901',
          menuCount: 19,
          photoCount: 8,
          videoCount: 0,
          status: 'active',
          imageUrl: '',
          address: 'Jl. Tebet Barat Dalam No. 18, Tebet Barat, Jakarta Selatan',
          operatingHours: 'Senin-Sabtu • 08.00 - 22.00 WIB',
          lastUpdated: 'Kemarin 19:40',
        ),
        const AdminKedai(
          id: 'TNG-8773',
          name: 'Kopi Titik Temu Senja',
          category: 'Rooftop Coffee & Eatery',
          area: 'Pancoran',
          city: 'Jakarta Selatan',
          rating: 0.0,
          reviewCount: 0,
          ownerName: 'Reza Fahmi',
          ownerEmail: 'reza.fahmi@gmail.com',
          ownerPhone: '0856-1234-5678',
          menuCount: 0,
          photoCount: 4,
          videoCount: 0,
          status: 'review',
          imageUrl: '',
          address: 'Jl. Pancoran Timur No. 5, Pancoran, Jakarta Selatan',
          operatingHours: 'Belum ditentukan',
          lastUpdated: '2 jam lalu',
          curatorNote:
              'Foto gerai dan menu lengkap sudah diunggah, butuh cek legalitas kemitraan dan surat domisili usaha.',
          submittedBy: 'Reza Fahmi',
          submittedAt: '2 jam lalu',
        ),
        const AdminKedai(
          id: 'TNG-7812',
          name: 'Warkop Barokah 24 Jam',
          category: 'Warkop Modern',
          area: 'Manggarai',
          city: 'Jakarta Selatan',
          rating: 4.2,
          reviewCount: 98,
          ownerName: 'Pak Barokah',
          ownerEmail: 'warkopbarokah@gmail.com',
          ownerPhone: '0812-0000-0001',
          menuCount: 15,
          photoCount: 3,
          videoCount: 0,
          status: 'inactive',
          imageUrl: '',
          address: 'Jl. Manggarai Selatan No. 7, Manggarai, Jakarta Selatan',
          operatingHours: 'Sementara Tutup (Renovasi)',
          lastUpdated: '3 hari lalu',
        ),
      ];
}
