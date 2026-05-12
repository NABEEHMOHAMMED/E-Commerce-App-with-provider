// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../providers/navigation_provider.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'categories_screen.dart';
import 'profile_screen.dart';
import 'product_detail_screen.dart';
import 'all_products_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Widget> _screens = const [
    MainHomeScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        final selectedIndex = navProvider.selectedIndex;
        
        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          body: _screens[selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(context, navProvider, 0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                    _buildNavItem(context, navProvider, 1, Icons.grid_view_rounded, Icons.grid_view_outlined, 'Categories'),
                    _buildNavItem(context, navProvider, 2, Icons.favorite_rounded, Icons.favorite_border_rounded, 'Favorites'),
                    _buildCartNavItem(context, navProvider),
                    _buildNavItem(context, navProvider, 4, Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, NavigationProvider nav, int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = nav.selectedIndex == index;
    return GestureDetector(
      onTap: () => nav.setSelectedIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFEBE6) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? Colors.black87 : AppTheme.navInactive,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black87 : AppTheme.navInactive,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartNavItem(BuildContext context, NavigationProvider nav) {
    final isSelected = nav.selectedIndex == 3;
    return GestureDetector(
      onTap: () => nav.setSelectedIndex(3),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFEBE6) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
                  color: isSelected ? Colors.black87 : AppTheme.navInactive,
                  size: 24,
                ),
                const SizedBox(height: 3),
                const Text(
                  'Cart',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Consumer<CartProvider>(
            builder: (ctx, cart, _) {
              if (cart.itemCount == 0) return const SizedBox.shrink();
              return Positioned(
                right: 4,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.neonRed,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${cart.itemCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Main Home Content ────────────────────────────────────────────────────────

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ProductProvider>(
        builder: (ctx, productProvider, _) {
          // Build status banner if needed
          final showStatusBanner = productProvider.errorMessage != null &&
              productProvider.allProducts.isNotEmpty;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Status Banner ───────────────────────────────────────
              if (showStatusBanner)
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.orangeAccent.withValues(alpha: 0.9), AppTheme.neonRed.withValues(alpha: 0.9)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.orangeAccent.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          productProvider.isConnected
                              ? Icons.warning_rounded
                              : Icons.wifi_off_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            productProvider.errorMessage ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ─── Loading State ───────────────────────────────────────
              if (productProvider.isLoading && productProvider.allProducts.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 400,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.orangeAccent,
                      ),
                    ),
                  ),
                ),

              // ─── Empty State ─────────────────────────────────────────
              if (!productProvider.isLoading && productProvider.allProducts.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 400,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            productProvider.errorMessage ?? 'No products found.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => productProvider.fetchProducts(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // ─── Products Found ──────────────────────────────────────
              if (productProvider.allProducts.isNotEmpty) ...[
                // ─── Header ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today Deals',
                              style: TextStyle(
                                color: AppTheme.textLightPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Items opened for today only',
                              style: TextStyle(
                                color: AppTheme.textLightMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AllProductsScreen(
                                  title: 'Today Deals',
                                  products: productProvider.allProducts,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              color: AppTheme.orangeAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Today Deals (Horizontal scroll) ─────────────
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 260,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      itemCount: productProvider.allProducts.take(5).length,
                      itemBuilder: (ctx, i) {
                        final product = productProvider.allProducts[i];
                        return Padding(
                          padding: EdgeInsets.only(right: i < 4 ? 12 : 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            child: ProductCard(product: product),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ─── Trending Header ─────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Trending',
                              style: TextStyle(
                                color: AppTheme.textLightPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Most loved styles and gadgets right now',
                              style: TextStyle(
                                color: AppTheme.textLightMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AllProductsScreen(
                                  title: 'Trending',
                                  products: productProvider.allProducts.reversed.toList(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              color: AppTheme.orangeAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Trending (Horizontal scroll) ─────────────────
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 260,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      itemCount: productProvider.allProducts.skip(5).take(5).length,
                      itemBuilder: (ctx, i) {
                        final product = productProvider.allProducts[i + 5];
                        return Padding(
                          padding: EdgeInsets.only(right: i < 4 ? 12 : 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            child: ProductCard(product: product),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ],
          );
        },
      ),
    );
  }
}
