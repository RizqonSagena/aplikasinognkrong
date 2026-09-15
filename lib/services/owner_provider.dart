import 'package:flutter/foundation.dart';
import 'owner_api_service.dart';
import '../models/owner_tongkrongan.dart';
import '../models/owner_reservation.dart';
import '../models/owner_stats.dart';

/// Provider untuk mengelola state owner/tenant
class OwnerProvider extends ChangeNotifier {
  final OwnerApiService _apiService = OwnerApiService();

  // Owner data
  Map<String, dynamic>? _ownerProfile;
  List<OwnerTongkrongan> _tongkrongan = [];
  List<OwnerReservation> _reservations = [];
  OwnerStats? _stats;
  List<Map<String, dynamic>> _reviews = [];

  // Loading states
  bool _isLoadingProfile = false;
  bool _isLoadingTongkrongan = false;
  bool _isLoadingReservations = false;
  bool _isLoadingStats = false;
  bool _isLoadingReviews = false;

  // Error handling
  String? _error;

  // Pagination
  int _currentPage = 1;
  bool _hasMoreTongkrongan = true;
  bool _hasMoreReservations = true;
  bool _hasMoreReviews = true;

  // Getters
  Map<String, dynamic>? get ownerProfile => _ownerProfile;
  List<OwnerTongkrongan> get tongkrongan => _tongkrongan;
  List<OwnerReservation> get reservations => _reservations;
  OwnerStats? get stats => _stats;
  List<Map<String, dynamic>> get reviews => _reviews;

  bool get isLoadingProfile => _isLoadingProfile;
  bool get isLoadingTongkrongan => _isLoadingTongkrongan;
  bool get isLoadingReservations => _isLoadingReservations;
  bool get isLoadingStats => _isLoadingStats;
  bool get isLoadingReviews => _isLoadingReviews;

  String? get error => _error;
  bool get hasMoreTongkrongan => _hasMoreTongkrongan;
  bool get hasMoreReservations => _hasMoreReservations;
  bool get hasMoreReviews => _hasMoreReviews;

  /// Load owner profile
  Future<void> fetchOwnerProfile(String token) async {
    _isLoadingProfile = true;
    _error = null;
    notifyListeners();

    try {
      _ownerProfile = await _apiService.getOwnerProfile(token);
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching owner profile: $e');
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  /// Load owner's tongkrongan
  Future<void> fetchTongkrongan(String token, {int page = 1}) async {
    if (page == 1) {
      _isLoadingTongkrongan = true;
      _tongkrongan = [];
    }
    _error = null;
    notifyListeners();

    try {
      final items = await _apiService.getOwnerTongkrongan(
        token,
        page: page,
        limit: 10,
      );

      if (page == 1) {
        _tongkrongan = items;
      } else {
        _tongkrongan.addAll(items);
      }

      _hasMoreTongkrongan = items.length >= 10;
      _currentPage = page;
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching tongkrongan: $e');
    } finally {
      _isLoadingTongkrongan = false;
      notifyListeners();
    }
  }

  /// Load more tongkrongan
  Future<void> fetchMoreTongkrongan(String token) async {
    if (!_hasMoreTongkrongan || _isLoadingTongkrongan) return;
    await fetchTongkrongan(token, page: _currentPage + 1);
  }

  /// Load reservations
  Future<void> fetchReservations(
    String token, {
    int page = 1,
    String? status,
    String? tongkronganId,
  }) async {
    if (page == 1) {
      _isLoadingReservations = true;
      _reservations = [];
    }
    _error = null;
    notifyListeners();

    try {
      final items = await _apiService.getReservations(
        token,
        page: page,
        limit: 20,
        status: status,
        tongkronganId: tongkronganId,
      );

      if (page == 1) {
        _reservations = items;
      } else {
        _reservations.addAll(items);
      }

      _hasMoreReservations = items.length >= 20;
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching reservations: $e');
    } finally {
      _isLoadingReservations = false;
      notifyListeners();
    }
  }

  /// Update reservation status
  Future<bool> updateReservationStatus(
    String token,
    String reservationId,
    String newStatus,
  ) async {
    try {
      final updated = await _apiService.updateReservationStatus(
        token,
        reservationId,
        newStatus,
      );

      // Update local list
      final index = _reservations.indexWhere((r) => r.id == reservationId);
      if (index != -1) {
        _reservations[index] = updated;
        notifyListeners();
      }

      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating reservation: $e');
      notifyListeners();
      return false;
    }
  }

  /// Load statistics
  Future<void> fetchStats(String token) async {
    _isLoadingStats = true;
    _error = null;
    notifyListeners();

    try {
      _stats = await _apiService.getStats(token);
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching stats: $e');
    } finally {
      _isLoadingStats = false;
      notifyListeners();
    }
  }

  /// Load reviews
  Future<void> fetchReviews(
    String token, {
    int page = 1,
    String? tongkronganId,
  }) async {
    if (page == 1) {
      _isLoadingReviews = true;
      _reviews = [];
    }
    _error = null;
    notifyListeners();

    try {
      final items = await _apiService.getReviews(
        token,
        page: page,
        limit: 10,
        tongkronganId: tongkronganId,
      );

      if (page == 1) {
        _reviews = items;
      } else {
        _reviews.addAll(items);
      }

      _hasMoreReviews = items.length >= 10;
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching reviews: $e');
    } finally {
      _isLoadingReviews = false;
      notifyListeners();
    }
  }

  /// Clear data
  void clearData() {
    _ownerProfile = null;
    _tongkrongan = [];
    _reservations = [];
    _stats = null;
    _reviews = [];
    _error = null;
    _currentPage = 1;
    notifyListeners();
  }
}
