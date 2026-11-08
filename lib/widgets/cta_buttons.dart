import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Secondary call-to-action: dark navy.
class AddToCartButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const AddToCartButton(
      {super.key, required this.onPressed, this.label = 'Add to Cart'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_shopping_cart, size: 20),
        label: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

/// Primary call-to-action: bright orange, highest contrast on the page.
class BuyNowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  const BuyNowButton(
      {super.key,
      required this.onPressed,
      this.label = 'Buy Now',
      this.icon = Icons.bolt});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
