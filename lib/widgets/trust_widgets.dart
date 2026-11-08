import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Trust {
  final IconData icon;
  final String title;
  final String sub;
  const _Trust(this.icon, this.title, this.sub);
}

/// Four reassurance tiles: delivery, returns, payments, support.
class TrustStrip extends StatelessWidget {
  const TrustStrip({super.key});

  static const _items = [
    _Trust(Icons.local_shipping_outlined, 'Free Delivery', 'On orders \u20B9999+'),
    _Trust(Icons.assignment_return_outlined, '7-Day Returns', 'Easy pickup'),
    _Trust(Icons.verified_user_outlined, 'Secure Payments', 'SSL encrypted'),
    _Trust(Icons.support_agent, '24x7 Support', 'Always here to help'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 800 ? 4 : 2;
      const gap = 12.0;
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final t in _items)
            SizedBox(
              width: w,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTheme.border),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Icon(t.icon, color: AppTheme.accent, size: 26),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(t.sub,
                              style: const TextStyle(
                                  color: AppTheme.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

/// Small "secure checkout" badges.
class SecureBadges extends StatelessWidget {
  const SecureBadges({super.key});

  Widget _badge(IconData icon, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: AppTheme.success),
            const SizedBox(width: 6),
            Text(text,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _badge(Icons.lock, '256-bit SSL Secure'),
        _badge(Icons.verified_user, 'Safe Payments'),
        _badge(Icons.assignment_return, '7-Day Returns'),
      ],
    );
  }
}
