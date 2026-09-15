import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../models/owner_tongkrongan.dart';
import '../models/owner_reservation.dart';
import '../models/owner_stats.dart';

/// Service untuk API calls Owner/Tenant
class OwnerApiService {
  final Dio _dio;
  final String baseUrl = AppConfig().apiBaseUrl;

  OwnerApiService({Dio? dio}) : _dio = dio ?? Dio();

  /// Get owner profile
  Future<Map<String, dynamic>> getOwnerProfile(String token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/owner/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get owner profile: ${e.message}');
    }
  }

  /// Get all tongkrongan for owner
  Future<List<OwnerTongkrongan>> getOwnerTongkrongan(
    String token, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/owner/tongkrongan',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        final list = data['data'] as List;
        return list
            .map((item) => OwnerTongkrongan.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to get tongkrongan: ${e.message}');
    }
  }

  /// Get single tongkrongan details
  Future<OwnerTongkrongan> getTongkronganDetail(
    String token,
    String tongkronganId,
  ) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/owner/tongkrongan/$tongkronganId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return OwnerTongkrongan.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception('Failed to get tongkrongan detail: ${e.message}');
    }
  }

  /// Update tongkrongan
  Future<OwnerTongkrongan> updateTongkrongan(
    String token,
    String tongkronganId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/owner/tongkrongan/$tongkronganId',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return OwnerTongkrongan.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update tongkrongan: ${e.message}');
    }
  }

  /// Get reservations for owner
  Future<List<OwnerReservation>> getReservations(
    String token, {
    int page = 1,
    int limit = 20,
    String? status,
    String? tongkronganId,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (tongkronganId != null) 'tongkronganId': tongkronganId,
      };

      final response = await _dio.get(
        '$baseUrl/api/owner/reservations',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        final list = data['data'] as List;
        return list
            .map((item) => OwnerReservation.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to get reservations: ${e.message}');
    }
  }

  /// Update reservation status
  Future<OwnerReservation> updateReservationStatus(
    String token,
    String reservationId,
    String status,
  ) async {
    try {
      final response = await _dio.patch(
        '$baseUrl/api/owner/reservations/$reservationId',
        data: {'status': status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return OwnerReservation.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update reservation: ${e.message}');
    }
  }

  /// Get owner statistics
  Future<OwnerStats> getStats(String token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/owner/stats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return OwnerStats.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to get stats: ${e.message}');
    }
  }

  /// Get monthly revenue chart data
  Future<Map<String, dynamic>> getRevenueChart(
    String token, {
    int months = 6,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/owner/revenue-chart',
        queryParameters: {'months': months},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get revenue chart: ${e.message}');
    }
  }

  /// Get booking trends
  Future<Map<String, dynamic>> getBookingTrends(
    String token, {
    int days = 30,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/owner/booking-trends',
        queryParameters: {'days': days},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get booking trends: ${e.message}');
    }
  }

  /// Get reviews for owner's tongkrongan
  Future<List<Map<String, dynamic>>> getReviews(
    String token, {
    int page = 1,
    int limit = 10,
    String? tongkronganId,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (tongkronganId != null) 'tongkronganId': tongkronganId,
      };

      final response = await _dio.get(
        '$baseUrl/api/owner/reviews',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(data['data'] as List);
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to get reviews: ${e.message}');
    }
  }
}
