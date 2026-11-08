import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/cta_buttons.dart';
import '../widgets/store_scaffold.dart';

class OrderSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> args;
  const OrderSuccessScreen({super.key, required this.args});

  Widget _row(String l, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l, style: const TextStyle(color: AppTheme.muted)),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return StoreScaffold(
      minimal: true,
      children: [
        const SizedBox(height: 24),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, v, child) =>
                      Transform.scale(scale: v, child: child),
                  child: const Icon(Icons.check_circle,
                      size: 110, color: AppTheme.success),
                ),
                const SizedBox(height: 12),
                const Text('Order placed successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                    'Thank you, ${args['name']}. A confirmation will be sent to ${args['email']}.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.muted)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    children: [
                      _row('Order ID', '${args['orderId']}'),
                      _row('Items', '${args['items']}'),
                      _row('Payment', '${args['payment']}'),
                      _row('Checkout type',
                          args['guest'] == true ? 'Guest' : 'Account'),
                      _row('Estimated delivery', formatDate(deliveryDate())),
                      const Divider(height: 24),
                      _row('Amount', rupees(args['total'] as double)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 260,
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
}
