import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/customer_provider.dart';
import '../models/booking.dart';

/// User Profile screen untuk customer
class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditingProfile = false;
  bool _isUpdatingProfile = false;

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();

    // Load user profile
    Future.delayed(Duration.zero, () {
      final provider = context.read<CustomerProvider>();
      if (provider.currentUser != null) {
        _populateFormFields(provider.currentUser!);
      }
      // TODO: Fetch with token
      // provider.fetchUserProfile(token: 'YOUR_TOKEN');
    });
  }

  void _populateFormFields(dynamic user) {
    _nameController.text = user.name ?? '';
    _phoneController.text = user.phone ?? '';
    _bioController.text = user.bio ?? '';
    _addressController.text = user.address ?? '';
    _cityController.text = user.city ?? '';
  }

  Future<void> _saveProfile() async {
    setState(() => _isUpdatingProfile = true);

    try {
      final provider = context.read<CustomerProvider>();
      await provider.updateUserProfile(
        token: 'YOUR_TOKEN_HERE', // TODO: Get from auth provider
        name: _nameController.text,
        phone: _phoneController.text,
        bio: _bioController.text,
        address: _addressController.text,
        city: _cityController.text,
      );

      if (mounted) {
        setState(() => _isEditingProfile = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isUpdatingProfile = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        actions: [
          if (!_isEditingProfile)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditingProfile = true),
            ),
        ],
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, _) {
          final user = provider.currentUser;

          if (provider.isLoadingUser) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Data profil tidak tersedia',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(user.avatar),
                          ),
                          if (_isEditingProfile)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // User Info
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatCard(
                            label: 'Booking',
                            value: user.totalBookings.toString(),
                          ),
                          _StatCard(
                            label: 'Review',
                            value: user.totalReviews.toString(),
                          ),
                          _StatCard(
                            label: 'Rating',
                            value: user.averageRating.toStringAsFixed(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Tabs
                if (!_isEditingProfile)
                  Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Tentang'),
                          Tab(text: 'Booking'),
                        ],
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // About Tab
                            _AboutTab(user: user),
                            // Bookings Tab
                            _BookingsTab(provider: provider),
                          ],
                        ),
                      ),
                    ],
                  ),
                // Edit Form
                if (_isEditingProfile)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Edit Profil',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _EditFormField(
                          label: 'Nama',
                          controller: _nameController,
                        ),
                        const SizedBox(height: 12),
                        _EditFormField(
                          label: 'Nomor Telepon',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        _EditFormField(
                          label: 'Bio',
                          controller: _bioController,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        _EditFormField(
                          label: 'Alamat',
                          controller: _addressController,
                        ),
                        const SizedBox(height: 12),
                        _EditFormField(
                          label: 'Kota',
                          controller: _cityController,
                        ),
                        const SizedBox(height: 24),
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isUpdatingProfile
                                    ? null
                                    : () =>
                                        setState(() => _isEditingProfile = false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                ),
                                child: const Text(
                                  'Batal',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: _isUpdatingProfile
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Icon(Icons.save),
                                label: Text(
                                  _isUpdatingProfile ? 'Menyimpan...' : 'Simpan',
                                ),
                                onPressed: _isUpdatingProfile ? null : _saveProfile,
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
        },
      ),
    );
  }
}

/// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// About Tab
class _AboutTab extends StatelessWidget {
  final dynamic user;

  const _AboutTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoItem(
          label: 'Email',
          value: user.email,
          icon: Icons.email,
        ),
        const SizedBox(height: 12),
        _InfoItem(
          label: 'Nomor Telepon',
          value: user.phone.isEmpty ? '-' : user.phone,
          icon: Icons.phone,
        ),
        const SizedBox(height: 12),
        _InfoItem(
          label: 'Bio',
          value: user.bio.isEmpty ? '-' : user.bio,
          icon: Icons.description,
        ),
        const SizedBox(height: 12),
        _InfoItem(
          label: 'Alamat',
          value: user.address.isEmpty ? '-' : user.address,
          icon: Icons.location_on,
        ),
        const SizedBox(height: 12),
        _InfoItem(
          label: 'Kota',
          value: user.city.isEmpty ? '-' : user.city,
          icon: Icons.location_city,
        ),
      ],
    );
  }
}

/// Info Item Widget
class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Edit Form Field Widget
class _EditFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  const _EditFormField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Bookings Tab
class _BookingsTab extends StatefulWidget {
  final CustomerProvider provider;

  const _BookingsTab({required this.provider});

  @override
  State<_BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<_BookingsTab> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // TODO: Fetch bookings with token
      // widget.provider.fetchMyBookings(token: 'YOUR_TOKEN');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Status Filter
        Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Semua'),
                  selected: _selectedStatus == null,
                  onSelected: (selected) {
                    setState(() => _selectedStatus = null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Pending'),
                  selected: _selectedStatus == 'pending',
                  onSelected: (selected) {
                    setState(() => _selectedStatus = 'pending');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Confirmed'),
                  selected: _selectedStatus == 'confirmed',
                  onSelected: (selected) {
                    setState(() => _selectedStatus = 'confirmed');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Completed'),
                  selected: _selectedStatus == 'completed',
                  onSelected: (selected) {
                    setState(() => _selectedStatus = 'completed');
                  },
                ),
              ],
            ),
          ),
        ),
        // Bookings List
        Expanded(
          child: widget.provider.bookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada booking',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.provider.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = widget.provider.bookings[index];
                    return _BookingCard(booking: booking);
                  },
                ),
        ),
      ],
    );
  }
}

/// Booking Card Widget
class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.tongkronganName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(booking.statusColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    booking.statusDisplay,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year} - ${booking.bookingTime}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.people, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${booking.numberOfPeople} orang',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
