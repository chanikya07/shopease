import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/cta_buttons.dart';
import '../widgets/order_summary.dart';
import '../widgets/store_scaffold.dart';
import '../widgets/trust_widgets.dart';

/// Distraction-free 3-step checkout: Contact -> Shipping -> Payment.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const _stepLabels = ['Contact', 'Shipping', 'Payment'];
  static const _payments = ['UPI', 'Credit / Debit Card', 'Cash on Delivery'];

  int _step = 0;
  bool _guest = true;
  String _payment = 'UPI';

  final _contactKey = GlobalKey<FormState>();
  final _shipKey = GlobalKey<FormState>();
  final _payKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _pincode = TextEditingController();
  final _upi = TextEditingController();
  final _cardNo = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _email, _password, _name, _phone, _address, _city, _pincode,
      _upi, _cardNo, _expiry, _cvv
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ---------- helpers ----------

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? type,
    int maxLines = 1,
    bool obscure = false,
    List<TextInputFormatter>? formatters,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      obscureText: obscure,
      inputFormatters: formatters,
      validator: validator,
      decoration:
          InputDecoration(labelText: label, hintText: hint, prefixIcon: Icon(icon)),
    );
  }

  String? _required(String? v, String msg) =>
      (v == null || v.trim().isEmpty) ? msg : null;

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter your email';
    final ok = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email address';
  }

  void _next(GlobalKey<FormState> key) {
    if (key.currentState!.validate()) setState(() => _step++);
  }

  void _placeOrder() {
    if (!_payKey.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    final args = {
      'orderId': 'SE${DateTime.now().millisecondsSinceEpoch % 100000}',
      'name': _name.text.trim(),
      'email': _email.text.trim(),
      'total': cart.grandTotal,
      'items': cart.totalItems,
      'payment': _payment,
      'guest': _guest,
    };
    Navigator.pushNamedAndRemoveUntil(context, '/success', (r) => r.isFirst,
        arguments: args);
    cart.clear(); // after navigation so this screen never shows an empty cart
  }

  // ---------- progress indicator ----------

  Widget _dot(int i) {
    final done = i < _step;
    final active = i == _step;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done || active ? AppTheme.accent : Colors.white,
            border: Border.all(
                color: done || active ? AppTheme.accent : AppTheme.border,
                width: 2),
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : Text('${i + 1}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: active ? Colors.white : AppTheme.muted)),
          ),
        ),
        const SizedBox(height: 6),
        Text(_stepLabels[i],
            style: TextStyle(
                fontSize: 12,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? AppTheme.navy : AppTheme.muted)),
      ],
    );
  }

  Widget _progress() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 3,
                  color: i <= _step ? AppTheme.accent : AppTheme.border,
                ),
              ),
            ),
          _dot(i),
        ],
      ],
    );
  }

  // ---------- steps ----------

  Widget _title(String t, [String? sub]) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            if (sub != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(sub, style: const TextStyle(color: AppTheme.muted)),
              ),
          ],
        ),
      );

  Widget _stepContact() {
    return Form(
      key: _contactKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Contact information'),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                  value: true,
                  icon: Icon(Icons.person_outline),
                  label: Text('Guest checkout')),
              ButtonSegment(
                  value: false,
                  icon: Icon(Icons.login),
                  label: Text('I have an account')),
            ],
            selected: {_guest},
            onSelectionChanged: (s) => setState(() => _guest = s.first),
          ),
          const SizedBox(height: 10),
          Text(
            _guest
                ? 'No account needed. We only use your email to send the order confirmation.'
                : 'Sign in to use your saved details (demo: any password of 6+ characters).',
            style: const TextStyle(color: AppTheme.muted, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _field(
            controller: _email,
            label: 'Email address',
            icon: Icons.email_outlined,
            type: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          if (!_guest) ...[
            const SizedBox(height: 14),
            _field(
              controller: _password,
              label: 'Password',
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) => (v == null || v.length < 6)
                  ? 'Password must be at least 6 characters'
                  : null,
            ),
          ],
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 260,
              child: BuyNowButton(
                label: _guest ? 'Continue as Guest' : 'Sign In & Continue',
                icon: Icons.arrow_forward,
                onPressed: () => _next(_contactKey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepShipping() {
    return Form(
      key: _shipKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Shipping address'),
          _field(
            controller: _name,
            label: 'Full name',
            icon: Icons.person_outline,
            validator: (v) {
              if (_required(v, 'Please enter your name') != null) {
                return 'Please enter your name';
              }
              return v!.trim().length < 3 ? 'Name is too short' : null;
            },
          ),
          const SizedBox(height: 14),
          _field(
            controller: _phone,
            label: 'Phone number',
            icon: Icons.phone_outlined,
            type: TextInputType.phone,
            formatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)
            ],
            validator: (v) {
              if (_required(v, 'Please enter your phone number') != null) {
                return 'Please enter your phone number';
              }
              return RegExp(r'^[6-9]\d{9}$').hasMatch(v!.trim())
                  ? null
                  : 'Enter a valid 10-digit mobile number';
            },
          ),
          const SizedBox(height: 14),
          _field(
            controller: _address,
            label: 'Address',
            icon: Icons.home_outlined,
            maxLines: 2,
            validator: (v) {
              if (_required(v, 'Please enter your address') != null) {
                return 'Please enter your address';
              }
              return v!.trim().length < 10
                  ? 'Address must be at least 10 characters'
                  : null;
            },
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _field(
                  controller: _city,
                  label: 'City',
                  icon: Icons.location_city,
                  validator: (v) => _required(v, 'Enter city'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _field(
                  controller: _pincode,
                  label: 'Pincode',
                  icon: Icons.pin_drop_outlined,
                  type: TextInputType.number,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6)
                  ],
                  validator: (v) => RegExp(r'^\d{6}$').hasMatch((v ?? '').trim())
                      ? null
                      : '6 digits required',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppTheme.bg,
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.local_shipping_outlined, color: AppTheme.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                    'Standard delivery by ${formatDate(deliveryDate())}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          _navButtons(
              nextLabel: 'Continue to Payment', onNext: () => _next(_shipKey)),
        ],
      ),
    );
  }

  Widget _payTile(String title, IconData icon, String sub) {
    final sel = _payment == title;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => setState(() => _payment = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sel ? AppTheme.accent.withOpacity(0.06) : Colors.white,
          border: Border.all(
              color: sel ? AppTheme.accent : AppTheme.border,
              width: sel ? 2 : 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Icon(icon, color: sel ? AppTheme.accent : AppTheme.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(sub,
                    style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
              ],
            ),
          ),
          Icon(sel ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: sel ? AppTheme.accent : AppTheme.muted),
        ]),
      ),
    );
  }

  Widget _reviewLine(String label, String value, int step) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 64,
                child: Text(label,
                    style: const TextStyle(color: AppTheme.muted))),
            Expanded(child: Text(value)),
            InkWell(
              onTap: () => setState(() => _step = step),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Text('Edit',
                    style: TextStyle(
                        color: AppTheme.accent, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );

  Widget _stepPayment() {
    final cart = context.watch<CartProvider>();
    return Form(
      key: _payKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Payment method', 'All transactions are secure and encrypted.'),
          _payTile('UPI', Icons.qr_code_2, 'Pay using any UPI app'),
          _payTile('Credit / Debit Card', Icons.credit_card, 'Visa, Mastercard, RuPay'),
          _payTile('Cash on Delivery', Icons.payments_outlined,
              'Pay when your order arrives'),
          const SizedBox(height: 6),
          if (_payment == 'UPI')
            _field(
              controller: _upi,
              label: 'UPI ID',
              hint: 'name@bank',
              icon: Icons.alternate_email,
              validator: (v) {
                final t = (v ?? '').trim();
                return RegExp(r'^[\w.\-]{2,}@[\w]{2,}$').hasMatch(t)
                    ? null
                    : 'Enter a valid UPI ID, e.g. name@bank';
              },
            ),
          if (_payment == 'Credit / Debit Card') ...[
            _field(
              controller: _cardNo,
              label: 'Card number',
              icon: Icons.credit_card,
              type: TextInputType.number,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16)
              ],
              validator: (v) => (v ?? '').length == 16
                  ? null
                  : 'Card number must be 16 digits',
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _field(
                    controller: _expiry,
                    label: 'Expiry (MM/YY)',
                    icon: Icons.date_range,
                    validator: (v) =>
                        RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch((v ?? '').trim())
                            ? null
                            : 'Use MM/YY',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    controller: _cvv,
                    label: 'CVV',
                    icon: Icons.password,
                    obscure: true,
                    type: TextInputType.number,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                    validator: (v) =>
                        (v ?? '').length == 3 ? null : '3 digits',
                  ),
                ),
              ],
            ),
          ],
          if (_payment == 'Cash on Delivery')
            const Text('Keep the exact amount ready for the delivery partner.',
                style: TextStyle(color: AppTheme.muted)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: AppTheme.bg, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                _reviewLine('Contact', _email.text.trim(), 0),
                _reviewLine(
                    'Ship to',
                    '${_name.text.trim()}, ${_address.text.trim()}, ${_city.text.trim()} - ${_pincode.text.trim()}',
                    1),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SecureBadges(),
          const SizedBox(height: 20),
          _navButtons(
            nextLabel: 'Place Order  \u2022  ${rupees(cart.grandTotal)}',
            nextIcon: Icons.lock_outline,
            onNext: _placeOrder,
          ),
        ],
      ),
    );
  }

  Widget _navButtons(
      {required String nextLabel,
      required VoidCallback onNext,
      IconData nextIcon = Icons.arrow_forward}) {
    return Row(
      children: [
        if (_step > 0)
          TextButton.icon(
            onPressed: () => setState(() => _step--),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back'),
          ),
        const Spacer(),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: BuyNowButton(
                label: nextLabel, icon: nextIcon, onPressed: onNext),
          ),
        ),
      ],
    );
  }

  Widget _stepBody() {
    switch (_step) {
      case 0:
        return _stepContact();
      case 1:
        return _stepShipping();
      default:
        return _stepPayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (cart.isEmpty) {
      return StoreScaffold(
        minimal: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Column(
                children: [
                  const Text('Your cart is empty',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 240,
                    child: BuyNowButton(
                      label: 'Continue Shopping',
                      icon: Icons.storefront,
                      onPressed: () => goHome(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final stepCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(14)),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(key: ValueKey(_step), child: _stepBody()),
      ),
    );

    return StoreScaffold(
      minimal: true,
      crumbs: [
        Crumb('Cart', () => Navigator.pop(context)),
        const Crumb('Checkout'),
      ],
      children: [
        const Text('Checkout',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 20),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: _progress(),
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(builder: (context, c) {
          const summary = OrderSummary(showItems: true);
          if (c.maxWidth >= 900) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: stepCard),
                const SizedBox(width: 24),
                const SizedBox(width: 360, child: summary),
              ],
            );
          }
          return Column(
              children: [stepCard, const SizedBox(height: 16), summary]);
        }),
      ],
    );
  }
}
