import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';

/// Transparent pricing: selling price, original price and discount.
class PriceTag extends StatelessWidget {
  final Product product;
  final bool large;
  const PriceTag({super.key, required this.product, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text(rupees(product.price),
            style: TextStyle(
                fontSize: large ? 32 : 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.navy)),
        Text(rupees(product.mrp),
            style: TextStyle(
                fontSize: large ? 16 : 12,
                color: AppTheme.muted,
                decoration: TextDecoration.lineThrough)),
        if (large)
          Text('${product.discountPercent}% off',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.success)),
      ],
    );
  }
}
