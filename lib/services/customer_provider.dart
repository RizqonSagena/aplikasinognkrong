import 'package:flutter/foundation.dart';
import '../models/tongkrongan.dart';
import '../models/review.dart';
import '../models/booking.dart';
import '../models/favorite.dart';
import '../models/customer_user.dart';
import '../utils/logger.dart';
import 'customer_api_service.dart';

/// State management untuk customer features menggunakan Provider
class CustomerProvider extends ChangeNotifier {
  final CustomerApiService _apiService = CustomerApiService();

  // ==================== STATE VARIABLES ====================

  // Tongkrongan
  List<Tongkrongan> _tongkronganList = [];
  Tongkrongan? _selectedTongkrongan;
  bool _isLoadingTongkrongan = false;
  String? _tongkronganError;

  // Reviews
  List<Review> _reviews = [];
  bool _isLoadingReviews = false;
  String? _reviewError;

  // Bookings
  List<Booking> _bookings = [];
  bool _isLoadingBookings = false;
  String? _bookingError;

  // Favorites
  List<Favorite> _favorites = [];
  bool _isLoadingFavorites = false;
  String? _favoriteError;

  // User
  CustomerUser? _currentUser;
  bool _isLoadingUser = false;
  String? _userError;

  // ==================== GETTERS ====================

  List<Tongkrongan> get tongkronganList => _tongkronganList;
  Tongkrongan? get selectedTongkrongan => _selectedTongkrongan;
  bool get isLoadingTongkrongan => _isLoadingTongkrongan;
  String? get tongkronganError => _tongkronganError;

  List<Review> get reviews => _reviews;
  bool get isLoadingReviews => _isLoadingReviews;
  String? get reviewError => _reviewError;

  List<Booking> get bookings => _bookings;
  bool get isLoadingBookings => _isLoadingBookings;
  String? get bookingError => _bookingError;

  List<Favorite> get favorites => _favorites;
  bool get isLoadingFavorites => _isLoadingFavorites;
  String? get favoriteError => _favoriteError;

  CustomerUser? get currentUser => _currentUser;
  bool get isLoadingUser => _isLoadingUser;
  String? get userError => _userError;

  // Helper untuk check apakah tongkrongan adalah favorit
  bool isFavorite(String tongkronganId) =>
      _favorites.any((fav) => fav.tongkronganId == tongkronganId);

  // ==================== TONGKRONGAN METHODS ====================

  Future<void> fetchTongkrongan({
    int page = 1,
    int pageSize = 20,
    String? city,
    String? category,
    String? query,
  }) async {
    _isLoadingTongkrongan = true;
    _tongkronganError = null;
    notifyListeners();

    try {
      _tongkronganList = await _apiService.getTongkrongan(
        page: page,
        pageSize: pageSize,
        city: city,
        category: category,
        query: query,
      );
      _tongkronganError = null;
      Logger.info('Fetched ${_tongkronganList.length} tongkrongan');
    } catch (e) {
      _tongkronganError = e.toString();
      Logger.error('Error fetching tongkrongan: $e');
    } finally {
      _isLoadingTongkrongan = false;
      notifyListeners();
    }
  }

  Future<void> getTongkronganDetail(String id) async {
    _isLoadingTongkrongan = true;
    _tongkronganError = null;
    notifyListeners();

    try {
      _selectedTongkrongan = await _apiService.getTongkronganDetail(id);
      _tongkronganError = null;
      Logger.info('Fetched tongkrongan detail: ${_selectedTongkrongan?.name}');
    } catch (e) {
      _tongkronganError = e.toString();
      Logger.error('Error fetching tongkrongan detail: $e');
    } finally {
      _isLoadingTongkrongan = false;
      notifyListeners();
    }
  }

  Future<void> searchTongkrongan(String query) async {
    _isLoadingTongkrongan = true;
    _tongkronganError = null;
    notifyListeners();

    try {
      _tongkronganList = await _apiService.searchTongkrongan(query);
      _tongkronganError = null;
      Logger.info('Search results: ${_tongkronganList.length} items');
    } catch (e) {
      _tongkronganError = e.toString();
      Logger.error('Error searching tongkrongan: $e');
    } finally {
      _isLoadingTongkrongan = false;
      notifyListeners();
    }
  }

  // ==================== REVIEW METHODS ====================

  Future<void> fetchReviews(String tongkronganId, {int page = 1}) async {
    _isLoadingReviews = true;
    _reviewError = null;
    notifyListeners();

    try {
      _reviews = await _apiService.getReviews(tongkronganId, page: page);
      _reviewError = null;
      Logger.info('Fetched ${_reviews.length} reviews');
    } catch (e) {
      _reviewError = e.toString();
      Logger.error('Error fetching reviews: $e');
    } finally {
      _isLoadingReviews = false;
      notifyListeners();
    }
  }

  Future<void> createReview(
    String tongkronganId, {
    required double rating,
    required String title,
    required String comment,
    required String token,
    List<String>? imageUrls,
  }) async {
    _isLoadingReviews = true;
    _reviewError = null;
    notifyListeners();

    try {
      final newReview = await _apiService.createReview(
        tongkronganId,
        rating: rating,
        title: title,
        comment: comment,
        token: token,
        imageUrls: imageUrls,
      );
      _reviews.insert(0, newReview);
      _reviewError = null;
      Logger.info('Review created successfully');
    } catch (e) {
      _reviewError = e.toString();
      Logger.error('Error creating review: $e');
    } finally {
      _isLoadingReviews = false;
      notifyListeners();
    }
  }

  // ==================== BOOKING METHODS ====================

  Future<void> fetchMyBookings({
    required String token,
    String? status,
  }) async {
    _isLoadingBookings = true;
    _bookingError = null;
    notifyListeners();

    try {
      _bookings = await _apiService.getMyBookings(token: token, status: status);
      _bookingError = null;
      Logger.info('Fetched ${_bookings.length} bookings');
    } catch (e) {
      _bookingError = e.toString();
      Logger.error('Error fetching bookings: $e');
    } finally {
      _isLoadingBookings = false;
      notifyListeners();
    }
  }

  Future<void> createBooking({
    required String tongkronganId,
    required DateTime bookingDate,
    required String bookingTime,
    required int numberOfPeople,
    required String token,
    String? notes,
  }) async {
    _isLoadingBookings = true;
    _bookingError = null;
    notifyListeners();

    try {
      final newBooking = await _apiService.createBooking(
        tongkronganId: tongkronganId,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        numberOfPeople: numberOfPeople,
        token: token,
        notes: notes,
      );
      _bookings.insert(0, newBooking);
      _bookingError = null;
      Logger.info('Booking created successfully');
    } catch (e) {
      _bookingError = e.toString();
      Logger.error('Error creating booking: $e');
    } finally {
      _isLoadingBookings = false;
      notifyListeners();
    }
  }

  Future<void> cancelBooking(
    String bookingId, {
    required String token,
    String? reason,
  }) async {
    _isLoadingBookings = true;
    _bookingError = null;
    notifyListeners();

    try {
      await _apiService.cancelBooking(
        bookingId,
        token: token,
        reason: reason,
      );
      // Remove dari list
      _bookings.removeWhere((b) => b.id == bookingId);
      _bookingError = null;
      Logger.info('Booking cancelled successfully');
    } catch (e) {
      _bookingError = e.toString();
      Logger.error('Error cancelling booking: $e');
    } finally {
      _isLoadingBookings = false;
      notifyListeners();
    }
  }

  // ==================== FAVORITE METHODS ====================

  Future<void> fetchFavorites({required String token}) async {
    _isLoadingFavorites = true;
    _favoriteError = null;
    notifyListeners();

    try {
      _favorites = await _apiService.getFavorites(token: token);
      _favoriteError = null;
      Logger.info('Fetched ${_favorites.length} favorites');
    } catch (e) {
      _favoriteError = e.toString();
      Logger.error('Error fetching favorites: $e');
    } finally {
      _isLoadingFavorites = false;
      notifyListeners();
    }
  }

  Future<void> addToFavorites(
    String tongkronganId, {
    required String token,
  }) async {
    try {
      final favorite = await _apiService.addToFavorites(
        tongkronganId,
        token: token,
      );
      _favorites.add(favorite);
      Logger.info('Added to favorites');
      notifyListeners();
    } catch (e) {
      _favoriteError = e.toString();
      Logger.error('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(
    String tongkronganId, {
    required String token,
  }) async {
    try {
      await _apiService.removeFromFavorites(
        tongkronganId,
        token: token,
      );
      _favorites.removeWhere((f) => f.tongkronganId == tongkronganId);
      Logger.info('Removed from favorites');
      notifyListeners();
    } catch (e) {
      _favoriteError = e.toString();
      Logger.error('Error removing from favorites: $e');
    }
  }

  // ==================== USER METHODS ====================

  Future<void> fetchUserProfile({required String token}) async {
    _isLoadingUser = true;
    _userError = null;
    notifyListeners();

    try {
      _currentUser = await _apiService.getUserProfile(token: token);
      _userError = null;
      Logger.info('Fetched user profile: ${_currentUser?.name}');
    } catch (e) {
      _userError = e.toString();
      Logger.error('Error fetching user profile: $e');
    } finally {
      _isLoadingUser = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    required String token,
    String? name,
    String? phone,
    String? bio,
    String? address,
    String? city,
    String? avatar,
  }) async {
    _isLoadingUser = true;
    _userError = null;
    notifyListeners();

    try {
      _currentUser = await _apiService.updateUserProfile(
        token: token,
        name: name,
        phone: phone,
        bio: bio,
        address: address,
        city: city,
        avatar: avatar,
      );
      _userError = null;
      Logger.info('User profile updated');
    } catch (e) {
      _userError = e.toString();
      Logger.error('Error updating user profile: $e');
    } finally {
      _isLoadingUser = false;
      notifyListeners();
    }
  }

  // ==================== CLEAR METHODS ====================

  void clearErrors() {
    _tongkronganError = null;
    _reviewError = null;
    _bookingError = null;
    _favoriteError = null;
    _userError = null;
    notifyListeners();
  }

  void clearAll() {
    _tongkronganList = [];
    _selectedTongkrongan = null;
    _reviews = [];
    _bookings = [];
    _favorites = [];
    _currentUser = null;
    clearErrors();
  }
}
