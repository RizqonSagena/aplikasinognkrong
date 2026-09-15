import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/owner_provider.dart';
import '../widgets/loading_shimmer.dart';

/// Screen untuk mengelola tongkrongan milik owner
class OwnerManageTongkronganScreen extends StatefulWidget {
  final String token;

  const OwnerManageTongkronganScreen({
    super.key,
    required this.token,
  });

  @override
  State<OwnerManageTongkronganScreen> createState() =>
      _OwnerManageTongkronganScreenState();
}

class _OwnerManageTongkronganScreenState
    extends State<OwnerManageTongkronganScreen> {
  late ScrollController _scrollController;
  String _filterStatus = 'all'; // all, active, inactive, pending

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData() {
    context.read<OwnerProvider>().fetchTongkrongan(widget.token);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<OwnerProvider>().fetchMoreTongkrongan(widget.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Venue'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<OwnerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingTongkrongan && provider.tongkrongan.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          var tongkronganList = provider.tongkrongan;

          // Apply filter
          if (_filterStatus != 'all') {
            tongkronganList = tongkronganList
                .where((item) => item.status == _filterStatus)
                .toList();
          }

          return Column(
            children: [
              // Filter buttons
              _buildFilterBar(),

              // Tongkrongan list
              Expanded(
                child: tongkronganList.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: tongkronganList.length +
                            (provider.hasMoreTongkrongan ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == tongkronganList.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final item = tongkronganList[index];
                          return _buildTongkronganCard(context, item);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur tambah venue akan segera hadir')),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = [
      ('all', 'Semua'),
      ('active', 'Aktif'),
      ('inactive', 'Tidak Aktif'),
      ('pending', 'Pending'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _filterStatus == filter.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter.$2),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filterStatus = filter.$1;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.deepPurple.withOpacity(0.3),
              labelStyle: TextStyle(
                color: isSelected ? Colors.deepPurple : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada venue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai tambahkan venue Anda sekarang',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTongkronganCard(BuildContext context, dynamic tongkrongan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          _showTongkronganDetail(context, tongkrongan);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with image and status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                tongkrongan.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStatusBadge(tongkrongan.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tongkrongan.city,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Rating and reviews
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${tongkrongan.rating}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${tongkrongan.reviewCount} reviews)',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Booking', tongkrongan.monthlyBookings),
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.grey[300],
                  ),
                  _buildStatItem('Revenue', 'Rp ${_formatCurrency(tongkrongan.revenue)}'),
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.grey[300],
                  ),
                  _buildStatItem('Kapasitas', tongkrongan.capacity),
                ],
              ),
              const SizedBox(height: 12),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showTongkronganDetail(context, tongkrongan);
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Show analytics for this venue
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Analytics untuk ${tongkrongan.name}'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics_outlined),
                      label: const Text('Analitik'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String badgeText;

    switch (status.toLowerCase()) {
      case 'active':
        badgeColor = Colors.green;
        badgeText = 'Aktif';
        break;
      case 'inactive':
        badgeColor = Colors.red;
        badgeText = 'Nonaktif';
        break;
      case 'pending':
        badgeColor = Colors.orange;
        badgeText = 'Pending';
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: badgeColor,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, dynamic value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showTongkronganDetail(BuildContext context, dynamic tongkrongan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Detail Venue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Venue info
                    _buildDetailSection('Informasi Venue', [
                      _buildDetailRow('Nama', tongkrongan.name),
                      _buildDetailRow('Kategori', tongkrongan.category),
                      _buildDetailRow('Kota', tongkrongan.city),
                      _buildDetailRow('Alamat', tongkrongan.address),
                      _buildDetailRow('No. Telepon', tongkrongan.phone),
                      _buildDetailRow('Kapasitas', '${tongkrongan.capacity} orang'),
                      _buildDetailRow('Jam Operasional', tongkrongan.operatingHours),
                    ]),
                    const SizedBox(height: 16),

                    // Performance
                    _buildDetailSection('Performa', [
                      _buildDetailRow('Rating', '${tongkrongan.rating}⭐'),
                      _buildDetailRow('Total Review', '${tongkrongan.reviewCount}'),
                      _buildDetailRow('Total Booking', '${tongkrongan.totalBookings}'),
                      _buildDetailRow('Booking Bulan Ini', '${tongkrongan.monthlyBookings}'),
                      _buildDetailRow('Reservasi Aktif', '${tongkrongan.activeReservations}'),
                      _buildDetailRow('Revenue Bulan Ini', 'Rp ${_formatCurrency(tongkrongan.revenue)}'),
                    ]),
                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tongkrongan.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Edit ${tongkrongan.name}'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            child: const Text('Edit'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
