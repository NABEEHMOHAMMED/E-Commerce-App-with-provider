import 'package:e_commerce_app_with_provider/providers/navigation_provider.dart';
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
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Provider.of<NavigationProvider>(context, listen: false).goHome();
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.bgLightSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textLightPrimary,
              size: 18,
            ),
          ),
        ),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: AppTheme.textLightPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ─── Search Bar ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.bgLightSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: AppTheme.textLightMuted,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search categories...',
                        hintStyle: TextStyle(
                          color: AppTheme.textLightMuted,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── All Categories Header ───────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Categories',
                  style: TextStyle(
                    color: AppTheme.textLightPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Consumer<ProductProvider>(
                    builder: (_, provider, _) {
                      return Text(
                        '${provider.categories.length} items',
                        style: const TextStyle(
                          color: AppTheme.primaryPurple,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ─── Category Grid ───────────────────────────────
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (ctx, productProvider, _) {
                final categories = productProvider.categories;
                if (categories.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryPurple,
                    ),
                  );
                }
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (ctx, index) {
                    return _CategoryCard(category: categories[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;

  const _CategoryCard({required this.category});

  static const Map<String, IconData> _icons = {
    'electronics': Icons.electrical_services_rounded,
    "men's clothing": Icons.checkroom_rounded,
    "women's clothing": Icons.checkroom_rounded,
    'jewelery': Icons.diamond_rounded,
    'sports': Icons.sports_soccer_rounded,
    'furniture': Icons.chair_rounded,
    'beauty': Icons.spa_rounded,
    'accessories': Icons.watch_rounded,
    'toys': Icons.toys_rounded,
    'books': Icons.auto_stories_rounded,
    'food': Icons.restaurant_rounded,
    'health': Icons.local_hospital_rounded,
    'music': Icons.music_note_rounded,
    'tools': Icons.build_rounded,
    'computers': Icons.computer_rounded,
    'automotive': Icons.directions_car_rounded,
    'home': Icons.house_rounded,
    'industrial': Icons.factory_rounded,
    'others': Icons.category_rounded,
  };

  static const Map<String, Color> _colors = {
    'electronics': Color(0xFF6C5CE7),
    "men's clothing": Color(0xFF00BFA6),
    "women's clothing": Color(0xFFFF4B8D),
    'jewelery': Color(0xFFFFC547),
    'sports': Color(0xFF4A7CFF),
    'furniture': Color(0xFFFF9F43),
    'beauty': Color(0xFFE84393),
    'accessories': Color(0xFF00CEC9),
    'toys': Color(0xFFFDCB6E),
    'books': Color(0xFFA29BFE),
    'food': Color(0xFF55EFC4),
    'health': Color(0xFF74B9FF),
    'music': Color(0xFFE17055),
    'tools': Color(0xFF636E72),
    'computers': Color(0xFF0984E3),
    'automotive': Color(0xFFC0392B),
    'home': Color(0xFF2ECC71),
    'industrial': Color(0xFFB2BEC3),
    'others': Color(0xFF6C5CE7),
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[category.id] ?? Icons.category_rounded;
    final color = _colors[category.id] ?? Colors.purple;

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
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppTheme.textLightPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${category.productCount} products',
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
