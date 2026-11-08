import 'package:flutter/foundation.dart';
import '../data/products.dart';
import '../models/product.dart';

enum SortOption {
  relevance('Relevance'),
  priceLow('Price: Low to High'),
  priceHigh('Price: High to Low'),
  rating('Top Rated');

  final String label;
  const SortOption(this.label);
}

/// Handles search text, category filter and sorting for the catalog.
class ProductProvider extends ChangeNotifier {
  String _query = '';
  String _category = 'All';
  SortOption _sort = SortOption.relevance;

  String get query => _query;
  String get category => _category;
  SortOption get sort => _sort;

  List<String> get categories =>
      ['All', ...{for (final p in sampleProducts) p.category}];

  List<Product> get filtered {
    final q = _query.toLowerCase().trim();
    final list = sampleProducts.where((p) {
      final matchCat = _category == 'All' || p.category == _category;
      final matchQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
      return matchCat && matchQuery;
    }).toList();
    switch (_sort) {
      case SortOption.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.relevance:
        break;
    }
    return list;
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  void setSort(SortOption value) {
    _sort = value;
    notifyListeners();
  }
}
