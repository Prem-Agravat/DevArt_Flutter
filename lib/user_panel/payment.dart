import 'package:devart/common/app_shell.dart';
import 'package:devart/models/order_model.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/address_service.dart';
import 'package:devart/services/auth_service.dart';
import 'package:devart/services/cart_service.dart';
import 'package:devart/services/order_service.dart';
import 'package:devart/user_panel/confirm_order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  bool _isPlacingOrder = false;

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

  Future<void> _processPayment() async {
    if (_isPlacingOrder) return;
    setState(() => _isPlacingOrder = true);

    final cartService = context.read<CartService>();
    final authService = context.read<AuthService>();
    final addressService = context.read<AddressService>();
    final user = authService.currentUser;
    final selectedAddr = addressService.addresses.isNotEmpty
        ? addressService.addresses[
            addressService.selectedIndex.clamp(0, addressService.addresses.length - 1)]
        : null;

    final addressText = widget.selectedAddress ??
        selectedAddr?.address ??
        "501 Silver Crest, Nana Mava Road, Rajkot, Gujarat - 360005";

    String resolvedCustomerName = user.displayName.trim();
    final emailPrefix =
        user.email.contains('@') ? user.email.split('@').first : '';
    if (resolvedCustomerName.isEmpty ||
        resolvedCustomerName == "Guest" ||
        resolvedCustomerName == "User" ||
        resolvedCustomerName.contains('@') ||
        (emailPrefix.isNotEmpty &&
            resolvedCustomerName.toLowerCase() == emailPrefix.toLowerCase())) {
      final addrName = selectedAddr?.name.trim() ?? '';
      if (addrName.isNotEmpty &&
          addrName.toLowerCase() != emailPrefix.toLowerCase()) {
        resolvedCustomerName = addrName;
      } else if (addressText.contains(',')) {
        final firstPart = addressText.split(',').first.trim();
        if (firstPart.isNotEmpty) {
          resolvedCustomerName = firstPart;
        }
      }
    }
    if (resolvedCustomerName.isEmpty) {
      resolvedCustomerName = "Customer";
    }

    final resolvedPhone = user.phone.trim().isNotEmpty
        ? user.phone.trim()
        : (selectedAddr?.phone.trim().isNotEmpty == true
            ? selectedAddr!.phone.trim()
            : "+91 98765 43210");

    final orderId =
        "#DVT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    final now = DateTime.now();
    final dateStr = "${now.day} ${_monthName(now.month)} ${now.year}";

    final items = cartService.items
        .map((i) => OrderItemModel(
              productId: i.productId,
              name: "${i.name} (${i.size})",
              quantity: i.quantity,
              price: i.price,
              image: i.image,
            ))
        .toList();

    final newOrder = OrderModel(
      id: "ord_${DateTime.now().millisecondsSinceEpoch}",
      orderId: orderId,
      userId: user.uid.isNotEmpty ? user.uid : null,
      customer: resolvedCustomerName,
      email: user.email.isNotEmpty ? user.email : "customer@devart.com",
      phone: resolvedPhone,
      address: addressText,
      date: dateStr,
      items: items,
      deliveryFee: cartService.shipping,
      discount: cartService.discount,
      status: "Pending",
      paymentMethod: "Cash on Delivery",
      paymentStatus: "Pending (COD)",
      createdAt: now,
    );

    try {
      await OrderService.instance.createOrder(newOrder);
      await cartService.clearCart();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmOrderScreen(order: newOrder),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPlacingOrder = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not place order: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    final totalAmount = cartService.total;

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
                    _buildPaymentCard(),
                    const SizedBox(height: 18),
                    _buildOrderTotal(cartService),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 280,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isPlacingOrder ? null : _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppResources.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isPlacingOrder
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                "Place Order (COD) • ₹${totalAmount.toStringAsFixed(totalAmount % 1 == 0 ? 0 : 2)}  →",
                                style: const TextStyle(
                                  fontSize: 14,
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

  Widget _buildPaymentCard() {
    return Container(
      width: double.infinity,
      height: 98,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.payments_outlined, size: 32),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Cash On Delivery",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Pay when order is delivered",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: Color(0xFF2E7D32),
            size: 25,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTotal(CartService cartService) {
    final itemsCount = cartService.itemCount;
    final subtotal = cartService.subtotal;
    final discount = cartService.discount;
    final shipping = cartService.shipping;
    final total = cartService.total;

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
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
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
