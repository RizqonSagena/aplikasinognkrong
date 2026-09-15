import 'package:flutter/material.dart';
import 'owner_dashboard_screen.dart';
import 'owner_manage_tongkrongan_screen.dart';
import 'owner_reservations_screen.dart';
import 'owner_analytics_screen.dart';
import 'owner_profile_screen.dart';

/// Home screen untuk Owner/Tenant - Tongkrongan Mitra Shell
class OwnerHomeScreen extends StatefulWidget {
  final String token;

  const OwnerHomeScreen({
    super.key,
    required this.token,
  });

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  int _selectedIndex = 0;
  late String _token;

  @override
  void initState() {
    super.initState();
    _token = widget.token;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const OwnerDashboardScreen(),
      OwnerManageTongkronganScreen(token: _token),
      OwnerReservationsScreen(token: _token),
      OwnerAnalyticsScreen(token: _token),
      OwnerProfileScreen(token: _token),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Venue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analitik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
