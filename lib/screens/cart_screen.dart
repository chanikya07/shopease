import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/cta_buttons.dart';
import '../widgets/order_summary.dart';
import '../widgets/product_image.dart';
import '../widgets/qty_stepper.dart';
import '../widgets/store_scaffold.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Widget _itemTile(BuildContext context, CartItem item) {
    final cart = context.read<CartProvider>();
    final p = item.product;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/detail', arguments: p),
            child: SizedBox(
              width: 88,
              height: 88,
              child: ProductImage(product: p, iconSize: 40),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(p.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    IconButton(
                      tooltip: 'Remove',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => cart.remove(p.id),
                      icon: const Icon(Icons.delete_outline,
                          color: AppTheme.muted),
                    ),
                  ],
                ),
                Text(p.brand, style: const TextStyle(color: AppTheme.muted)),
                const SizedBox(height: 4),
                Row(children: [
                  Text(rupees(p.price),
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Text(rupees(p.mrp),
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.muted,
                          decoration: TextDecoration.lineThrough)),
                  const SizedBox(width: 8),
                  Text('${p.discountPercent}% off',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.success,
                          fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 10),
                Row(
                  children: [
                    QtyStepper(
                      qty: item.quantity,
                      onMinus: () => cart.decrement(p.id),
                      onPlus: () => cart.increment(p.id),
                    ),
                    const Spacer(),
                    Text(rupees(item.total),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    final crumbs = [Crumb('Home', () => goHome(context)), const Crumb('Cart')];

    if (cart.isEmpty) {
      return StoreScaffold(
        crumbs: crumbs,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 80, color: AppTheme.muted),
                  const SizedBox(height: 12),
                  const Text('Your cart is empty',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Add something you like to get started.',
                      style: TextStyle(color: AppTheme.muted)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 240,
                    child: BuyNowButton(
                      label: 'Continue Shopping',
                      icon: Icons.storefront,
                      onPressed: () => goHome(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final summary = OrderSummary(
      ctaLabel: 'Proceed to Checkout',
      onCta: () => Navigator.pushNamed(context, '/checkout'),
    );

    return StoreScaffold(
      crumbs: crumbs,
      children: [
        Text('Shopping Cart (${cart.totalItems} items)',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final list = Column(
              children: [for (final i in cart.items) _itemTile(context, i)]);
          if (c.maxWidth >= 860) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: list),
                const SizedBox(width: 24),
                SizedBox(width: 360, child: summary),
              ],
            );
          }
          return Column(children: [list, const SizedBox(height: 8), summary]);
        }),
      ],
    );
  }
}
