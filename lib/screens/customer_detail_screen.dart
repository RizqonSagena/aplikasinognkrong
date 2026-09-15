import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tongkrongan.dart';
import '../models/review.dart';
import '../services/customer_provider.dart';
import '../widgets/loading_shimmer.dart';

/// Detail screen untuk tongkrongan
class CustomerDetailScreen extends StatefulWidget {
  final Tongkrongan tongkrongan;

  const CustomerDetailScreen({
    super.key,
    required this.tongkrongan,
  });

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Fetch reviews
    Future.delayed(Duration.zero, () {
      context.read<CustomerProvider>().fetchReviews(widget.tongkrongan.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CustomerProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              // Image Carousel
              SliverAppBar(
                pinned: false,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Main Image
                      PageView.builder(
                        onPageChanged: (index) {
                          setState(() => _currentImageIndex = index);
                        },
                        itemCount: widget.tongkrongan.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.tongkrongan.imageUrls[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      // Image Indicators
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.tongkrongan.imageUrls.length,
                            (index) => Container(
                              height: 8,
                              width: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? Colors.white
                                    : Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Back Button
                      Positioned(
                        top: 16,
                        left: 16,
                        child: SafeArea(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.white,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                      // Favorite Button
                      Positioned(
                        top: 16,
                        right: 16,
                        child: SafeArea(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                provider.isFavorite(widget.tongkrongan.id)
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                // Toggle favorite
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.grey[300],
              ),
              // Title and Basic Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.tongkrongan.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.tongkrongan.isOpen
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    widget.tongkrongan.isOpen
                                        ? 'Sedang Buka'
                                        : 'Sedang Tutup',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Rating
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.tongkrongan.ratingDisplay,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.tongkrongan.reviewCount} reviews',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Info Cards
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _InfoCard(
                              icon: Icons.access_time,
                              label: 'Jam Operasional',
                              value: widget.tongkrongan.operatingHours,
                            ),
                            const SizedBox(width: 12),
                            _InfoCard(
                              icon: Icons.location_on,
                              label: 'Lokasi',
                              value: '${widget.tongkrongan.distance.toStringAsFixed(1)} km',
                            ),
                            const SizedBox(width: 12),
                            _InfoCard(
                              icon: Icons.people,
                              label: 'Kapasitas',
                              value: '${widget.tongkrongan.capacity} orang',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Text(
                        'Tentang',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.tongkrongan.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Amenities
                      if (widget.tongkrongan.amenities.isNotEmpty) ...[
                        Text(
                          'Fasilitas',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.tongkrongan.amenities.map((amenity) {
                            return Chip(
                              label: Text(amenity),
                              avatar: const Icon(Icons.check_circle,
                                  size: 18),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Address
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_city,
                              size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alamat',
                                  style: Theme.of(context)
                                      .textTheme.labelMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.tongkrongan.address}, ${widget.tongkrongan.city}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
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
              ),
              // Tabs
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Review'),
                    Tab(text: 'Gallery'),
                    Tab(text: 'Info'),
                  ],
                ),
              ),
              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Reviews Tab
                    _ReviewsTab(provider: provider),
                    // Gallery Tab
                    _GalleryTab(tongkrongan: widget.tongkrongan),
                    // Info Tab
                    _InfoTab(tongkrongan: widget.tongkrongan),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text('Hubungi'),
                onPressed: () {
                  // TODO: Implement call/message
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Booking'),
                onPressed: () {
                  // TODO: Navigate to booking screen
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Info Card Widget
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reviews Tab
class _ReviewsTab extends StatelessWidget {
  final CustomerProvider provider;

  const _ReviewsTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoadingReviews) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada review',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.reviews.length,
      itemBuilder: (context, index) {
        final review = provider.reviews[index];
        return _ReviewItem(review: review);
      },
    );
  }
}

/// Review Item Widget
class _ReviewItem extends StatelessWidget {
  final Review review;

  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(review.userAvatar),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (index) => Icon(
                                index < review.rating.toInt()
                                    ? Icons.star
                                    : Icons.star_outline,
                                size: 14,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              review.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
              // Title
              Text(
                review.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              // Comment
              Text(
                review.comment,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gallery Tab
class _GalleryTab extends StatelessWidget {
  final Tongkrongan tongkrongan;

  const _GalleryTab({required this.tongkrongan});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: tongkrongan.imageUrls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            tongkrongan.imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

/// Info Tab
class _InfoTab extends StatelessWidget {
  final Tongkrongan tongkrongan;

  const _InfoTab({required this.tongkrongan});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoSection(
          title: 'Lokasi',
          items: {
            'Alamat': '${tongkrongan.address}, ${tongkrongan.city}',
            'Jarak': '${tongkrongan.distance.toStringAsFixed(1)} km',
          },
        ),
        const SizedBox(height: 16),
        _InfoSection(
          title: 'Operasional',
          items: {
            'Jam Buka': tongkrongan.operatingHours,
            'Status': tongkrongan.isOpen ? 'Buka' : 'Tutup',
          },
        ),
        const SizedBox(height: 16),
        _InfoSection(
          title: 'Kapasitas & Harga',
          items: {
            'Kapasitas': '${tongkrongan.capacity} orang',
            'Rentang Harga': tongkrongan.priceRange,
          },
        ),
      ],
    );
  }
}

/// Info Section Widget
class _InfoSection extends StatelessWidget {
  final String title;
  final Map<String, String> items;

  const _InfoSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key, style: TextStyle(color: Colors.grey[600])),
                Text(
                  entry.value,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
