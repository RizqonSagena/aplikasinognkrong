import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/admin_colors.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_nav.dart';

/// Model untuk Reservasi/Janji Temu
class AdminReservasi {
  final String id;
  final String kedaiId;
  final String kedaiName;
  final String customerName;
  final String customerPhone;
  final DateTime appointmentTime;
  final int numberOfPeople;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final String? specialRequest;
  final DateTime createdAt;
  final String? escalationReason;
  final DateTime? escalatedAt;
  final String? adminNotes;

  const AdminReservasi({
    required this.id,
    required this.kedaiId,
    required this.kedaiName,
    required this.customerName,
    required this.customerPhone,
    required this.appointmentTime,
    required this.numberOfPeople,
    required this.status,
    this.specialRequest,
    required this.createdAt,
    this.escalationReason,
    this.escalatedAt,
    this.adminNotes,
  });

  static List<AdminReservasi> get sampleData => [
        AdminReservasi(
          id: 'RSV-001',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          customerName: 'Budi Santoso',
          customerPhone: '0812-1234-5678',
          appointmentTime:
              DateTime.now().add(const Duration(hours: 3, minutes: 30)),
          numberOfPeople: 4,
          status: 'pending',
          specialRequest: 'Ruangan yang tenang untuk meeting, preferably corner table',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        AdminReservasi(
          id: 'RSV-002',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          customerName: 'Siti Nurhaliza',
          customerPhone: '0821-9876-5432',
          appointmentTime:
              DateTime.now().add(const Duration(days: 1, hours: 2)),
          numberOfPeople: 6,
          status: 'confirmed',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        AdminReservasi(
          id: 'RSV-003',
          kedaiId: 'TNG-8211',
          kedaiName: 'Kala Kopi & Ruang Cerita',
          customerName: 'Ahmad Wijaya',
          customerPhone: '0813-5555-6666',
          appointmentTime:
              DateTime.now().subtract(const Duration(hours: 2)),
          numberOfPeople: 2,
          status: 'completed',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        AdminReservasi(
          id: 'RSV-004',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          customerName: 'Rina Agustina',
          customerPhone: '0814-7777-8888',
          appointmentTime:
              DateTime.now().add(const Duration(hours: 5)),
          numberOfPeople: 3,
          status: 'pending',
          escalationReason: 'Customer mengeluh tentang ketersediaan ruangan',
          escalatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          adminNotes:
              'Hubungi owner untuk konfirmasi ketersediaan ruangan meeting pada jam tersebut',
        ),
      ];
}

class AdminReservasiScreen extends ConsumerStatefulWidget {
  const AdminReservasiScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminReservasiScreen> createState() => _AdminReservasiScreenState();
}

class _AdminReservasiScreenState extends ConsumerState<AdminReservasiScreen> {
  String selectedStatus = 'all';
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    // Using sample data for now (akan diintegrasikan dengan provider nanti)
    final reservasiList = AdminReservasi.sampleData;
    final filteredList = selectedStatus == 'all'
        ? reservasiList
        : reservasiList.where((r) => r.status == selectedStatus).toList();

    return Scaffold(
      appBar: const AdminAppBar(title: 'Janji Temu'),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildStatusFilterChips(),
          ),

          // Reservasi List
          Expanded(
            child: _buildReservasiList(filteredList),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 4),
    );
  }

  Widget _buildStatusFilterChips() {
    final statuses = [
      ('all', 'Semua', null),
      ('pending', 'Pending', Icons.schedule),
      ('confirmed', 'Dikonfirmasi', Icons.check_circle),
      ('completed', 'Selesai', Icons.done_all),
      ('cancelled', 'Dibatalkan', Icons.cancel),
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
                avatar: icon != null ? Icon(icon, size: 14) : null,
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => selectedStatus = value);
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

  Widget _buildReservasiList(List<AdminReservasi> reservasiList) {
    if (reservasiList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event,
              size: 48,
              color: AdminColors.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada reservasi',
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
      itemCount: reservasiList.length,
      itemBuilder: (context, index) => _buildReservasiCard(reservasiList[index]),
    );
  }

  Widget _buildReservasiCard(AdminReservasi reservasi) {
    final dateFormat = DateFormat('EEE, dd MMM yyyy HH:mm', 'id_ID');
    final isUpcoming = reservasi.appointmentTime.isAfter(DateTime.now());
    final isEscalated = reservasi.escalationReason != null;

    return GestureDetector(
      onTap: () => _showReservasiDetail(reservasi),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AdminColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEscalated ? AdminColors.error.withOpacity(0.5) : AdminColors.outlineVariant,
            width: isEscalated ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status & escalation badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isEscalated
                    ? AdminColors.error.withOpacity(0.1)
                    : AdminColors.surfaceContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reservasi.customerName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AdminColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          reservasi.kedaiName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AdminColors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStatusBadge(reservasi.status),
                      if (isEscalated) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AdminColors.error,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning,
                                  size: 10, color: AdminColors.onError),
                              SizedBox(width: 2),
                              Text(
                                'ESKALASI',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AdminColors.onError,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appointment Info
                  _buildInfoRow(
                    icon: Icons.calendar_month,
                    label: 'Jadwal',
                    value: dateFormat.format(reservasi.appointmentTime),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.people,
                    label: 'Jumlah Orang',
                    value: '${reservasi.numberOfPeople} orang',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.phone,
                    label: 'Kontak',
                    value: reservasi.customerPhone,
                  ),

                  // Special Request
                  if (reservasi.specialRequest != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AdminColors.primaryContainer.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.note,
                            size: 12,
                            color: AdminColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              reservasi.specialRequest!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AdminColors.primary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Escalation Info
                  if (isEscalated) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AdminColors.error.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AdminColors.error.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flag,
                                size: 12,
                                color: AdminColors.error,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Alasan Eskalasi: ${reservasi.escalationReason}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AdminColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (reservasi.adminNotes != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Catatan: ${reservasi.adminNotes}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AdminColors.error,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),

                  // Action Buttons
                  if (reservasi.status == 'pending')
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _updateReservasiStatus(
                              reservasi,
                              'confirmed',
                            ),
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Konfirmasi'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              side: const BorderSide(color: AdminColors.tertiary),
                              foregroundColor: AdminColors.tertiary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _updateReservasiStatus(reservasi, 'cancelled'),
                            icon: const Icon(Icons.close, size: 16),
                            label: const Text('Tolak'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              side: const BorderSide(color: AdminColors.error),
                              foregroundColor: AdminColors.error,
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (isEscalated && isUpcoming)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _resolveEscalation(reservasi),
                        icon: const Icon(Icons.check_circle, size: 16),
                        label: const Text('Tandai Terselesaikan'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: AdminColors.tertiary,
                          foregroundColor: AdminColors.onTertiary,
                        ),
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
      case 'confirmed':
        bgColor = AdminColors.tertiaryContainer;
        textColor = AdminColors.onTertiaryContainer;
        label = 'DIKONFIRMASI';
        icon = Icons.check_circle;
        break;
      case 'completed':
        bgColor = AdminColors.surfaceContainer;
        textColor = AdminColors.onSurfaceVariant;
        label = 'SELESAI';
        icon = Icons.done_all;
        break;
      case 'cancelled':
        bgColor = AdminColors.errorContainer;
        textColor = AdminColors.onErrorContainer;
        label = 'DIBATALKAN';
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AdminColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
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

  void _updateReservasiStatus(AdminReservasi reservasi, String newStatus) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reservasi dari ${reservasi.customerName} diubah menjadi $newStatus',
        ),
      ),
    );
    setState(() {});
  }

  void _resolveEscalation(AdminReservasi reservasi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tandai Eskalasi Terselesaikan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reservasi: ${reservasi.customerName} - ${reservasi.kedaiName}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AdminColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Catatan Resolusi *',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AdminColors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Jelaskan bagaimana eskalasi ini diselesaikan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
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
                  content: Text(
                    'Eskalasi untuk ${reservasi.customerName} ditandai selesai',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.tertiary,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showReservasiDetail(AdminReservasi reservasi) {
    final dateFormat = DateFormat('EEE, dd MMM yyyy HH:mm', 'id_ID');

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${reservasi.customerName} - ${reservasi.status.toUpperCase()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AdminColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.storefront,
              label: 'Kedai',
              value: reservasi.kedaiName,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.calendar_month,
              label: 'Jadwal',
              value: dateFormat.format(reservasi.appointmentTime),
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.people,
              label: 'Jumlah Orang',
              value: '${reservasi.numberOfPeople} orang',
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Kontak',
              value: reservasi.customerPhone,
            ),
            if (reservasi.specialRequest != null) ...[
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.note,
                label: 'Permintaan Khusus',
                value: reservasi.specialRequest!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
