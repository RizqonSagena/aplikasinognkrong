/// Model untuk data Produk/Menu dari perspektif Admin
class AdminProduk {
  final String id;
  final String kedaiId;
  final String kedaiName;
  final String name;
  final String category;
  final String description;
  final int price;
  final String status; // 'active', 'inactive', 'out_of_stock'
  final String imageUrl;
  final String? operatorNote;
  final bool isEtalaseActive;

  const AdminProduk({
    required this.id,
    required this.kedaiId,
    required this.kedaiName,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.status,
    required this.imageUrl,
    this.operatorNote,
    this.isEtalaseActive = true,
  });

  factory AdminProduk.fromJson(Map<String, dynamic> json) {
    return AdminProduk(
      id: json['id'] as String,
      kedaiId: json['kedaiId'] as String,
      kedaiName: json['kedaiName'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as int?) ?? 0,
      status: json['status'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      operatorNote: json['operatorNote'] as String?,
      isEtalaseActive: (json['isEtalaseActive'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kedaiId': kedaiId,
        'kedaiName': kedaiName,
        'name': name,
        'category': category,
        'description': description,
        'price': price,
        'status': status,
        'imageUrl': imageUrl,
        'operatorNote': operatorNote,
        'isEtalaseActive': isEtalaseActive,
      };

  AdminProduk copyWith({bool? isEtalaseActive, String? status}) {
    return AdminProduk(
      id: id,
      kedaiId: kedaiId,
      kedaiName: kedaiName,
      name: name,
      category: category,
      description: description,
      price: price,
      status: status ?? this.status,
      imageUrl: imageUrl,
      operatorNote: operatorNote,
      isEtalaseActive: isEtalaseActive ?? this.isEtalaseActive,
    );
  }

  static List<AdminProduk> get sampleData => [
        const AdminProduk(
          id: 'PRD-001',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          name: 'Es Kopi Selasar Aren',
          category: 'Kopi & Signature',
          description:
              'Espresso double shot, susu segar, dan gula aren organik homemade.',
          price: 22000,
          status: 'active',
          imageUrl: '',
          isEtalaseActive: true,
        ),
        const AdminProduk(
          id: 'PRD-002',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          name: 'Nasi Kulit Sambal Matah',
          category: 'Makanan Berat',
          description:
              'Nasi hangat dengan kulit ayam renyah berbumbu rempah dan sambal matah Bali segar.',
          price: 32000,
          status: 'active',
          imageUrl: '',
          isEtalaseActive: true,
        ),
        const AdminProduk(
          id: 'PRD-003',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          name: 'Manual Brew V60 Aceh Gayo',
          category: 'Kopi Single Origin',
          description:
              'Notes: Floral, peach, caramel finish. Medium roast dengan teknik filter lembut.',
          price: 28000,
          status: 'active',
          imageUrl: '',
          isEtalaseActive: true,
        ),
        const AdminProduk(
          id: 'PRD-004',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          name: 'Roti Panggang Cokelat Keju',
          category: 'Snack / Camilan',
          description: 'Roti panggang dengan topping cokelat dan keju.',
          price: 18000,
          status: 'out_of_stock',
          imageUrl: '',
          isEtalaseActive: false,
          operatorNote:
              'Dinonaktifkan sementara atas permintaan owner karena persediaan bahan keju habis.',
        ),
      ];
}
