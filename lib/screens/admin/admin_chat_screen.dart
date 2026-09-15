import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/admin_colors.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_nav.dart';

/// Model untuk Chat/Conversation
class AdminChat {
  final String id;
  final String kedaiId;
  final String kedaiName;
  final String participantName;
  final String participantType; // 'customer', 'owner'
  final String participantPhone;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isEscalated;
  final String? escalationReason;
  final DateTime? escalatedAt;
  final bool isResolved;

  const AdminChat({
    required this.id,
    required this.kedaiId,
    required this.kedaiName,
    required this.participantName,
    required this.participantType,
    required this.participantPhone,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isEscalated,
    this.escalationReason,
    this.escalatedAt,
    required this.isResolved,
  });

  static List<AdminChat> get sampleData => [
        AdminChat(
          id: 'CHT-001',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          participantName: 'Budi Santoso',
          participantType: 'customer',
          participantPhone: '0812-1234-5678',
          lastMessage:
              'Apakah masih ada tempat untuk meeting besok jam 3 sore?',
          lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
          unreadCount: 2,
          isEscalated: false,
          isResolved: false,
        ),
        AdminChat(
          id: 'CHT-002',
          kedaiId: 'TNG-8211',
          kedaiName: 'Kala Kopi & Ruang Cerita',
          participantName: 'Sarah (Pemilik)',
          participantType: 'owner',
          participantPhone: '0821-4567-8901',
          lastMessage: 'Baik, saya sudah update menu terbaru. Terima kasih!',
          lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
          unreadCount: 0,
          isEscalated: false,
          isResolved: true,
        ),
        AdminChat(
          id: 'CHT-003',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          participantName: 'Siti Nurhaliza',
          participantType: 'customer',
          participantPhone: '0821-9876-5432',
          lastMessage:
              'Saya sudah 30 menit menunggu tetapi tempat belum siap!',
          lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
          unreadCount: 4,
          isEscalated: true,
          escalationReason: 'Keluhan tentang keterlambatan persiapan tempat',
          escalatedAt: DateTime.now().subtract(const Duration(minutes: 12)),
          isResolved: false,
        ),
        AdminChat(
          id: 'CHT-004',
          kedaiId: 'TNG-8773',
          kedaiName: 'Kopi Titik Temu Senja',
          participantName: 'Reza Fahmi (Pemilik)',
          participantType: 'owner',
          participantPhone: '0856-1234-5678',
          lastMessage: 'Mohon bantuannya untuk approve menu dan foto produk',
          lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
          unreadCount: 1,
          isEscalated: false,
          isResolved: false,
        ),
        AdminChat(
          id: 'CHT-005',
          kedaiId: 'TNG-8492',
          kedaiName: 'Selasar Kopi & Ruang Diskusi',
          participantName: 'Ahmad Wijaya',
          participantType: 'customer',
          participantPhone: '0813-5555-6666',
          lastMessage: 'Terima kasih, tempat sudah bagus dan nyaman!',
          lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
          unreadCount: 0,
          isEscalated: false,
          isResolved: true,
        ),
      ];
}

class AdminChatScreen extends ConsumerStatefulWidget {
  const AdminChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends ConsumerState<AdminChatScreen> {
  final searchController = TextEditingController();
  String selectedFilter = 'all'; // 'all', 'unread', 'escalated', 'resolved'

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using sample data (akan diintegrasikan dengan provider nanti)
    final allChats = AdminChat.sampleData;

    // Apply filters
    var filteredChats = allChats;

    // Filter by search
    if (searchController.text.isNotEmpty) {
      filteredChats = filteredChats
          .where((chat) =>
              chat.participantName
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              chat.kedaiName
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
          .toList();
    }

    // Filter by status
    switch (selectedFilter) {
      case 'unread':
        filteredChats =
            filteredChats.where((chat) => chat.unreadCount > 0).toList();
        break;
      case 'escalated':
        filteredChats =
            filteredChats.where((chat) => chat.isEscalated).toList();
        break;
      case 'resolved':
        filteredChats =
            filteredChats.where((chat) => chat.isResolved).toList();
        break;
      default:
        break;
    }

    return Scaffold(
      appBar: const AdminAppBar(title: 'Pusat Chat'),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSearchBar(),
          ),

          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildFilterChips(),
          ),
          const SizedBox(height: 12),

          // Chat List
          Expanded(
            child: _buildChatList(filteredChats),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 5),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Cari nama atau kedai...',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AdminColors.onSurfaceVariant,
        ),
        prefixIcon: const Icon(Icons.search, color: AdminColors.onSurfaceVariant),
        suffixIcon: searchController.text.isNotEmpty
            ? GestureDetector(
                onTap: () => setState(() => searchController.clear()),
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
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      ('all', 'Semua', Icons.layers),
      ('unread', 'Belum Dibaca', Icons.mail),
      ('escalated', 'Eskalasi', Icons.warning),
      ('resolved', 'Terselesaikan', Icons.check_circle),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          filters.length,
          (index) {
            final (value, label, icon) = filters[index];
            final isSelected = selectedFilter == value;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Icon(icon, size: 14),
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => selectedFilter = value);
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

  Widget _buildChatList(List<AdminChat> chats) {
    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: AdminColors.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada chat ditemukan',
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
      itemCount: chats.length,
      itemBuilder: (context, index) => _buildChatCard(chats[index]),
    );
  }

  Widget _buildChatCard(AdminChat chat) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yy');
    final now = DateTime.now();
    final isToday = chat.lastMessageTime.day == now.day &&
        chat.lastMessageTime.month == now.month &&
        chat.lastMessageTime.year == now.year;

    final timeString = isToday
        ? timeFormat.format(chat.lastMessageTime)
        : dateFormat.format(chat.lastMessageTime);

    return GestureDetector(
      onTap: () => _openChat(chat),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: chat.unreadCount > 0
              ? AdminColors.primaryContainer.withOpacity(0.15)
              : AdminColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: chat.isEscalated
                ? AdminColors.error.withOpacity(0.5)
                : AdminColors.outlineVariant,
            width: chat.isEscalated ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: chat.participantType == 'owner'
                    ? AdminColors.secondary.withOpacity(0.2)
                    : AdminColors.tertiary.withOpacity(0.2),
              ),
              child: Center(
                child: Icon(
                  chat.participantType == 'owner'
                      ? Icons.storefront
                      : Icons.person,
                  size: 24,
                  color: chat.participantType == 'owner'
                      ? AdminColors.secondary
                      : AdminColors.tertiary,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with name & badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    chat.participantName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: chat.unreadCount > 0
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: AdminColors.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (chat.participantType == 'owner')
                                  Container(
                                    margin: const EdgeInsets.only(left: 6),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AdminColors.secondary
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: const Text(
                                      'Owner',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: AdminColors.secondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              chat.kedaiName,
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
                          Text(
                            timeString,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: chat.unreadCount > 0
                                  ? AdminColors.primary
                                  : AdminColors.outline,
                            ),
                          ),
                          if (chat.unreadCount > 0) ...[
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AdminColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${chat.unreadCount}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AdminColors.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Last message
                  Text(
                    chat.lastMessage,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: chat.unreadCount > 0
                          ? AdminColors.onSurface
                          : AdminColors.onSurfaceVariant,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Status badges
                  Row(
                    children: [
                      if (chat.isEscalated)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AdminColors.error.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: AdminColors.error.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning,
                                size: 10,
                                color: AdminColors.error,
                              ),
                              const SizedBox(width: 2),
                              const Text(
                                'ESKALASI',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AdminColors.error,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (chat.isResolved)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AdminColors.tertiary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 10,
                                color: AdminColors.tertiary,
                              ),
                              const SizedBox(width: 2),
                              const Text(
                                'TERSELESAIKAN',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AdminColors.tertiary,
                                ),
                              ),
                            ],
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

  void _openChat(AdminChat chat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AdminColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AdminColors.surfaceContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.participantName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AdminColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              chat.kedaiName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AdminColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  if (chat.isEscalated)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag,
                            size: 12,
                            color: AdminColors.error,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Eskalasi: ${chat.escalationReason}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AdminColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Chat messages area (placeholder)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AdminColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 40,
                            color: AdminColors.onSurfaceVariant,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Chat history loaded from backend',
                            style: TextStyle(
                              fontSize: 12,
                              color: AdminColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (chat.isEscalated && !chat.isResolved)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Eskalasi dari ${chat.participantName} ditandai terselesaikan',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Tandai Eskalasi Terselesaikan'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AdminColors.tertiary,
                          foregroundColor: AdminColors.onTertiary,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Escalate to owner
                          _escalateToOwner(chat);
                        },
                        icon: const Icon(Icons.escalator_warning),
                        label: const Text('Eskalasi ke Pemilik'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AdminColors.secondary,
                          foregroundColor: AdminColors.onSecondary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Tutup'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AdminColors.outline),
                        foregroundColor: AdminColors.outline,
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

  void _escalateToOwner(AdminChat chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eskalasi ke Pemilik'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat: ${chat.participantName} - ${chat.kedaiName}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AdminColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Alasan Eskalasi *',
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
                hintText: 'Jelaskan mengapa perlu dieskalasikin ke pemilik...',
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Chat dari ${chat.participantName} dieskalasikin ke pemilik ${chat.kedaiName}',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.error,
            ),
            child: const Text('Eskalasi'),
          ),
        ],
      ),
    );
  }
}
