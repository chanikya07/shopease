import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/product_card.dart';
import '../widgets/store_scaffold.dart';
import '../widgets/trust_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _banner(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(mobile ? 24 : 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
            colors: [AppTheme.navy, Color(0xFF1E3A8A)]),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(6)),
                  child: const Text('FREE DELIVERY ABOVE \u20B9999',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 14),
                Text('Quality products,\nhonest prices.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: mobile ? 26 : 40,
                        height: 1.15,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                const Text('Transparent pricing  \u2022  7-day returns  \u2022  Secure checkout',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          if (!mobile)
            const Icon(Icons.shopping_bag_outlined,
                size: 130, color: Colors.white24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<ProductProvider>();
    final products = pp.filtered;
    final title = pp.category == 'All' ? 'All Products' : pp.category;

    return StoreScaffold(
      crumbs: [
        Crumb('Home', pp.category == 'All' ? null : () => pp.setCategory('All')),
        if (pp.category != 'All') Crumb(pp.category),
      ],
      children: [
        _banner(context),
        const SizedBox(height: 20),
        const TrustStrip(),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: Text('$title (${products.length})',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800)),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<SortOption>(
                value: pp.sort,
                borderRadius: BorderRadius.circular(10),
                items: [
                  for (final s in SortOption.values)
                    DropdownMenuItem(value: s, child: Text(s.label)),
                ],
                onChanged: (v) => pp.setSort(v!),
              ),
            ),
          ],
        ),
        if (pp.query.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: InputChip(
              label: Text('Results for "${pp.query}"'),
              onDeleted: () => pp.setQuery(''),
            ),
          ),
        const SizedBox(height: 16),
        if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 64, color: AppTheme.muted),
                  SizedBox(height: 8),
                  Text('No products found. Try a different search.'),
                ],
              ),
            ),
          )
        else
          LayoutBuilder(builder: (context, c) {
            final cols = Responsive.gridColumns(c.maxWidth);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisExtent: 360,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: products.length,
              itemBuilder: (context, i) => ProductCard(
                  key: ValueKey(products[i].id), product: products[i], index: i),
            );
          }),
      ],
    );
  }
}
