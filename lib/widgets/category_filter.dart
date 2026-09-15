import 'package:flutter/material.dart';

/// Widget untuk filter kategori
class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const CategoryFilter({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // All categories button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: selectedCategory == null,
              label: const Text('Semua'),
              onSelected: (selected) {
                onCategoryChanged(null);
              },
            ),
          ),
          // Category chips
          ...categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: selectedCategory == category,
                label: Text(category),
                onSelected: (selected) {
                  onCategoryChanged(selected ? category : null);
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
