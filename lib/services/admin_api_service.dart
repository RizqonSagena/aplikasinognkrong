import 'package:dio/dio.dart';
import '../models/admin_kedai.dart';
import '../models/admin_produk.dart';
import '../models/admin_konten.dart';
import '../models/admin_stats.dart';

/// Service untuk API calls Admin Portal
class AdminApiService {
  final Dio dio;
  static const String baseUrl = 'https://api.tongkrongan.app/admin';

  AdminApiService({Dio? dio}) : dio = dio ?? Dio() {
    this.dio.options.baseUrl = baseUrl;
    this.dio.options.connectTimeout = const Duration(seconds: 10);
    this.dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  /// Get semua Kedai dengan pagination & filter
  Future<List<AdminKedai>> getKedaiList({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? search,
    String? city,
  }) async {
    try {
      final response = await dio.get(
        '/kedai',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (status != null) 'status': status,
          if (search != null) 'search': search,
          if (city != null) 'city': city,
        },
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((json) => AdminKedai.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Fallback ke sample data untuk development
      return AdminKedai.sampleData;
    }
  }

  /// Get detail Kedai by ID
  Future<AdminKedai> getKedaiDetail(String kedaiId) async {
    try {
      final response = await dio.get('/kedai/$kedaiId');
      return AdminKedai.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      final sample = AdminKedai.sampleData.firstWhere(
        (k) => k.id == kedaiId,
        orElse: () => AdminKedai.sampleData[0],
      );
      return sample;
    }
  }

  /// Update status Kedai
  Future<void> updateKedaiStatus(String kedaiId, String newStatus) async {
    try {
      await dio.patch(
        '/kedai/$kedaiId/status',
        data: {'status': newStatus},
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get semua Produk
  Future<List<AdminProduk>> getProdukList({
    int page = 1,
    int pageSize = 20,
    String? kedaiId,
    String? status,
    String? search,
  }) async {
    try {
      final response = await dio.get(
        '/produk',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (kedaiId != null) 'kedaiId': kedaiId,
          if (status != null) 'status': status,
          if (search != null) 'search': search,
        },
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((json) => AdminProduk.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return AdminProduk.sampleData;
    }
  }

  /// Toggle status Produk (aktif/tidak aktif)
  Future<AdminProduk> toggleProdukStatus(String produkId, bool isActive) async {
    try {
      final response = await dio.patch(
        '/produk/$produkId/toggle',
        data: {'isEtalaseActive': isActive},
      );
      return AdminProduk.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Get semua Konten (Photo & Video)
  Future<List<AdminKonten>> getKontenList({
    int page = 1,
    int pageSize = 15,
    String? kedaiId,
    String? status,
    String? type,
  }) async {
    try {
      final response = await dio.get(
        '/konten',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (kedaiId != null) 'kedaiId': kedaiId,
          if (status != null) 'status': status,
          if (type != null) 'type': type,
        },
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((json) => AdminKonten.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return AdminKonten.sampleData;
    }
  }

  /// Approve Konten
  Future<void> approveKonten(String kontenId, {String? moderatorNote}) async {
    try {
      await dio.patch(
        '/konten/$kontenId/approve',
        data: {
          'status': 'approved',
          if (moderatorNote != null) 'moderatorNote': moderatorNote,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Reject Konten
  Future<void> rejectKonten(
    String kontenId, {
    required String rejectionReason,
    String? moderatorNote,
  }) async {
    try {
      await dio.patch(
        '/konten/$kontenId/reject',
        data: {
          'status': 'rejected',
          'rejectionReason': rejectionReason,
          if (moderatorNote != null) 'moderatorNote': moderatorNote,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get Admin Dashboard Stats
  Future<AdminStats> getStats() async {
    try {
      final response = await dio.get('/stats');
      return AdminStats.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return AdminStats.sampleData;
    }
  }

  /// Get Urgent Tasks
  Future<List<UrgentTask>> getUrgentTasks() async {
    try {
      final response = await dio.get('/urgent-tasks');
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((json) => UrgentTask.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return UrgentTask.sampleData;
    }
  }

  /// Get Activity Log
  Future<List<ActivityLog>> getActivityLog({
    int limit = 10,
    String? entity,
  }) async {
    try {
      final response = await dio.get(
        '/activity-log',
        queryParameters: {
          'limit': limit,
          if (entity != null) 'entity': entity,
        },
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((json) => ActivityLog.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return ActivityLog.sampleData;
    }
  }

  /// Resolve Urgent Task
  Future<void> resolveTask(String taskId) async {
    try {
      await dio.patch('/urgent-tasks/$taskId/resolve');
    } catch (e) {
      rethrow;
    }
  }
}
