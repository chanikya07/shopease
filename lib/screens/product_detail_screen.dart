import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/cta_buttons.dart';
import '../widgets/price_tag.dart';
import '../widgets/product_card.dart';
import '../widgets/product_image.dart';
import '../widgets/qty_stepper.dart';
import '../widgets/reviews_section.dart';
import '../widgets/star_rating.dart';
import '../widgets/store_scaffold.dart';
import '../widgets/trust_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;
  int _angle = 0;
  static const _angleNames = ['Front', 'Side', 'Back', 'Close-up'];

  Product get p => widget.product;

  Widget _gallery() {
    return Column(
      children: [
        Hero(
          tag: 'product-${p.id}',
          child: AspectRatio(
            aspectRatio: 1,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: KeyedSubtree(
                key: ValueKey(_angle),
                child: ProductImage(
                    product: p, angle: _angle, iconSize: 150, radius: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < 4; i++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 3 ? 10 : 0),
                  child: Tooltip(
                    message: _angleNames[i],
                    child: GestureDetector(
                      onTap: () => setState(() => _angle = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _angle == i
                                  ? AppTheme.accent
                                  : AppTheme.border,
                              width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ProductImage(
                              product: p, angle: i, iconSize: 34, radius: 8),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _info(BuildContext context) {
    final freeDelivery = p.price * _qty >= CartProvider.freeDeliveryAbove;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(p.brand.toUpperCase(),
            style: const TextStyle(
                letterSpacing: 1, color: AppTheme.muted, fontSize: 12)),
        const SizedBox(height: 4),
        Text(p.name,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Row(
          children: [
            StarRating(rating: p.rating, size: 20),
            const SizedBox(width: 8),
            Text('${p.rating}  (${p.reviewCount} reviews)',
                style: const TextStyle(color: AppTheme.muted)),
          ],
        ),
        const Divider(height: 28),
        PriceTag(product: p, large: true),
        const SizedBox(height: 4),
        const Text('Inclusive of all taxes',
            style: TextStyle(fontSize: 12, color: AppTheme.muted)),
        const SizedBox(height: 12),
        const Row(children: [
          Icon(Icons.check_circle, size: 18, color: AppTheme.success),
          SizedBox(width: 6),
          Text('In stock',
              style: TextStyle(
                  color: AppTheme.success, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.local_shipping_outlined,
              size: 18, color: AppTheme.muted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(freeDelivery
                ? 'FREE delivery by ${formatDate(deliveryDate())}'
                : '\u20B949 delivery by ${formatDate(deliveryDate())} (free above \u20B9999)'),
          ),
        ]),
        const SizedBox(height: 16),
        Text(p.description, style: const TextStyle(fontSize: 15, height: 1.5)),
        const SizedBox(height: 12),
        for (final h in p.highlights)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(children: [
              const Icon(Icons.check, size: 16, color: AppTheme.success),
              const SizedBox(width: 8),
              Expanded(child: Text(h)),
            ]),
          ),
        const SizedBox(height: 20),
        Row(children: [
          const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 16),
          QtyStepper(
            qty: _qty,
            onMinus: _qty > 1 ? () => setState(() => _qty--) : null,
            onPlus: () => setState(() => _qty++),
          ),
        ]),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: AddToCartButton(onPressed: () {
                context.read<CartProvider>().add(p, quantity: _qty);
                showAdded(context, '$_qty x ${p.name} added to cart');
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BuyNowButton(onPressed: () {
                context.read<CartProvider>().add(p, quantity: _qty);
                Navigator.pushNamed(context, '/checkout');
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const SecureBadges(),
      ],
    );
  }

  Widget _policies() {
    Widget tile(IconData icon, String title, String body) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            leading: Icon(icon, color: AppTheme.accent),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            shape: const Border(),
            collapsedShape: const Border(),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(body, style: const TextStyle(height: 1.5))],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shipping, Returns & Warranty',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        tile(Icons.local_shipping_outlined, 'Shipping policy',
            'Orders are dispatched within 24 hours and delivered in 3-5 business days. Delivery is free on orders of \u20B9999 and above; otherwise a flat \u20B949 applies. You can track every order from your confirmation.'),
        tile(Icons.assignment_return_outlined, '7-day return policy',
            'Not satisfied? Return the product within 7 days of delivery in its original packaging. We arrange a free pickup and refund the full amount to your original payment method within 3-5 working days.'),
        tile(Icons.shield_outlined, 'Warranty',
            'All products carry a 1 year manufacturer warranty against defects. Keep your order confirmation as proof of purchase.'),
      ],
    );
  }

  Widget _related(BuildContext context) {
    var items = sampleProducts
        .where((x) => x.id != p.id && x.category == p.category)
        .toList();
    if (items.length < 3) {
      items = sampleProducts.where((x) => x.id != p.id).take(4).toList();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('You may also like',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        SizedBox(
          height: 360,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) => SizedBox(
              width: 230,
              child: ProductCard(product: items[i], index: i),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pp = context.read<ProductProvider>();
    return StoreScaffold(
      crumbs: [
        Crumb('Home', () => goHome(context)),
        Crumb(p.category, () {
          pp.setCategory(p.category);
          goHome(context);
        }),
        Crumb(p.name),
      ],
      children: [
        LayoutBuilder(builder: (context, c) {
          if (c.maxWidth >= 820) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: _gallery()),
                const SizedBox(width: 40),
                Expanded(flex: 6, child: _info(context)),
              ],
            );
          }
          return Column(
            children: [_gallery(), const SizedBox(height: 24), _info(context)],
          );
        }),
        const SizedBox(height: 40),
        const TrustStrip(),
        const SizedBox(height: 40),
        ReviewsSection(product: p),
        const SizedBox(height: 32),
        _policies(),
        const SizedBox(height: 40),
        _related(context),
      ],
    );
  }
}
