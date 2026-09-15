import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/admin_colors.dart';
import '../../models/admin_produk.dart';
import '../../services/admin_provider.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_nav.dart';

class AdminProdukScreen extends ConsumerStatefulWidget {
  const AdminProdukScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminProdukScreen> createState() => _AdminProdukScreenState();
}

class _AdminProdukScreenState extends ConsumerState<AdminProdukScreen> {
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
    final statusFilter = selectedStatus == 'all' ? null : selectedStatus;
    final searchQuery = searchController.text.isNotEmpty ? searchController.text : null;

    final produkListAsync = ref.watch(
      adminProdukListProvider(
        (page: currentPage, kedaiId: null, status: statusFilter),
      ),
    );

    return Scaffold(
      appBar: const AdminAppBar(title: 'Katalog Produk'),
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

          // Produk List
          Expanded(
            child: produkListAsync.when(
              data: (produkList) => _buildProdukList(produkList),
              loading: () => _buildProdukListLoading(),
              error: (error, stack) => _buildProdukListError(error),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      onChanged: (_) => setState(() => currentPage = 1),
      decoration: InputDecoration(
        hintText: 'Cari nama produk, kategori...',
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
      ('out_of_stock', 'Habis'),
      ('inactive', 'Nonaktif'),
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

  Widget _buildProdukList(List<AdminProduk> produkList) {
    if (produkList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer,
              size: 48,
              color: AdminColors.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada produk ditemukan',
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
      itemCount: produkList.length,
      itemBuilder: (context, index) => _buildProdukCard(produkList[index]),
    );
  }

  Widget _buildProdukCard(AdminProduk produk) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AdminColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image & Status
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
                  Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: AdminColors.outline.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _buildStatusBadge(produk.status),
                  ),
                  if (!produk.isEtalaseActive)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AdminColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NONAKTIF DI ETALASE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AdminColors.onError,
                          ),
                        ),
                      ),
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
                  produk.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Category & Kedai
                Row(
                  children: [
                    Icon(Icons.label, size: 12, color: AdminColors.secondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        produk.category,
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
                    Icon(Icons.storefront, size: 12, color: AdminColors.tertiary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        produk.kedaiName,
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

                // Price
                Text(
                  'Rp ${produk.price.toString()}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.primary,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                if (produk.description.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AdminColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      produk.description,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AdminColors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (produk.description.isNotEmpty) const SizedBox(height: 8),

                // Operator Note if any
                if (produk.operatorNote != null)
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
                            produk.operatorNote!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AdminColors.error,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (produk.operatorNote != null) const SizedBox(height: 10),

                // Toggle & Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showEditDialog(produk),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: const BorderSide(color: AdminColors.secondary),
                          foregroundColor: AdminColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _toggleProdukStatus(produk),
                        icon: Icon(
                          produk.isEtalaseActive ? Icons.visibility_off : Icons.visibility,
                          size: 16,
                        ),
                        label: Text(
                          produk.isEtalaseActive ? 'Nonaktifkan' : 'Aktifkan',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: produk.isEtalaseActive
                              ? AdminColors.error
                              : AdminColors.tertiary,
                          foregroundColor: produk.isEtalaseActive
                              ? AdminColors.onError
                              : AdminColors.onTertiary,
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
        label = 'TERSEDIA';
        icon = Icons.check_circle;
        break;
      case 'out_of_stock':
        bgColor = AdminColors.errorContainer;
        textColor = AdminColors.onErrorContainer;
        label = 'HABIS';
        icon = Icons.block;
        break;
      case 'inactive':
        bgColor = AdminColors.surfaceContainer;
        textColor = AdminColors.onSurfaceVariant;
        label = 'NONAKTIF';
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

  void _toggleProdukStatus(AdminProduk produk) async {
    final toggleNotifier = ref.read(adminProdukToggleNotifierProvider.notifier);
    await toggleNotifier.toggle(produk.id, !produk.isEtalaseActive);

    if (mounted) {
      ref.invalidate(adminProdukListProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            produk.isEtalaseActive
                ? '${produk.name} dinonaktifkan dari etalase'
                : '${produk.name} diaktifkan di etalase',
          ),
        ),
      );
    }
  }

  void _showEditDialog(AdminProduk produk) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Produk'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditField('Nama Produk', produk.name),
              const SizedBox(height: 12),
              _buildEditField('Kategori', produk.category),
              const SizedBox(height: 12),
              _buildEditField('Harga (Rp)', produk.price.toString()),
              const SizedBox(height: 12),
              _buildEditField('Deskripsi', produk.description, maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${produk.name} berhasil diperbarui'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.primary,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(
    String label,
    String initialValue, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AdminColors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: TextEditingController(text: initialValue),
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProdukListLoading() {
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

  Widget _buildProdukListError(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AdminColors.error, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Gagal memuat data produk',
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
