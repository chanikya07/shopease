import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import 'cart_badge.dart';
import 'search_field.dart';

class Crumb {
  final String label;
  final VoidCallback? onTap;
  const Crumb(this.label, [this.onTap]);
}

/// Page frame used by every screen: persistent header (logo, search, cart),
/// category navigation, breadcrumbs, content and footer.
/// `minimal: true` gives the distraction-free header used in checkout.
class StoreScaffold extends StatelessWidget {
  final List<Widget> children;
  final List<Crumb> crumbs;
  final bool minimal;
  const StoreScaffold({
    super.key,
    required this.children,
    this.crumbs = const [],
    this.minimal = false,
  });

  @override
  Widget build(BuildContext context) {
    // Rough footer heights, used so short pages still push the footer down.
    final footerHeight = minimal ? 60.0 : 300.0;
    return Scaffold(
      body: Column(
        children: [
          StoreHeader(minimal: minimal),
          Expanded(
            child: LayoutBuilder(builder: (context, viewport) {
              final minContent =
                  (viewport.maxHeight - footerHeight).clamp(0.0, double.infinity);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: minContent),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (crumbs.isNotEmpty) Breadcrumbs(crumbs: crumbs),
                                if (crumbs.isEmpty) const SizedBox(height: 16),
                                ...children,
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    minimal ? const MinimalFooter() : const StoreFooter(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class StoreHeader extends StatelessWidget {
  final bool minimal;
  const StoreHeader({super.key, required this.minimal});

  Widget _logo(BuildContext context) => InkWell(
        onTap: () => goHome(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: AppTheme.navy, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.shopping_bag,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text('ShopEase',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.navy)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final wide = Responsive.width(context) >= 800;

    Widget top;
    if (minimal) {
      top = Row(
        children: [
          _logo(context),
          const Spacer(),
          const Icon(Icons.lock, size: 18, color: AppTheme.success),
          const SizedBox(width: 6),
          const Text('Secure Checkout',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppTheme.success)),
        ],
      );
    } else if (wide) {
      top = Row(
        children: [
          _logo(context),
          const SizedBox(width: 32),
          const Expanded(child: SearchField()),
          const SizedBox(width: 24),
          const CartBadge(),
        ],
      );
    } else {
      top = Column(
        children: [
          Row(children: [_logo(context), const Spacer(), const CartBadge()]),
          const SizedBox(height: 8),
          const SearchField(),
        ],
      );
    }

    return Material(
      color: Colors.white,
      elevation: 2,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: top,
                ),
              ),
            ),
          ),
          if (!minimal) const CategoryBar(),
        ],
      ),
    );
  }
}

class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<ProductProvider>();
    return Container(
      color: AppTheme.navy,
      height: 44,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              for (final c in pp.categories)
                InkWell(
                  onTap: () {
                    pp.setCategory(c);
                    goHome(context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: pp.category == c
                              ? AppTheme.accent
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      c == 'All' ? 'All Products' : c,
                      style: TextStyle(
                        color: pp.category == c ? Colors.white : Colors.white70,
                        fontWeight: pp.category == c
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Breadcrumbs extends StatelessWidget {
  final List<Crumb> crumbs;
  const Breadcrumbs({super.key, required this.crumbs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < crumbs.length; i++) ...[
            if (i > 0)
              const Icon(Icons.chevron_right, size: 16, color: AppTheme.muted),
            InkWell(
              onTap: crumbs[i].onTap,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  crumbs[i].label,
                  style: TextStyle(
                    fontSize: 13,
                    color: i == crumbs.length - 1
                        ? AppTheme.navy
                        : AppTheme.muted,
                    fontWeight: i == crumbs.length - 1
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class StoreFooter extends StatelessWidget {
  const StoreFooter({super.key});

  Widget _col(String title, List<String> lines) => SizedBox(
        width: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 10),
            for (final l in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(l,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.navy,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 48,
                runSpacing: 24,
                children: [
                  _col('Shipping', [
                    'Free delivery above \u20B9999',
                    'Delivered in 3-5 business days',
                    'Track every order',
                  ]),
                  _col('Returns & Refunds', [
                    '7-day easy returns',
                    'Free pickup from your door',
                    'Refund within 3-5 days',
                  ]),
                  _col('Secure Shopping', [
                    '256-bit SSL encryption',
                    'UPI, cards and cash on delivery',
                    'We never store card details',
                  ]),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              const Text('\u00A9 2026 ShopEase. Academic project.',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class MinimalFooter extends StatelessWidget {
  const MinimalFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: const Text(
        '256-bit SSL encrypted  \u2022  7-day easy returns  \u2022  Safe & secure payments',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppTheme.muted, fontSize: 12),
      ),
    );
  }
}
