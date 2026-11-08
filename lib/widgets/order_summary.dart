import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import 'cta_buttons.dart';
import 'trust_widgets.dart';

/// Transparent price breakdown used on the cart and checkout screens.
class OrderSummary extends StatelessWidget {
  final bool showItems;
  final String? ctaLabel;
  final VoidCallback? onCta;
  const OrderSummary(
      {super.key, this.showItems = false, this.ctaLabel, this.onCta});

  Widget _row(String l, String v,
      {Color? color, bool bold = false, double size = 14}) {
    final style = TextStyle(
        fontSize: size,
        color: color,
        fontWeight: bold ? FontWeight.w800 : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(l, style: style), Text(v, style: style)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(showItems ? 'Order Summary' : 'Price Details',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const Divider(height: 24),
          if (showItems) ...[
            for (final i in cart.items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: i.product.color,
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(i.product.icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('${i.product.name} x ${i.quantity}',
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Text(rupees(i.total),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            const Divider(height: 24),
          ],
          _row('Price (${cart.totalItems} items)', rupees(cart.mrpTotal)),
          _row('Discount', '- ${rupees(cart.savings)}', color: AppTheme.success),
          _row('Delivery', cart.delivery == 0 ? 'FREE' : rupees(cart.delivery),
              color: cart.delivery == 0 ? AppTheme.success : null),
          const Divider(height: 24),
          _row('Total Amount', rupees(cart.grandTotal), bold: true, size: 18),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.savings_outlined,
                    size: 18, color: AppTheme.success),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('You will save ${rupees(cart.savings)} on this order',
                      style: const TextStyle(
                          color: AppTheme.success, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          if (ctaLabel != null) ...[
            const SizedBox(height: 16),
            BuyNowButton(
              label: ctaLabel!,
              icon: Icons.lock_outline,
              onPressed: cart.isEmpty ? null : onCta,
            ),
          ],
          const SizedBox(height: 16),
          const SecureBadges(),
        ],
      ),
    );
  }
}
