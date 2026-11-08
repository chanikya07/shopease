import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';

/// Persistent search bar with auto-suggest (Flutter's Autocomplete widget).
class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<ProductProvider>();

    return LayoutBuilder(builder: (context, c) {
      final width = c.maxWidth;
      return Autocomplete<Product>(
        key: ValueKey('search-${pp.query}'),
        initialValue: TextEditingValue(text: pp.query),
        displayStringForOption: (p) => p.name,
        optionsBuilder: (TextEditingValue v) {
          final q = v.text.trim().toLowerCase();
          if (q.isEmpty) return const Iterable<Product>.empty();
          return sampleProducts
              .where((p) =>
                  p.name.toLowerCase().contains(q) ||
                  p.brand.toLowerCase().contains(q) ||
                  p.category.toLowerCase().contains(q))
              .take(5);
        },
        onSelected: (p) =>
            Navigator.pushNamed(context, '/detail', arguments: p),
        fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
          void runSearch() {
            pp.setQuery(controller.text);
            goHome(context);
          }

          return TextField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => runSearch(),
            decoration: InputDecoration(
              hintText: 'Search for products, brands and categories',
              isDense: true,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.arrow_forward, color: AppTheme.accent),
                onPressed: runSearch,
              ),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: width,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final p = options.elementAt(i);
                    return ListTile(
                      onTap: () => onSelected(p),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: p.color,
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(p.icon, color: Colors.white, size: 22),
                      ),
                      title: Text(p.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${p.category}  \u2022  ${rupees(p.price)}'),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
