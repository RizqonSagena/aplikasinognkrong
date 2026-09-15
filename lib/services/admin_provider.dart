import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'admin_api_service.dart';
import '../models/admin_kedai.dart';
import '../models/admin_produk.dart';
import '../models/admin_konten.dart';
import '../models/admin_stats.dart';

// ========== API Service Provider ==========
final adminApiServiceProvider = Provider<AdminApiService>((ref) {
  return AdminApiService(dio: Dio());
});

// ========== Kedai Providers ==========

/// Get daftar Kedai dengan pagination
final adminKedaiListProvider =
    FutureProvider.family<List<AdminKedai>, ({int page, String? status, String? search})>((
  ref,
  params,
) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getKedaiList(
    page: params.page,
    pageSize: 10,
    status: params.status,
    search: params.search,
  );
});

/// Get detail Kedai by ID
final adminKedaiDetailProvider =
    FutureProvider.family<AdminKedai, String>((ref, kedaiId) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getKedaiDetail(kedaiId);
});

/// Get Kedai yang sedang dalam review
final adminKedaiInReviewProvider = FutureProvider<List<AdminKedai>>((ref) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getKedaiList(status: 'review');
});

// ========== Produk Providers ==========

/// Get daftar Produk dengan pagination
final adminProdukListProvider =
    FutureProvider.family<List<AdminProduk>, ({int page, String? kedaiId, String? status})>((
  ref,
  params,
) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getProdukList(
    page: params.page,
    pageSize: 20,
    kedaiId: params.kedaiId,
    status: params.status,
  );
});

/// Get Produk by Kedai ID
final adminProdukByKedaiProvider =
    FutureProvider.family<List<AdminProduk>, String>((ref, kedaiId) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getProdukList(kedaiId: kedaiId);
});

// ========== Konten Providers ==========

/// Get daftar Konten (Photo & Video) dengan pagination
final adminKontenListProvider = FutureProvider.family<
    List<AdminKonten>,
    ({int page, String? kedaiId, String? status, String? type})>((
  ref,
  params,
) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getKontenList(
    page: params.page,
    pageSize: 15,
    kedaiId: params.kedaiId,
    status: params.status,
    type: params.type,
  );
});

/// Get Konten pending untuk moderasi
final adminKontenPendingProvider = FutureProvider<List<AdminKonten>>((ref) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getKontenList(status: 'pending');
});

/// Get Konten by Kedai ID
final adminKontenByKedaiProvider =
    FutureProvider.family<List<AdminKonten>, String>((ref, kedaiId) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getKontenList(kedaiId: kedaiId);
});

// ========== Stats Providers ==========

/// Get Dashboard Stats
final adminStatsProvider = FutureProvider<AdminStats>((ref) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getStats();
});

/// Get Urgent Tasks
final adminUrgentTasksProvider = FutureProvider<List<UrgentTask>>((ref) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getUrgentTasks();
});

/// Get Activity Log
final adminActivityLogProvider =
    FutureProvider.family<List<ActivityLog>, int>((ref, limit) async {
  final service = ref.watch(adminApiServiceProvider);
  return service.getActivityLog(limit: limit);
});

// ========== State Notifier Providers (untuk mutation/update) ==========

/// Kelola state untuk update Kedai status
class AdminKedaiStatusNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminApiService _apiService;

  AdminKedaiStatusNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<void> updateStatus(String kedaiId, String newStatus) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _apiService.updateKedaiStatus(kedaiId, newStatus),
    );
  }
}

final adminKedaiStatusNotifierProvider =
    StateNotifierProvider<AdminKedaiStatusNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(adminApiServiceProvider);
  return AdminKedaiStatusNotifier(service);
});

/// Kelola state untuk toggle Produk status
class AdminProdukToggleNotifier extends StateNotifier<AsyncValue<AdminProduk>> {
  final AdminApiService _apiService;

  AdminProdukToggleNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<void> toggle(String produkId, bool isActive) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _apiService.toggleProdukStatus(produkId, isActive),
    );
  }
}

final adminProdukToggleNotifierProvider =
    StateNotifierProvider<AdminProdukToggleNotifier, AsyncValue<AdminProduk>>((ref) {
  final service = ref.watch(adminApiServiceProvider);
  return AdminProdukToggleNotifier(service);
});

/// Kelola state untuk moderasi Konten
class AdminKontenModerasiNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminApiService _apiService;

  AdminKontenModerasiNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<void> approve(String kontenId, {String? moderatorNote}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _apiService.approveKonten(kontenId, moderatorNote: moderatorNote),
    );
  }

  Future<void> reject(
    String kontenId, {
    required String rejectionReason,
    String? moderatorNote,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _apiService.rejectKonten(
        kontenId,
        rejectionReason: rejectionReason,
        moderatorNote: moderatorNote,
      ),
    );
  }
}

final adminKontenModerasiNotifierProvider =
    StateNotifierProvider<AdminKontenModerasiNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(adminApiServiceProvider);
  return AdminKontenModerasiNotifier(service);
});

/// Kelola state untuk resolve Urgent Task
class AdminTaskResolverNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminApiService _apiService;

  AdminTaskResolverNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<void> resolve(String taskId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _apiService.resolveTask(taskId),
    );
  }
}

final adminTaskResolverNotifierProvider =
    StateNotifierProvider<AdminTaskResolverNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(adminApiServiceProvider);
  return AdminTaskResolverNotifier(service);
});

// ========== Invalidation Helper untuk Refresh Data ==========

/// Refresh semua admin data (biasanya setelah ada perubahan)
Future<void> refreshAdminData(WidgetRef ref) async {
  ref.invalidate(adminStatsProvider);
  ref.invalidate(adminUrgentTasksProvider);
  ref.invalidate(adminActivityLogProvider);
}

/// Refresh Kedai list & stats setelah update
Future<void> refreshKedaiData(WidgetRef ref) async {
  ref.invalidate(adminKedaiListProvider);
  ref.invalidate(adminKedaiInReviewProvider);
  ref.invalidate(adminStatsProvider);
}

/// Refresh Produk list setelah update
Future<void> refreshProdukData(WidgetRef ref) async {
  ref.invalidate(adminProdukListProvider);
  ref.invalidate(adminStatsProvider);
}

/// Refresh Konten list setelah moderasi
Future<void> refreshKontenData(WidgetRef ref) async {
  ref.invalidate(adminKontenListProvider);
  ref.invalidate(adminKontenPendingProvider);
  ref.invalidate(adminActivityLogProvider);
}
