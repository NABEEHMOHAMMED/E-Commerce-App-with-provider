import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF1E1F2A)), // Dark background matching image
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header
            const Text(
              'Categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Grid
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (ctx, productProvider, _) {
                  final categories = productProvider.categories;
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (ctx, index) {
                      return _CategoryGridCard(category: categories[index]);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CategoryGridCard extends StatelessWidget {
  final Category category;

  const _CategoryGridCard({required this.category});

  static const Map<String, IconData> _icons = {
    'electronics': Icons.electrical_services_rounded,
    'clothing': Icons.checkroom_rounded,
    'sports': Icons.sports_tennis_rounded,
    'beauty': Icons.local_drink_rounded,
    'sports2': Icons.sports_football_rounded,
    'beauty2': Icons.local_drink_rounded,
    'backset': Icons.straighten_rounded,
    'others': Icons.menu_book_rounded,
  };

  static const Map<String, Color> _colors = {
    'electronics': Color(0xFF64B5F6),
    'clothing': Color(0xFFE57373),
    'sports': Color(0xFF81C784),
    'beauty': Color(0xFFE57373),
    'sports2': Color(0xFF9575CD),
    'beauty2': Color(0xFFBA68C8),
    'backset': Color(0xFF4DB6AC),
    'others': Color(0xFF90CAF9),
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[category.id] ?? Icons.category_rounded;
    final color = _colors[category.id] ?? Colors.white;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryProductsScreen(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2B36), // Card dark color
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 16),
            Text(
              category.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
