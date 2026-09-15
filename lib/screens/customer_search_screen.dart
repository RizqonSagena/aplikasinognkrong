import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/customer_provider.dart';
import '../models/tongkrongan.dart';
import '../widgets/tongkrongan_card.dart';
import '../widgets/loading_shimmer.dart';
import 'customer_detail_screen.dart';

/// Search & Filter screen untuk tongkrongan
class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Filter states
  String? _selectedCity;
  String? _selectedCategory;
  double? _minRating;
  double? _maxDistance = 10.0; // Default 10 km
  double? _selectedRadius;
  String? _priceRange;
  bool _onlyOpen = false;
  bool _sortByDistance = true; // Default sort by distance
  List<String> _selectedAmenities = [];

  // Data
  final List<String> cities = ['Jakarta', 'Bandung', 'Surabaya', 'Yogyakarta'];
  final List<String> categories = ['Semua', 'Cafe&Pastry', 'Kedai', 'Oleh-oleh', 'Tempat Viral'];
  final List<String> priceRanges = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];
  final List<String> amenities = [
    'WiFi',
    'Parking',
    'AC',
    'Outdoor',
    'Pet Friendly',
    'Smoking Area',
  ];
  final List<double> radiusOptions = [1.0, 2.5, 5.0, 10.0, 15.0, 20.0, 30.0];

  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadInitialSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialSearch() {
    final provider = context.read<CustomerProvider>();
    provider.fetchTongkrongan();
  }

  void _performSearch() {
    final query = _searchController.text;
    final provider = context.read<CustomerProvider>();

    if (query.isEmpty) {
      provider.fetchTongkrongan(
        city: _selectedCity,
        category: _selectedCategory,
      );
    } else {
      provider.searchTongkrongan(query);
    }
    
    // Apply filters to the list locally
    List<Tongkrongan> filtered = List.from(provider.tongkronganList);
    
    // Sort results by distance if enabled
    if (_sortByDistance && filtered.isNotEmpty) {
      filtered.sort((a, b) => a.distance.compareTo(b.distance));
    }
    
    // Filter by radius
    if (_maxDistance != null && filtered.isNotEmpty) {
      filtered = filtered
          .where((t) => t.distance <= _maxDistance!)
          .toList();
    }
    
    // Note: These filters are applied locally for UI display
    // In production, you would pass these to the API
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCity = null;
      _selectedCategory = null;
      _minRating = null;
      _maxDistance = 10.0;
      _selectedRadius = null;
      _priceRange = null;
      _onlyOpen = false;
      _selectedAmenities.clear();
      _sortByDistance = true;
    });
    _loadInitialSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
        centerTitle: true,
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Field
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari tongkrongan...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _performSearch(),
                    ),
                    const SizedBox(height: 12),
                    // Search and Filter Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.search),
                            label: const Text('Cari'),
                            onPressed: _performSearch,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.filter_list),
                          label: Text(_showFilters ? 'Tutup' : 'Filter'),
                          onPressed: () {
                            setState(() => _showFilters = !_showFilters);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Filter Panel
              if (_showFilters)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // City Filter
                        _FilterSection(
                          title: 'Kota',
                          child: Wrap(
                            spacing: 8,
                            children: cities.map((city) {
                              return FilterChip(
                                label: Text(city),
                                selected: _selectedCity == city,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCity = selected ? city : null;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Category Filter
                        _FilterSection(
                          title: 'Kategori',
                          child: Wrap(
                            spacing: 8,
                            children: categories.map((category) {
                              return FilterChip(
                                label: Text(category),
                                selected: _selectedCategory == category,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = selected ? category : null;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Price Range Filter
                        _FilterSection(
                          title: 'Rentang Harga',
                          child: Wrap(
                            spacing: 8,
                            children: priceRanges.map((range) {
                              return FilterChip(
                                label: Text(range),
                                selected: _priceRange == range,
                                onSelected: (selected) {
                                  setState(() {
                                    _priceRange = selected ? range : null;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Min Rating Filter
                        _FilterSection(
                          title: 'Rating Minimal: ${_minRating?.toStringAsFixed(1) ?? "Semua"}',
                          child: Slider(
                            value: _minRating ?? 0,
                            min: 0,
                            max: 5,
                            divisions: 10,
                            label: _minRating?.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() => _minRating = value);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Radius/Distance Filter - Quick Select
                        _FilterSection(
                          title: 'Radius Pencarian',
                          child: Wrap(
                            spacing: 8,
                            children: radiusOptions.map((radius) {
                              return FilterChip(
                                label: Text('${radius.toStringAsFixed(1)} km'),
                                selected: _maxDistance == radius,
                                onSelected: (selected) {
                                  setState(() {
                                    _maxDistance = selected ? radius : 10.0;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Sort Option
                        _FilterSection(
                          title: 'Urutan Hasil',
                          child: Column(
                            children: [
                              CheckboxListTile(
                                title: const Text('Terdekat dulu (sorting by distance)'),
                                subtitle: const Text('Dari radius terdekat ke terjauh'),
                                value: _sortByDistance,
                                onChanged: (value) {
                                  setState(() => _sortByDistance = value ?? true);
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Only Open Filter
                        _FilterSection(
                          title: 'Status',
                          child: CheckboxListTile(
                            title: const Text('Hanya tampilkan yang sedang buka'),
                            value: _onlyOpen,
                            onChanged: (value) {
                              setState(() => _onlyOpen = value ?? false);
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Amenities Filter
                        _FilterSection(
                          title: 'Fasilitas',
                          child: Wrap(
                            spacing: 8,
                            children: amenities.map((amenity) {
                              return FilterChip(
                                label: Text(amenity),
                                selected: _selectedAmenities.contains(amenity),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedAmenities.add(amenity);
                                    } else {
                                      _selectedAmenities.remove(amenity);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.clear),
                                label: const Text('Hapus Filter'),
                                onPressed: _clearFilters,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.check),
                                label: const Text('Terapkan'),
                                onPressed: () {
                                  _performSearch();
                                  setState(() => _showFilters = false);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              // Results
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Error State
                      if (provider.tongkronganError != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Error',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  provider.tongkronganError ?? 'Unknown error',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Loading State
                      if (provider.isLoadingTongkrongan)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) => const SkeletonCard(),
                          ),
                        ),
                      // Empty State
                      if (provider.tongkronganList.isEmpty &&
                          !provider.isLoadingTongkrongan &&
                          provider.tongkronganError == null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada hasil',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Coba ubah filter atau keyword pencarian',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Results Grid
                      if (provider.tongkronganList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hasil: ${provider.tongkronganList.length} tongkrongan',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: provider.tongkronganList.length,
                                itemBuilder: (context, index) {
                                  final tongkrongan =
                                      provider.tongkronganList[index];
                                  final isFav = provider
                                      .isFavorite(tongkrongan.id);

                                  return TongkronganCard(
                                    tongkrongan: tongkrongan,
                                    isFavorite: isFav,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerDetailScreen(
                                                tongkrongan: tongkrongan,
                                              ),
                                        ),
                                      );
                                    },
                                    onFavoriteTap: () {
                                      // TODO: Toggle favorite with token
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Filter Section Widget
class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
