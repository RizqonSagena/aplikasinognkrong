import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/owner_provider.dart';

/// Screen untuk mengelola reservasi sebagai owner
class OwnerReservationsScreen extends StatefulWidget {
  final String token;

  const OwnerReservationsScreen({
    super.key,
    required this.token,
  });

  @override
  State<OwnerReservationsScreen> createState() =>
      _OwnerReservationsScreenState();
}

class _OwnerReservationsScreenState extends State<OwnerReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  String _selectedStatus = 'all'; // all, pending, confirmed, completed, cancelled

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadReservations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadReservations() {
    context.read<OwnerProvider>().fetchReservations(widget.token);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<OwnerProvider>().fetchReservations(widget.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Selesai'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReservationList(context, null),
          _buildReservationList(context, 'pending'),
          _buildReservationList(context, 'confirmed'),
          _buildReservationList(context, 'completed'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur tambah manual akan segera hadir')),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReservationList(BuildContext context, String? status) {
    return Consumer<OwnerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingReservations && provider.reservations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        var reservationList = provider.reservations;

        // Filter by status
        if (status != null) {
          reservationList = reservationList
              .where((item) => item.status == status)
              .toList();
        }

        if (reservationList.isEmpty) {
          return _buildEmptyState(status);
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          itemCount: reservationList.length +
              (provider.hasMoreReservations ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == reservationList.length) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final reservation = reservationList[index];
            return _buildReservationCard(context, reservation, provider);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String? status) {
    String message;
    if (status == null) {
      message = 'Tidak ada reservasi';
    } else {
      message = 'Tidak ada reservasi dengan status: $status';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(
    BuildContext context,
    dynamic reservation,
    OwnerProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          _showReservationDetail(context, reservation, provider);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.customerName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reservation.tongkronganName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusBadge(reservation.status),
                ],
              ),
              const SizedBox(height: 12),

              // Reservation details
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      Icons.people,
                      '${reservation.guestCount} Orang',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDetailItem(
                      Icons.calendar_today,
                      _formatDate(reservation.reservationDate),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDetailItem(
                      Icons.access_time,
                      reservation.timeSlot,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Price and action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Harga',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rp ${_formatCurrency(reservation.totalPrice)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  _buildActionButtons(context, reservation, provider),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String badgeText;

    switch (status.toLowerCase()) {
      case 'pending':
        badgeColor = Colors.orange;
        badgeText = 'PENDING';
        break;
      case 'confirmed':
        badgeColor = Colors.green;
        badgeText = 'CONFIRMED';
        break;
      case 'completed':
        badgeColor = Colors.blue;
        badgeText = 'SELESAI';
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        badgeText = 'DIBATALKAN';
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = status.toUpperCase();
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

  Widget _buildActionButtons(
    BuildContext context,
    dynamic reservation,
    OwnerProvider provider,
  ) {
    if (reservation.status.toLowerCase() == 'pending') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => _updateReservationStatus(
                context,
                reservation.id,
                'cancelled',
                provider,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              icon: const Icon(Icons.check, size: 18),
              onPressed: () => _updateReservationStatus(
                context,
                reservation.id,
                'confirmed',
                provider,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.1),
              ),
            ),
          ),
        ],
      );
    }

    return IconButton(
      icon: const Icon(Icons.info_outline),
      onPressed: () {
        _showReservationDetail(context, reservation, provider);
      },
    );
  }

  void _updateReservationStatus(
    BuildContext context,
    String reservationId,
    String newStatus,
    OwnerProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text(
            'Ubah status reservasi menjadi ${newStatus.toUpperCase()}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await provider.updateReservationStatus(
                  widget.token,
                  reservationId,
                  newStatus,
                );

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Status berhasil diperbarui'
                            : 'Gagal memperbarui status',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Ubah'),
            ),
          ],
        );
      },
    );
  }

  void _showReservationDetail(
    BuildContext context,
    dynamic reservation,
    OwnerProvider provider,
  ) {
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
                          'Detail Reservasi',
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

                    // Reservation info
                    _buildDetailSection('Informasi Reservasi', [
                      _buildDetailRow('ID Reservasi', reservation.id),
                      _buildDetailRow('Tanggal Reservasi', _formatDate(reservation.reservationDate)),
                      _buildDetailRow('Jam', reservation.timeSlot),
                      _buildDetailRow('Jumlah Orang', '${reservation.guestCount}'),
                      _buildDetailRow('Status', reservation.status.toUpperCase()),
                    ]),
                    const SizedBox(height: 16),

                    // Customer info
                    _buildDetailSection('Informasi Pelanggan', [
                      _buildDetailRow('Nama', reservation.customerName),
                      _buildDetailRow('Email', reservation.customerEmail),
                      _buildDetailRow('No. Telepon', reservation.customerPhone),
                    ]),
                    const SizedBox(height: 16),

                    // Venue info
                    _buildDetailSection('Venue', [
                      _buildDetailRow('Nama Venue', reservation.tongkronganName),
                    ]),
                    const SizedBox(height: 16),

                    // Special request
                    if (reservation.specialRequest.isNotEmpty) ...[
                      const Text(
                        'Permintaan Khusus',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reservation.specialRequest,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Price
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Harga',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp ${_formatCurrency(reservation.totalPrice)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    if (reservation.status.toLowerCase() == 'pending') ...[
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _updateReservationStatus(
                                  context,
                                  reservation.id,
                                  'cancelled',
                                  provider,
                                );
                              },
                              icon: const Icon(Icons.close),
                              label: const Text('Tolak'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _updateReservationStatus(
                                  context,
                                  reservation.id,
                                  'confirmed',
                                  provider,
                                );
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('Terima'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          minimumSize: const Size.fromHeight(44),
                        ),
                        child: const Text('Tutup'),
                      ),
                    ],
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
