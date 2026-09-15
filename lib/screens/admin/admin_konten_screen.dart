import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/admin_colors.dart';
import '../../models/admin_konten.dart';
import '../../services/admin_provider.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_nav.dart';

class AdminKontenScreen extends ConsumerStatefulWidget {
  const AdminKontenScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminKontenScreen> createState() => _AdminKontenScreenState();
}

class _AdminKontenScreenState extends ConsumerState<AdminKontenScreen> {
  String selectedStatus = 'all';
  String selectedType = 'all';
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final statusFilter = selectedStatus == 'all' ? null : selectedStatus;
    final typeFilter = selectedType == 'all' ? null : selectedType;

    final kontenListAsync = ref.watch(
      adminKontenListProvider(
        (page: currentPage, kedaiId: null, status: statusFilter, type: typeFilter),
      ),
    );

    return Scaffold(
      appBar: const AdminAppBar(title: 'Moderasi Konten'),
      body: Column(
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatusFilterChips(),
                const SizedBox(height: 10),
                _buildTypeFilterChips(),
              ],
            ),
          ),

          // Konten List
          Expanded(
            child: kontenListAsync.when(
              data: (kontenList) => _buildKontenList(kontenList),
              loading: () => _buildKontenListLoading(),
              error: (error, stack) => _buildKontenListError(error),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 3),
    );
  }

  Widget _buildStatusFilterChips() {
    final statuses = [
      ('all', 'Semua', Icons.layers),
      ('pending', 'Pending', Icons.schedule),
      ('approved', 'Disetujui', Icons.check_circle),
      ('rejected', 'Ditolak', Icons.cancel),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          statuses.length,
          (index) {
            final (value, label, icon) = statuses[index];
            final isSelected = selectedStatus == value;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Icon(icon, size: 14),
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedStatus = value;
                    currentPage = 1;
                  });
                },
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AdminColors.onPrimary : AdminColors.onSurface,
                ),
                backgroundColor: isSelected
                    ? AdminColors.primary
                    : AdminColors.surfaceContainer,
                side: BorderSide(
                  color: isSelected
                      ? AdminColors.primary
                      : AdminColors.outlineVariant,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTypeFilterChips() {
    final types = [
      ('all', 'Semua Tipe'),
      ('photo', 'Foto'),
      ('video', 'Video'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          types.length,
          (index) {
            final (value, label) = types[index];
            final isSelected = selectedType == value;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedType = value;
                    currentPage = 1;
                  });
                },
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AdminColors.onPrimary : AdminColors.onSurface,
                ),
                backgroundColor: isSelected
                    ? AdminColors.secondary
                    : AdminColors.surfaceContainer,
                side: BorderSide(
                  color: isSelected
                      ? AdminColors.secondary
                      : AdminColors.outlineVariant,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKontenList(List<AdminKonten> kontenList) {
    if (kontenList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 48,
              color: AdminColors.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada konten ditemukan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AdminColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: kontenList.length,
      itemBuilder: (context, index) => _buildKontenCard(kontenList[index]),
    );
  }

  Widget _buildKontenCard(AdminKonten konten) {
    final timeFormat = DateFormat('dd/MM/yy HH:mm');
    final isVideo = konten.type == 'video';

    return GestureDetector(
      onTap: () => _showKontenDetail(konten),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AdminColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              child: Container(
                height: 140,
                color: AdminColors.surfaceContainer,
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        isVideo ? Icons.videocam : Icons.image_not_supported,
                        size: 48,
                        color: AdminColors.outline.withOpacity(0.3),
                      ),
                    ),
                    if (isVideo)
                      const Positioned.fill(
                        child: Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 48,
                            color: AdminColors.primary,
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _buildStatusBadge(konten.status),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AdminColors.surfaceContainerLowest.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isVideo ? Icons.videocam : Icons.image,
                              size: 12,
                              color: AdminColors.onSurface,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isVideo ? 'VIDEO' : 'FOTO',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AdminColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Kedai
                  Text(
                    konten.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AdminColors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.storefront, size: 12, color: AdminColors.tertiary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          konten.kedaiName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AdminColors.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Upload Info
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AdminColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 11, color: AdminColors.outline),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Diunggah oleh ${konten.uploadedBy}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AdminColors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeFormat.format(konten.uploadedAt),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: AdminColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Auto Post Toggle & Actions
                  if (konten.status == 'pending')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AdminColors.primaryContainer.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                konten.autoPostToSocmed
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 14,
                                color: AdminColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Auto-post ke Media Sosial: ${konten.autoPostToSocmed ? "Ya" : "Tidak"}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AdminColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _moderateKonten(konten, true),
                                icon: const Icon(Icons.check_circle, size: 16),
                                label: const Text('Setujui'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  backgroundColor: AdminColors.tertiary,
                                  foregroundColor: AdminColors.onTertiary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _showRejectDialog(konten),
                                icon: const Icon(Icons.cancel, size: 16),
                                label: const Text('Tolak'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  backgroundColor: AdminColors.error,
                                  foregroundColor: AdminColors.onError,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else if (konten.status == 'rejected' && konten.rejectionReason != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AdminColors.errorContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AdminColors.error.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            size: 12,
                            color: AdminColors.error,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Alasan: ${konten.rejectionReason}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AdminColors.error,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (konten.status == 'approved')
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AdminColors.tertiaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            konten.autoPostToSocmed
                                ? Icons.share
                                : Icons.check_circle,
                            size: 12,
                            color: AdminColors.tertiary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              konten.autoPostToSocmed
                                  ? 'Disetujui & di-post ke media sosial'
                                  : 'Disetujui',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AdminColors.tertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    late Color bgColor;
    late Color textColor;
    late String label;
    late IconData icon;

    switch (status) {
      case 'pending':
        bgColor = AdminColors.secondaryContainer;
        textColor = AdminColors.onSecondaryContainer;
        label = 'PENDING';
        icon = Icons.schedule;
        break;
      case 'approved':
        bgColor = AdminColors.tertiaryContainer;
        textColor = AdminColors.onTertiaryContainer;
        label = 'DISETUJUI';
        icon = Icons.check_circle;
        break;
      case 'rejected':
        bgColor = AdminColors.errorContainer;
        textColor = AdminColors.onErrorContainer;
        label = 'DITOLAK';
        icon = Icons.cancel;
        break;
      default:
        bgColor = AdminColors.surfaceContainer;
        textColor = AdminColors.onSurfaceVariant;
        label = status.toUpperCase();
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _moderateKonten(AdminKonten konten, bool approve) async {
    final moderasiNotifier = ref.read(adminKontenModerasiNotifierProvider.notifier);

    if (approve) {
      await moderasiNotifier.approve(
        konten.id,
        moderatorNote: 'Konten disetujui oleh admin',
      );
    }

    if (mounted) {
      ref.invalidate(adminKontenListProvider);
      ref.invalidate(adminActivityLogProvider(5));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            approve
                ? '${konten.title} disetujui'
                : '${konten.title} ditolak',
          ),
        ),
      );
    }
  }

  void _showRejectDialog(AdminKonten konten) {
    final reasonController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Konten'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Konten: ${konten.title}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Alasan Penolakan *',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: 'Pilih atau tulis alasan penolakan...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Catatan Tambahan (Opsional)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Catatan untuk uploader konten...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alasan penolakan harus diisi')),
                );
                return;
              }

              final moderasiNotifier =
                  ref.read(adminKontenModerasiNotifierProvider.notifier);
              await moderasiNotifier.reject(
                konten.id,
                rejectionReason: reasonController.text,
                moderatorNote: noteController.text.isNotEmpty ? noteController.text : null,
              );

              if (mounted) {
                Navigator.pop(context);
                ref.invalidate(adminKontenListProvider);
                ref.invalidate(adminActivityLogProvider(5));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${konten.title} ditolak')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.error,
            ),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }

  void _showKontenDetail(AdminKonten konten) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              konten.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AdminColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            if (konten.description != null && konten.description!.isNotEmpty) ...[
              Text(
                konten.description!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AdminColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
            ],
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tipe:', style: TextStyle(fontWeight: FontWeight.w600)),
                Text(konten.type.toUpperCase()),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kedai:', style: TextStyle(fontWeight: FontWeight.w600)),
                Expanded(
                  child: Text(
                    konten.kedaiName,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKontenListLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 220,
        decoration: BoxDecoration(
          color: AdminColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminColors.outlineVariant),
        ),
        child: const Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildKontenListError(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AdminColors.error, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Gagal memuat konten',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AdminColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
