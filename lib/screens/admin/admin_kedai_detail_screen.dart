import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/admin_colors.dart';
import '../../models/admin_kedai.dart';
import '../../models/admin_produk.dart';
import '../../services/admin_provider.dart';
import '../../widgets/admin_app_bar.dart';

class AdminKedaiDetailScreen extends ConsumerWidget {
  final String kedaiId;

  const AdminKedaiDetailScreen({
    Key? key,
    required this.kedaiId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kedaiAsync = ref.watch(adminKedaiDetailProvider(kedaiId));
    final produkAsync = ref.watch(adminProdukByKedaiProvider(kedaiId));

    return Scaffold(
      appBar: const AdminAppBar(title: 'Detail Kedai'),
      body: kedaiAsync.when(
        data: (kedai) => _buildDetailContent(context, ref, kedai, produkAsync),
        loading: () => const Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AdminColors.error, size: 48),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat detail kedai',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    WidgetRef ref,
    AdminKedai kedai,
    AsyncValue<List<AdminProduk>> produkAsync,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(adminKedaiDetailProvider(kedaiId));
        ref.invalidate(adminProdukByKedaiProvider(kedaiId));
      },
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Hero Image Section
          _buildHeroSection(kedai),

          // Status & Basic Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusBadge(kedai.status),
                const SizedBox(height: 12),
                Text(
                  kedai.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      kedai.rating > 0
                          ? '${kedai.rating} (${kedai.reviewCount} ulasan)'
                          : 'Belum ada ulasan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kedai.rating > 0
                            ? AdminColors.onSurface
                            : AdminColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Info Cards Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.1,
              children: [
                _buildInfoCard('Menu', '${kedai.menuCount}', Icons.menu),
                _buildInfoCard('Foto', '${kedai.photoCount}', Icons.image),
                _buildInfoCard('Video', '${kedai.videoCount}', Icons.videocam),
                _buildInfoCard('Ulasan', '${kedai.reviewCount}', Icons.chat),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Divider
          const Divider(color: AdminColors.outlineVariant, height: 1),
          const SizedBox(height: 16),

          // Address & Hours
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Gerai',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  icon: Icons.location_on,
                  label: 'Alamat',
                  value: kedai.address,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.schedule,
                  label: 'Jam Operasional',
                  value: kedai.operatingHours,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.category,
                  label: 'Kategori',
                  value: kedai.category,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Divider(color: AdminColors.outlineVariant, height: 1),
          const SizedBox(height: 16),

          // Owner Contact Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Pemilik',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  icon: Icons.person,
                  label: 'Nama',
                  value: kedai.ownerName,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.email,
                  label: 'Email',
                  value: kedai.ownerEmail,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.phone,
                  label: 'Telepon',
                  value: kedai.ownerPhone,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Divider(color: AdminColors.outlineVariant, height: 1),
          const SizedBox(height: 16),

          // Media Gallery Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Galeri Media',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                _buildMediaGallery(),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Divider(color: AdminColors.outlineVariant, height: 1),
          const SizedBox(height: 16),

          // Katalog Menu Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Katalog Menu',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AdminColors.onSurface,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // Open menu management
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Tambah'),
                      style: TextButton.styleFrom(
                        foregroundColor: AdminColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                produkAsync.when(
                  data: (produk) => _buildMenuKatalog(produk),
                  loading: () => const Center(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  error: (error, _) => const Text(
                    'Gagal memuat menu',
                    style: TextStyle(
                      fontSize: 12,
                      color: AdminColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Curator Notes (if status is review)
          if (kedai.status == 'review' && kedai.curatorNote != null) ...[
            const Divider(color: AdminColors.outlineVariant, height: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Catatan Kurasi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AdminColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AdminColors.secondaryContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AdminColors.secondary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      kedai.curatorNote!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AdminColors.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildActionButtons(context, ref, kedai),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(AdminKedai kedai) {
    return Container(
      height: 180,
      color: AdminColors.surfaceContainer,
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.image_not_supported,
              size: 60,
              color: AdminColors.outline.withOpacity(0.3),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(
                // context will be passed when using this
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AdminColors.surfaceContainerLowest.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: AdminColors.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    late Color bgColor;
    late Color textColor;
    late String label;
    late IconData icon;

    switch (status) {
      case 'active':
        bgColor = AdminColors.tertiaryContainer;
        textColor = AdminColors.onTertiaryContainer;
        label = 'AKTIF';
        icon = Icons.check_circle;
        break;
      case 'review':
        bgColor = AdminColors.secondaryContainer;
        textColor = AdminColors.onSecondaryContainer;
        label = 'DALAM REVIEW';
        icon = Icons.schedule;
        break;
      case 'inactive':
        bgColor = AdminColors.surfaceContainer;
        textColor = AdminColors.onSurfaceVariant;
        label = 'TIDAK AKTIF';
        icon = Icons.block;
        break;
      default:
        bgColor = AdminColors.surfaceContainer;
        textColor = AdminColors.onSurfaceVariant;
        label = status.toUpperCase();
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AdminColors.outlineVariant),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AdminColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: AdminColors.primary, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AdminColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AdminColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaGallery() {
    // Placeholder untuk galeri media (foto & video)
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          3,
          (index) => Container(
            width: 100,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AdminColors.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AdminColors.outlineVariant),
            ),
            child: Center(
              child: Icon(
                index == 2 ? Icons.videocam : Icons.image_not_supported,
                size: 32,
                color: AdminColors.outline.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuKatalog(List<AdminProduk> produk) {
    if (produk.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: AdminColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AdminColors.outlineVariant),
        ),
        child: const Center(
          child: Text(
            'Belum ada menu',
            style: TextStyle(
              fontSize: 12,
              color: AdminColors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        produk.length,
        (index) => _buildMenuItemCard(produk[index]),
      ),
    );
  }

  Widget _buildMenuItemCard(AdminProduk produk) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AdminColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AdminColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AdminColors.surfaceContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                size: 24,
                color: AdminColors.outline.withOpacity(0.4),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  produk.category,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AdminColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${produk.price.toString()}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: produk.status == 'active'
                  ? AdminColors.tertiaryContainer
                  : AdminColors.errorContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              produk.status == 'active' ? 'Aktif' : 'Inaktif',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: produk.status == 'active'
                    ? AdminColors.onTertiaryContainer
                    : AdminColors.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    AdminKedai kedai,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Edit kedai
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Informasi Gerai'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: AdminColors.primary,
              foregroundColor: AdminColors.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (kedai.status == 'review')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Approve kedai
                final statusNotifier =
                    ref.read(adminKedaiStatusNotifierProvider.notifier);
                statusNotifier.updateStatus(kedai.id, 'active');
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Setujui Pendaftaran'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AdminColors.tertiary,
                foregroundColor: AdminColors.onTertiary,
              ),
            ),
          ),
        if (kedai.status == 'review') const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // View owner chat
            },
            icon: const Icon(Icons.chat),
            label: const Text('Hubungi Pemilik'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AdminColors.secondary),
              foregroundColor: AdminColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
