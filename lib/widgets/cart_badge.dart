import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

/// Cart icon with an item count that "pops" every time the count changes.
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CartProvider>().totalItems;
    return TweenAnimationBuilder<double>(
      key: ValueKey(count),
      tween: Tween(begin: 1.4, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.elasticOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: IconButton(
        tooltip: 'Cart',
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        icon: Badge(
          isLabelVisible: count > 0,
          label: Text('$count'),
          child: const Icon(Icons.shopping_cart_outlined, size: 28),
        ),
      ),
    );
  }
}
