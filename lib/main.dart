import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/home_screen.dart';
import 'screens/order_success_screen.dart';
import 'screens/product_detail_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ShopEaseApp());

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  // Named routes with a custom fade + slide page transition.
  static Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case '/detail':
        page = ProductDetailScreen(product: settings.arguments as Product);
        break;
      case '/cart':
        page = const CartScreen();
        break;
      case '/checkout':
        page = const CheckoutScreen();
        break;
      case '/success':
        page = OrderSuccessScreen(
            args: settings.arguments as Map<String, dynamic>);
        break;
      case '/':
      default:
        page = const HomeScreen();
    }
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0.04, 0), end: Offset.zero)
                .animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'ShopEase',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: '/',
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }
}
