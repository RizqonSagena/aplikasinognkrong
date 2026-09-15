/// Mock owner/tenant data
class MockOwnerData {
  static Map<String, dynamic> getDashboardStats() {
    return {
      'totalOrdersThisMonth': 148,
      'totalRevenueThisMonth': 26450000,
      'averageRating': 4.8,
      'totalRatings': 320,
      'ordersThisWeek': 42,
      'revenueThisWeek': 8200000,
      'pendingOrders': 3,
      'completedOrders': 145,
    };
  }

  static List<Map<String, dynamic>> getRecentOrders() {
    return [
      {
        'orderId': '#ORD-2084',
        'status': 'Pending', // new, pending, completed, cancelled
        'statusColor': 0xFFFF9500, // orange
        'customerName': 'Ardi Ryanto',
        'items': [
          {'name': 'Es Kopi Selesar Aren', 'qty': 2, 'price': 44000},
          {'name': 'Nasi Kulit Sambal Matah', 'qty': 1, 'price': 28000},
        ],
        'totalPrice': 116000,
        'orderTime': '2 menit lalu',
      },
      {
        'orderId': '#ORD-2083',
        'status': 'Completed',
        'statusColor': 0xFF4CAF50,
        'customerName': 'Dapur/Barista',
        'items': [
          {'name': 'V60 Aceh Gayo Single Origin', 'qty': 1, 'price': 65000},
          {'name': 'Artisan Croissant Butter', 'qty': 2, 'price': 25000},
        ],
        'totalPrice': 115000,
        'orderTime': '5 menit lalu',
      },
      {
        'orderId': '#ORD-2082',
        'status': 'Completed',
        'statusColor': 0xFF4CAF50,
        'customerName': 'Siap Saji',
        'items': [
          {'name': 'Menurung Pelepah Meja', 'qty': 3, 'price': 16000},
        ],
        'totalPrice': 48000,
        'orderTime': '15 menit lalu',
      },
    ];
  }

  static List<Map<String, dynamic>> getMenuItems() {
    return [
      {
        'id': '1',
        'name': 'Es Kopi Selesar Aren',
        'category': 'KOPI & SIGNATURE',
        'price': 22000,
        'stock': 50,
        'sold': 156,
        'margin': 61.3,
        'image': 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=300&h=300&fit=crop',
      },
      {
        'id': '2',
        'name': 'Nasi Kulit Sambal Matah',
        'category': 'MAKANAN BERAT',
        'price': 32000,
        'stock': 45,
        'sold': 89,
        'margin': 56.2,
        'image': 'https://images.unsplash.com/photo-1645112411341-6c4ee32510d8?w=300&h=300&fit=crop',
      },
      {
        'id': '3',
        'name': 'Manual Brew V60 Origin',
        'category': 'KOPI & SIGNATURE',
        'price': 28000,
        'stock': 120,
        'sold': 234,
        'margin': 64.2,
        'image': 'https://images.unsplash.com/photo-1447933601403-0c6688d566fa?w=300&h=300&fit=crop',
      },
      {
        'id': '4',
        'name': 'Roti Panggang Cokelat Keju',
        'category': 'CAMILAN / SNACK',
        'price': 18000,
        'stock': 0,
        'sold': 412,
        'margin': 61,
        'image': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300&h=300&fit=crop',
      },
    ];
  }

  static Map<String, dynamic> getFinancialData() {
    return {
      'totalRevenue': 3850000,
      'totalCost': 1640000,
      'profit': 2210000,
      'profitMargin': 57.4,
      'breakdown': [
        {'category': 'Kopi & Signature', 'revenue': 1850000, 'percentage': 48},
        {'category': 'Makanan Berat', 'revenue': 1200000, 'percentage': 31},
        {'category': 'Camilan', 'revenue': 800000, 'percentage': 21},
      ],
      'expenses': [
        {'name': 'Bahan Baku (COGS)', 'amount': 1640000, 'percentage': 43},
        {'name': 'Gaji Staff', 'amount': 800000, 'percentage': 21},
        {'name': 'Sewa Lokasi', 'amount': 1200000, 'percentage': 31},
        {'name': 'Utilitas & Lainnya', 'amount': 210000, 'percentage': 5},
      ],
    };
  }

  static Map<String, dynamic> getAnalytics() {
    return {
      'title': 'Analitik Performa Bisnis',
      'period': '1 Bulan Terakhir',
      'peakHours': [
        '07:00', '08:00', '09:00', '12:00', '13:00', '18:00', '19:00'
      ],
      'peakOrdersData': [45, 52, 48, 65, 70, 58, 42],
      'dailyOrders': [
        {'day': 'Sen', 'orders': 18},
        {'day': 'Sel', 'orders': 22},
        {'day': 'Rab', 'orders': 19},
        {'day': 'Kam', 'orders': 25},
        {'day': 'Jum', 'orders': 32},
        {'day': 'Sab', 'orders': 28},
        {'day': 'Min', 'orders': 24},
      ],
      'topProducts': [
        {'name': 'Es Kopi Selesar Aren', 'views': '342k', 'likes': 89},
        {'name': 'Nasi Kulit Sambal Matah', 'views': '289k', 'likes': 76},
        {'name': 'Manual Brew V60', 'views': '234k', 'likes': 65},
      ],
      'categoryPerformance': [
        {
          'name': 'Kopi & Premium',
          'value': 48,
          'trend': '+18%',
          'color': 0xFF8B4513,
        },
        {
          'name': 'Makanan',
          'value': 35,
          'trend': '+12%',
          'color': 0xFFD2691E,
        },
        {
          'name': 'Snack',
          'value': 17,
          'trend': '-5%',
          'color': 0xFFA0522D,
        },
      ],
    };
  }
}
