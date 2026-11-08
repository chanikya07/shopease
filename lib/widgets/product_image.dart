import 'package:flutter/material.dart';
import '../models/product.dart';

/// Shows one "angle" (0 front, 1 side, 2 back, 3 close-up) of a product.
/// Uses real photos when `product.images` is filled, otherwise a coloured
/// placeholder view so the app works without any image assets.
class ProductImage extends StatelessWidget {
  final Product product;
  final int angle;
  final double iconSize;
  final double radius;
  const ProductImage({
    super.key,
    required this.product,
    this.angle = 0,
    this.iconSize = 64,
    this.radius = 12,
  });

  Widget _placeholder() {
    double rotate = 0, sx = 1, sy = 1, scale = 1;
    switch (angle % 4) {
      case 1:
        rotate = -0.35;
        sx = -1;
        break;
      case 2:
        rotate = 0.7;
        sx = -1;
        sy = -1;
        break;
      case 3:
        scale = 2.4;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            product.color.withOpacity(0.55),
            product.color,
          ],
        ),
      ),
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(rotate)
            ..scale(sx * scale, sy * scale),
          child: Icon(product.icon, size: iconSize, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox.expand(
        child: product.images.isNotEmpty
            ? Image.network(
                product.images[angle % product.images.length],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }
}
