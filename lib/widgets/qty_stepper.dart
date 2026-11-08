import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback? onMinus;
  final VoidCallback onPlus;
  const QtyStepper(
      {super.key, required this.qty, required this.onMinus, required this.onPlus});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onMinus,
              icon: const Icon(Icons.remove, size: 18)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: SizedBox(
              key: ValueKey(qty),
              width: 28,
              child: Text('$qty',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onPlus,
              icon: const Icon(Icons.add, size: 18)),
        ],
      ),
    );
  }
}
