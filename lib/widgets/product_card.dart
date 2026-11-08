import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import 'product_image.dart';
import 'star_rating.dart';

/// Reusable, minimalist catalog card (custom widget).
class ProductCard extends StatelessWidget {
  final Product product;
  final int index;
  const ProductCard({super.key, required this.product, this.index = 0});

  @override
  Widget build(BuildContext context) {
    // Staggered fade + slide-up entrance animation.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + index * 70),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)), child: child),
      ),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppTheme.border),
        ),
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, '/detail', arguments: product),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: 'product-${product.id}',
                          child: ProductImage(product: product),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: AppTheme.accent,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text('-${product.discountPercent}%',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(product.brand.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.6,
                        color: AppTheme.muted)),
                Text(product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                StarRating(
                    rating: product.rating,
                    size: 14,
                    count: product.reviewCount),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(rupees(product.price),
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.navy)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(rupees(product.mrp),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.muted,
                              decoration: TextDecoration.lineThrough)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<CartProvider>().add(product);
                      showAdded(context, '${product.name} added to cart');
                    },
                    child: const Text('Add to Cart',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
