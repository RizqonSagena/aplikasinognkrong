import 'package:flutter/material.dart';
import '../config/admin_colors.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_kedai_screen.dart';
import '../screens/admin/admin_produk_screen.dart';
import '../screens/admin/admin_konten_screen.dart';
import '../screens/admin/admin_reservasi_screen.dart';
import '../screens/admin/admin_chat_screen.dart';
import '../screens/admin/admin_profil_screen.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;

  const AdminBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AdminColors.surface,
      selectedItemColor: AdminColors.primary,
      unselectedItemColor: AdminColors.onSurfaceVariant,
      elevation: 8,
      enableFeedback: true,
      onTap: (index) => _navigateTo(context, index),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.dashboard),
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.storefront),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.storefront),
          ),
          label: 'Kedai',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.local_offer),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_offer),
          ),
          label: 'Produk',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.image),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image),
          ),
          label: 'Konten',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.event),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.event),
          ),
          label: 'Reservasi',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.chat),
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person),
          ),
          label: 'Profil',
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, int index) {
    // Get current route to avoid redundant navigation
    final currentRoute = ModalRoute.of(context)?.settings.name;

    late Widget targetScreen;
    late String routeName;

    switch (index) {
      case 0:
        routeName = '/admin/dashboard';
        targetScreen = const AdminDashboardScreen();
        break;
      case 1:
        routeName = '/admin/kedai';
        targetScreen = const AdminKedaiScreen();
        break;
      case 2:
        routeName = '/admin/produk';
        targetScreen = const AdminProdukScreen();
        break;
      case 3:
        routeName = '/admin/konten';
        targetScreen = const AdminKontenScreen();
        break;
      case 4:
        routeName = '/admin/reservasi';
        targetScreen = const AdminReservasiScreen();
        break;
      case 5:
        routeName = '/admin/chat';
        targetScreen = const AdminChatScreen();
        break;
      case 6:
        routeName = '/admin/profil';
        targetScreen = const AdminProfilScreen();
        break;
      default:
        return;
    }

    // Only navigate if not already on that screen
    if (currentRoute != routeName) {
      Navigator.of(context).pushReplacementNamed(
        routeName,
        arguments: null,
      );
    }
  }
}
