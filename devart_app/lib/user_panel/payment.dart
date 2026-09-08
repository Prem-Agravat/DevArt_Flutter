import 'package:devart/common/app_shell.dart';
import 'package:devart/models/order_model.dart';
import 'package:devart/services/cart_service.dart';
import 'package:devart/services/order_service.dart';
import 'package:devart/user_panel/confirm_order.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String? selectedAddress;

  const PaymentScreen({
    super.key,
    this.selectedAddress,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedPayment = 0;
  final CartService _cartService = CartService();

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  void _processPayment() {
    final addressText = widget.selectedAddress ??
        "Alex Rivers, 124 Artisans Lane, Studio 4B, Brooklyn, NY 11201";
    final orderId = "#DVT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    final now = DateTime.now();
    final dateStr = "${now.day} ${_monthName(now.month)} ${now.year}";

    final items = _cartService.items.isNotEmpty
        ? _cartService.items
            .map((i) => OrderItemModel(
                  name: "${i.name} (${i.size})",
                  quantity: i.quantity,
                  price: i.price,
                  image: i.image,
                ))
            .toList()
        : [
            OrderItemModel(
              name: "IndigoGeometry (16×16)",
              quantity: 1,
              price: 899.0,
              image: "lib/assets/images/devart_product_1.webp",
            ),
          ];

    final paymentMethodStr = selectedPayment == 0
        ? "Credit/Debit Card"
        : (selectedPayment == 1 ? "UPI / NetBanking" : "Cash on Delivery");

    final newOrder = OrderModel(
      id: '',
      orderId: orderId,
      customer: "Alex Rivers",
      email: "alex.rivers@example.com",
      phone: "+91 98765 43210",
      address: addressText,
      date: dateStr,
      items: items,
      deliveryFee: _cartService.shipping,
      discount: _cartService.discount,
      status: "Pending",
      paymentMethod: paymentMethodStr,
      paymentStatus: selectedPayment == 2 ? "Pending (COD)" : "Paid",
      createdAt: now,
    );

    try {
      OrderService().createOrder(newOrder);
    } catch (_) {}

    _cartService.clearCart();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmOrderScreen(order: newOrder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _cartService.total > 0 ? _cartService.total : 870.0;

    return AppShell(
      selectedIndex: 0,
      selectedDrawerItem: "Payment",
      showCart: false,
      showBottomNav: false,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 30),
                child: Column(
                  children: [
                    _buildSteps(),
                    const SizedBox(height: 22),
                    _buildPaymentCard(
                      0,
                      Icons.credit_card_outlined,
                      "Credit/Debit Card",
                      "----------4242",
                    ),
                    _buildPaymentCard(
                      1,
                      Icons.account_balance_outlined,
                      "UPI/NetBanking",
                      "Pay via any UPI App",
                    ),
                    _buildPaymentCard(
                      2,
                      Icons.payments_outlined,
                      "Cash On Delivery",
                      "Pay When Delivered",
                    ),
                    const SizedBox(height: 18),
                    _buildOrderTotal(),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 280,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA06D42),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Pay ₹${totalAmount.toStringAsFixed(totalAmount % 1 == 0 ? 0 : 2)}  →",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 64,
      width: double.infinity,
      color: const Color(0xFFF5E9E5),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Payment",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB56F6F),
                  fontFamily: "serif",
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSteps() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _PaymentStep(number: "✓", title: "Address", active: true),
        Text(">", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        _PaymentStep(number: "2", title: "Payment", active: true),
        Text(">", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        _PaymentStep(number: "3", title: "Confirm"),
      ],
    );
  }

  Widget _buildPaymentCard(
    int index,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final selected = selectedPayment == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = index;
        });
      },
      child: Container(
        width: double.infinity,
        height: 98,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black54),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: "serif",
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTotal() {
    final itemsCount = _cartService.itemCount > 0 ? _cartService.itemCount : 1;
    final subtotal = _cartService.subtotal > 0 ? _cartService.subtotal : 899.0;
    final discount = _cartService.discount > 0 ? _cartService.discount : 29.0;
    final shipping = _cartService.shipping;
    final total = _cartService.total > 0 ? _cartService.total : 870.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Order Total",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "serif",
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            border: const Border(
              left: BorderSide(color: Colors.black, width: 3),
            ),
          ),
          child: Column(
            children: [
              _summaryRow(
                "$itemsCount ${itemsCount == 1 ? 'Item' : 'Items'}",
                "₹${subtotal.toStringAsFixed(2)}",
              ),
              if (discount > 0)
                _summaryRow(
                  "Discount",
                  "-₹${discount.toStringAsFixed(2)}",
                  color: Colors.red,
                ),
              _summaryRow(
                "Delivery",
                shipping == 0 ? "Free" : "₹${shipping.toStringAsFixed(2)}",
              ),
              const Divider(),
              _summaryRow(
                "Total",
                "₹${total.toStringAsFixed(2)}",
                large: true,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    Color? color,
    bool large = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: large ? 20 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: large ? 20 : 13,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentStep extends StatelessWidget {
  final String number;
  final String title;
  final bool active;

  const _PaymentStep({
    required this.number,
    required this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.black : Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: active ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "serif",
          ),
        ),
      ],
    );
  }
}
