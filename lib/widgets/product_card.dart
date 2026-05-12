import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorite_provider.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Product Image ────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  product.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, _) => Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
                ),
              ),

              // Discount badge
              if (product.discountPercentage != null)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.neonRed, Color(0xFFFF6B6B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.neonRed.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '-${product.discountPercentage}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        
                      ),
                    ),
                  ),
                ),

              // Favorite button
              Positioned(
                top: 10,
                right: 10,
                child: Consumer<FavoriteProvider>(
                  builder: (ctx, favoriteProvider, _) {
                    final isFav = favoriteProvider.isFavorite(product);
                    return GestureDetector(
                      onTap: () => favoriteProvider.toggleFavorite(product),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isFav
                              ? AppTheme.neonRed
                              : Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? Colors.white : AppTheme.textLightMuted,
                          size: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // ─── Product Details ──────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category label
                  Text(
                    _getCategoryLabel(product.categoryId),
                    style: TextStyle(
                      color: _getCategoryColor(product.categoryId),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Product name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textLightPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      
                    ),
                  ),
                  const Spacer(),

                  // Time left
                  if (product.timeLeft != null)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.access_time_rounded,
                                  color: AppTheme.accentOrange, size: 10),
                              const SizedBox(width: 2),
                              Text(
                                product.timeLeft!,
                                style: const TextStyle(
                                  color: AppTheme.accentOrange,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),

                  // Price row
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppTheme.textLightPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (product.oldPrice != null)
                        Flexible(
                          child: Text(
                            '\$${product.oldPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppTheme.textLightMuted,
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppTheme.textLightMuted,
                              
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            const Icon(Icons.star_rounded,
                                color: AppTheme.neonYellow, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                color: AppTheme.textLightPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String categoryId) {
    const map = {
      'electronics': AppTheme.primaryBlue,
      "men's clothing": AppTheme.accentTeal,
      "women's clothing": AppTheme.neonPink,
      'jewelery': AppTheme.neonYellow,
      'smartphones': Color(0xFF0984E3),
      'watches': Color(0xFFD35400),
      'shoes': Color(0xFFE91E63),
      'furniture': Color(0xFF8E44AD),
      'beauty': Color(0xFFF06292),
      'toys': Color(0xFFFF9F43),
      'gaming': Color(0xFF2C3E50),
      'accessories': Color(0xFF16A085),
      'sports': Color(0xFF27AE60),
      'groceries': Color(0xFFF39C12),
      'others': AppTheme.primaryPurple,
    };
    return map[categoryId] ?? AppTheme.primaryPurple;
  }

  String _getCategoryLabel(String categoryId) {
    const map = {
      'electronics': 'Electronics',
      "men's clothing": "Men's Fashion",
      "women's clothing": "Women's Fashion",
      'jewelery': 'Jewelery',
      'smartphones': 'Smartphones',
      'watches': 'Watches',
      'shoes': 'Shoes',
      'furniture': 'Furniture',
      'beauty': 'Beauty',
      'toys': 'Toys',
      'gaming': 'Gaming',
      'accessories': 'Accessories',
      'sports': 'Sports',
      'groceries': 'Groceries',
      'others': 'Others',
    };
    return map[categoryId] ?? categoryId;
  }
}