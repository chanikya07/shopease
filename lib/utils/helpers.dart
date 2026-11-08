import 'package:flutter/material.dart';

String rupees(num value) {
  final s = value.toStringAsFixed(0);
  final withCommas =
      s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  return '\u20B9$withCommas';
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

DateTime deliveryDate() => DateTime.now().add(const Duration(days: 5));

/// Goes back to the home (catalog) screen.
void goHome(BuildContext c) => Navigator.popUntil(c, (r) => r.isFirst);

void showAdded(BuildContext context, String message, {bool viewCart = true}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: viewCart
          ? SnackBarAction(
              label: 'VIEW CART',
              textColor: Colors.white,
              onPressed: () => Navigator.pushNamed(context, '/cart'))
          : null,
    ));
}

class Responsive {
  static double width(BuildContext c) => MediaQuery.of(c).size.width;
  static bool isMobile(BuildContext c) => width(c) < 600;
  static bool isTablet(BuildContext c) => width(c) >= 600 && width(c) < 1000;
  static bool isDesktop(BuildContext c) => width(c) >= 1000;

  /// Number of product columns for a given available width.
  static int gridColumns(double w) {
    if (w < 560) return 2;
    if (w < 860) return 3;
    return 4;
  }
}
