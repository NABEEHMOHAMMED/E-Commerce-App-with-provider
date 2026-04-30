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
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── صورة المنتج ───────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  product.imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 100,
                    color: AppTheme.bgLightSurface,
                    child: Icon(Icons.image_not_supported,
                        color: AppTheme.textLightMuted, size: 40),
                  ),
                ),
              ),

              // بادج الخصم (أعلى اليسار)
              if (product.discountPercentage != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.neonRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '-${product.discountPercentage}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // زر المفضلة (أعلى اليمين)
              Positioned(
                top: 8,
                right: 8,
                child: Consumer<FavoriteProvider>(
                  builder: (ctx, favoriteProvider, _) {
                    final isFav = favoriteProvider.isFavorite(product);
                    return GestureDetector(
                      onTap: () => favoriteProvider.toggleFavorite(product),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? AppTheme.neonPink : AppTheme.navInactive,
                          size: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // ─── تفاصيل المنتج ──────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // اسم الفئة (بالأزرق)
                  Text(
                    _getCategoryLabel(product.categoryId),
                    style: const TextStyle(
                      color: AppTheme.blueAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // اسم المنتج
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textLightPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  // الوقت المتبقي (بالبرتقالي)
                  if (product.timeLeft != null)
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            color: AppTheme.orangeAccent, size: 10),
                        const SizedBox(width: 3),
                        Text(
                          product.timeLeft!,
                          style: const TextStyle(
                            color: AppTheme.orangeAccent,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                // السعر الجديد + السعر القديم المشطوب
                Row(
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppTheme.textLightPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    if (product.oldPrice != null)
                      Text(
                        '\$${product.oldPrice!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppTheme.textLightMuted,
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppTheme.textLightMuted,
                        ),
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

  String _getCategoryLabel(String categoryId) {
    const map = {
      'electronics': 'Electronics',
      'clothing': 'Fashion',
      'books': 'Books',
      'sports': 'Sports',
      'furniture': 'Furniture',
      'beauty': 'Perfumes',
      'racket': 'Racket',
      'others': 'Others',
    };
    return map[categoryId] ?? categoryId;
  }
}
