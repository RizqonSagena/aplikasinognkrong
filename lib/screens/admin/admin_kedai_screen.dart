import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/admin_colors.dart';
import '../../models/admin_kedai.dart';
import '../../services/admin_provider.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_nav.dart';

class AdminKedaiScreen extends ConsumerStatefulWidget {
  const AdminKedaiScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminKedaiScreen> createState() => _AdminKedaiScreenState();
}

class _AdminKedaiScreenState extends ConsumerState<AdminKedaiScreen> {
  final searchController = TextEditingController();
  String selectedStatus = 'all';
  int currentPage = 1;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusFilter =
        selectedStatus == 'all' ? null : selectedStatus;
    final searchQuery = searchController.text.isNotEmpty ? searchController.text : null;

    final kedaiListAsync = ref.watch(
      adminKedaiListProvider(
        (page: currentPage, status: statusFilter, search: searchQuery),
      ),
    );

    return Scaffold(
      appBar: const AdminAppBar(title: 'Kelola Kedai'),
      body: Column(
        children: [
          // Search & Filter Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 12),
                _buildFilterChips(),
              ],
            ),
          ),

          // Kedai List
          Expanded(
            child: kedaiListAsync.when(
              data: (kedaiList) => _buildKedaiList(kedaiList),
              loading: () => _buildKedaiListLoading(),
              error: (error, stack) => _buildKedaiListError(error),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      onChanged: (_) => setState(() => currentPage = 1),
      decoration: InputDecoration(
        hintText: 'Cari nama kedai, area, atau kota...',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AdminColors.onSurfaceVariant,
        ),
        prefixIcon: const Icon(Icons.search, color: AdminColors.onSurfaceVariant),
        suffixIcon: searchController.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  searchController.clear();
                  setState(() => currentPage = 1);
                },
                child: const Icon(Icons.close, color: AdminColors.onSurfaceVariant),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AdminColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AdminColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AdminColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AdminColors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      onSubmitted: (_) => setState(() => currentPage = 1),
    );
  }

  Widget _buildFilterChips() {
    final statuses = [
      ('all', 'Semua'),
      ('active', 'Aktif'),
      ('review', 'Review'),
      ('inactive', 'Tidak Aktif'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          statuses.length,
          (index) {
            final (value, label) = statuses[index];
            final isSelected = selectedStatus == value;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
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

  Widget _buildKedaiList(List<AdminKedai> kedaiList) {
    if (kedaiList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront,
              size: 48,
              color: AdminColors.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada kedai ditemukan',
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
      itemCount: kedaiList.length,
      itemBuilder: (context, index) => _buildKedaiCard(kedaiList[index]),
    );
  }

  Widget _buildKedaiCard(AdminKedai kedai) {
    return GestureDetector(
      onTap: () {
        // Navigate to detail screen
        // Navigator.push(context, MaterialPageRoute(
        //   builder: (_) => AdminKedaiDetailScreen(kedaiId: kedai.id),
        // ));
      },
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
            // Header with image & status
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              child: Container(
                height: 120,
                color: AdminColors.surfaceContainer,
                child: Stack(
                  children: [
                    // Placeholder image
                    Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: AdminColors.outline.withOpacity(0.3),
                      ),
                    ),
                    // Status badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _buildStatusBadge(kedai.status),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    kedai.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AdminColors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Category & Location
                  Row(
                    children: [
                      Icon(Icons.local_offer, size: 12, color: AdminColors.secondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          kedai.category,
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
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: AdminColors.tertiary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${kedai.area}, ${kedai.city}',
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

                  // Rating & Review Count
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        kedai.rating > 0
                            ? kedai.rating.toStringAsFixed(1)
                            : 'Belum ada ulasan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kedai.rating > 0
                              ? AdminColors.onSurface
                              : AdminColors.onSurfaceVariant,
                        ),
                      ),
                      if (kedai.rating > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(${kedai.reviewCount} ulasan)',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AdminColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Menu & Media Counts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCountBadge(
                        icon: Icons.menu,
                        label: '${kedai.menuCount} Menu',
                      ),
                      _buildCountBadge(
                        icon: Icons.image,
                        label: '${kedai.photoCount} Foto',
                      ),
                      _buildCountBadge(
                        icon: Icons.videocam,
                        label: '${kedai.videoCount} Video',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Owner Info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: AdminColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 12, color: AdminColors.outline),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kedai.ownerName,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AdminColors.onSurface,
                                ),
                              ),
                              Text(
                                kedai.ownerPhone,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AdminColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // View detail
                          },
                          icon: const Icon(Icons.visibility, size: 16),
                          label: const Text('Lihat Detail'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            side: const BorderSide(color: AdminColors.primary),
                            foregroundColor: AdminColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Edit or manage
                          },
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Kelola'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            backgroundColor: AdminColors.primary,
                            foregroundColor: AdminColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
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
      case 'active':
        bgColor = AdminColors.tertiaryContainer;
        textColor = AdminColors.onTertiaryContainer;
        label = 'AKTIF';
        icon = Icons.check_circle;
        break;
      case 'review':
        bgColor = AdminColors.secondaryContainer;
        textColor = AdminColors.onSecondaryContainer;
        label = 'REVIEW';
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

  Widget _buildCountBadge({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AdminColors.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AdminColors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AdminColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKedaiListLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 280,
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

  Widget _buildKedaiListError(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AdminColors.error, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Gagal memuat data kedai',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AdminColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(
              fontSize: 12,
              color: AdminColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
