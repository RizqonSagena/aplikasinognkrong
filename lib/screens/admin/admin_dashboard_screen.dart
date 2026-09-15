import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/admin_colors.dart';
import '../../models/admin_stats.dart';
import '../../services/admin_provider.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_nav.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);
    final urgentTasksAsync = ref.watch(adminUrgentTasksProvider);
    final activityLogAsync = ref.watch(adminActivityLogProvider(5));

    return Scaffold(
      appBar: const AdminAppBar(title: 'Dashboard Admin'),
      body: RefreshIndicator(
        onRefresh: () => refreshAdminData(ref),
        child: ListView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 24,
          ),
          children: [
            // Header Welcome
            _buildWelcomeHeader(),
            const SizedBox(height: 24),

            // Stats Grid 2x2
            statsAsync.when(
              data: (stats) => _buildStatsGrid(context, stats),
              loading: () => _buildStatsGridLoading(),
              error: (error, stack) => _buildStatsGridError(error),
            ),
            const SizedBox(height: 32),

            // Urgent Tasks Section
            _buildUrgentTasksHeader(),
            const SizedBox(height: 12),
            urgentTasksAsync.when(
              data: (tasks) => _buildUrgentTasksList(context, tasks, ref),
              loading: () => _buildUrgentTasksLoading(),
              error: (error, stack) => _buildUrgentTasksError(error),
            ),
            const SizedBox(height: 32),

            // Activity Log Section
            _buildActivityLogHeader(),
            const SizedBox(height: 12),
            activityLogAsync.when(
              data: (logs) => _buildActivityLogList(logs),
              loading: () => _buildActivityLogLoading(),
              error: (error, stack) => _buildActivityLogError(error),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang, Admin!',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AdminColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Berikut ringkasan aktivitas portal Tongkrongan hari ini',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AdminColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, AdminStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
      children: [
        _buildStatCard(
          title: 'Kedai Aktif',
          value: stats.activeKedai.toString(),
          subtitle: 'dari ${stats.totalKedai}',
          icon: Icons.storefront,
          color: AdminColors.primary,
        ),
        _buildStatCard(
          title: 'Produk Total',
          value: stats.totalProduk.toString(),
          subtitle: 'tersedia',
          icon: Icons.local_offer,
          color: AdminColors.secondary,
        ),
        _buildStatCard(
          title: 'Rating Rata-rata',
          value: stats.avgRating.toStringAsFixed(1),
          subtitle: 'semua kedai',
          icon: Icons.star,
          color: AdminColors.tertiary,
        ),
        _buildStatCard(
          title: 'Chat Belum Dibaca',
          value: stats.unreadChat.toString(),
          subtitle: '${stats.totalChat} total',
          icon: Icons.chat_bubble,
          color: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AdminColors.outlineVariant,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AdminColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AdminColors.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGridLoading() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
      children: List.generate(
        4,
        (index) => Container(
          decoration: BoxDecoration(
            color: AdminColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGridError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: AdminColors.error, size: 40),
            const SizedBox(height: 12),
            Text(
              'Gagal memuat statistik',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AdminColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgentTasksHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tugas Mendesak',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AdminColors.onSurface,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to full tasks list
          },
          style: TextButton.styleFrom(
            foregroundColor: AdminColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text('Lihat Semua'),
        ),
      ],
    );
  }

  Widget _buildUrgentTasksList(
      BuildContext context, List<UrgentTask> tasks, WidgetRef ref) {
    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: AdminColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminColors.outlineVariant),
        ),
        child: const Center(
          child: Text(
            'Tidak ada tugas mendesak',
            style: TextStyle(
              fontSize: 14,
              color: AdminColors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        tasks.length,
        (index) => _buildUrgentTaskItem(context, tasks[index], ref),
      ),
    );
  }

  Widget _buildUrgentTaskItem(
      BuildContext context, UrgentTask task, WidgetRef ref) {
    final priorityColor = task.priority == 'high'
        ? AdminColors.error
        : task.priority == 'medium'
            ? AdminColors.secondary
            : AdminColors.outline;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priorityColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AdminColors.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AdminColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.priority.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
          if (task.relatedKedaiName != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AdminColors.surfaceContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                task.relatedKedaiName!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.dueDate ?? 'Segera',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.outline,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final taskResolver = ref.read(adminTaskResolverNotifierProvider.notifier);
                  await taskResolver.resolve(task.id);
                  ref.invalidate(adminUrgentTasksProvider);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AdminColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Tandai Selesai',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AdminColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentTasksLoading() {
    return Column(
      children: List.generate(
        2,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 100,
          decoration: BoxDecoration(
            color: AdminColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrgentTasksError(Object error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdminColors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Gagal memuat tugas mendesak',
        style: TextStyle(
          fontSize: 14,
          color: AdminColors.onErrorContainer,
        ),
      ),
    );
  }

  Widget _buildActivityLogHeader() {
    return const Text(
      'Aktivitas Terbaru',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AdminColors.onSurface,
      ),
    );
  }

  Widget _buildActivityLogList(List<ActivityLog> logs) {
    if (logs.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: AdminColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminColors.outlineVariant),
        ),
        child: const Center(
          child: Text(
            'Tidak ada aktivitas',
            style: TextStyle(
              fontSize: 14,
              color: AdminColors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      separatorBuilder: (context, index) => Divider(
        color: AdminColors.surfaceContainer,
        height: 1,
      ),
      itemBuilder: (context, index) => _buildActivityLogItem(logs[index]),
    );
  }

  Widget _buildActivityLogItem(ActivityLog log) {
    final actionIcon = _getActionIcon(log.action);
    final actionColor = _getActionColor(log.action);
    final timeFormat = DateFormat('HH:mm');
    final actionText = _getActionLabel(log.action);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AdminColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AdminColors.outlineVariant),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: actionColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(actionIcon, color: actionColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$actionText ${log.entityName ?? log.entity}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'oleh ${log.performedBy}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AdminColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            timeFormat.format(log.timestamp),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AdminColors.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLogLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AdminColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AdminColors.outlineVariant),
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityLogError(Object error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdminColors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Gagal memuat aktivitas terbaru',
        style: TextStyle(
          fontSize: 14,
          color: AdminColors.onErrorContainer,
        ),
      ),
    );
  }

  IconData _getActionIcon(String action) {
    switch (action) {
      case 'created':
        return Icons.add_circle;
      case 'updated':
        return Icons.edit;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'deleted':
        return Icons.delete;
      default:
        return Icons.info;
    }
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'created':
        return AdminColors.tertiary;
      case 'updated':
        return AdminColors.secondary;
      case 'approved':
        return AdminColors.tertiary;
      case 'rejected':
        return AdminColors.error;
      case 'deleted':
        return AdminColors.error;
      default:
        return AdminColors.outline;
    }
  }

  String _getActionLabel(String action) {
    switch (action) {
      case 'created':
        return 'Dibuat:';
      case 'updated':
        return 'Diperbarui:';
      case 'approved':
        return 'Disetujui:';
      case 'rejected':
        return 'Ditolak:';
      case 'deleted':
        return 'Dihapus:';
      default:
        return 'Aktivitas:';
    }
  }
}
