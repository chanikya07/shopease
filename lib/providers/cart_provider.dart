import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Holds the shopping cart. Used by Home, Detail, Cart and Checkout screens.
class CartProvider extends ChangeNotifier {
  static const double freeDeliveryAbove = 999;
  static const double deliveryFee = 49;

  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  bool get isEmpty => _items.isEmpty;

  int get totalItems => _items.values.fold(0, (sum, i) => sum + i.quantity);
  double get mrpTotal => _items.values.fold(0.0, (sum, i) => sum + i.mrpTotal);
  double get subtotal => _items.values.fold(0.0, (sum, i) => sum + i.total);
  double get savings => mrpTotal - subtotal;
  double get delivery =>
      (subtotal == 0 || subtotal >= freeDeliveryAbove) ? 0 : deliveryFee;
  double get grandTotal => subtotal + delivery;

  void add(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void increment(int id) {
    _items[id]?.quantity++;
    notifyListeners();
  }

  void decrement(int id) {
    final item = _items[id];
    if (item == null) return;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void remove(int id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
