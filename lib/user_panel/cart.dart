import 'package:devart/common/app_shell.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/cart_service.dart';
import 'package:devart/user_panel/coupons.dart';
import 'package:devart/user_panel/dashboard.dart';
import 'package:devart/user_panel/delivery_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  CartService get _cartService => context.read<CartService>();

  @override
  void initState() {
    super.initState();
    final applied = CartService.instance.appliedPromoCode;
    if (applied != null) {
      _promoController.text = applied;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Widget _buildProductImage(String imagePath) {
    final path =
        imagePath.isNotEmpty ? imagePath : AppResources.placeholderProduct;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: 97,
        height: 97,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          AppResources.placeholderProduct,
          width: 97,
          height: 97,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      path,
      width: 97,
      height: 97,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        AppResources.placeholderProduct,
        width: 97,
        height: 97,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartService>();
    final items = cart.items;

    return AppShell(
      selectedIndex: 0,
      selectedDrawerItem: "Cart",
      showCart: true,
      showBottomNav: true,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(17, 12, 17, 20),
                child: Column(
                  children: [
                    if (items.isEmpty)
                      _buildEmptyCart()
                    else ...[
                      ...List.generate(
                        items.length,
                        (index) => _buildCartItem(items[index]),
                      ),
                      const SizedBox(height: 5),
                      _buildPromoCode(),
                      const SizedBox(height: 12),
                      _buildOrderSummary(),
                      const SizedBox(height: 12),
                      _buildCheckoutButton(),
                    ],
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Continue Shopping",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
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
      height: 59,
      width: double.infinity,
      color: const Color(0xFFF5E9E5),
      alignment: Alignment.center,
      child: const Text(
        "AddToCart",
        style: TextStyle(
          fontSize: 31,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB56F6F),
          fontFamily: "serif",
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 70,
            color: Colors.grey,
          ),
          const SizedBox(height: 14),
          const Text(
            "Explore our handcrafted collections and find something you love!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "serif",
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Explore our handcrafted collections and find something you love!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppResources.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Explore Products",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
      height: 122,
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildProductImage(item.image),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
                Text(
                  "${item.category} • ${item.size}",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "₹${item.price.toStringAsFixed(item.price % 1 == 0 ? 0 : 2)}",
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.oldPrice != null) ...[
                      const SizedBox(width: 5),
                      Text(
                        "₹${item.oldPrice!.toStringAsFixed(item.oldPrice! % 1 == 0 ? 0 : 2)}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _cartService.removeItem(item.id),
                child: const Icon(Icons.close, size: 24),
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFC99FA0),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _cartService.decreaseQuantity(item.id),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32),
                      icon: const Icon(Icons.remove, size: 17),
                    ),
                    Text(
                      "${item.quantity}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => _cartService.increaseQuantity(item.id),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32),
                      icon: const Icon(Icons.add, size: 17),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCode() {
    final hasApplied = _cartService.appliedPromoCode != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PromoCode",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "serif",
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _promoController,
                enabled: !hasApplied,
                decoration: InputDecoration(
                  hintText: hasApplied
                      ? "Applied: ${_cartService.appliedPromoCode}"
                      : "Enter Promo Code (e.g. DEVART10)",
                  prefixIcon: const Icon(Icons.sell_outlined),
                  filled: true,
                  fillColor: const Color(0xFFD8D8D8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 85,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (hasApplied) {
                    _cartService.removePromo();
                    _promoController.clear();
                  } else {
                    await _cartService.applyPromoAsync(_promoController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasApplied ? Colors.red : const Color(0xFFD8D8D8),
                  foregroundColor: hasApplied ? Colors.white : Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  hasApplied ? "Remove" : "Apply",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CouponsScreen()),
              );
            },
            child: const Text(
              "View Available Offers",
              style: TextStyle(
                color: Colors.black,
                fontSize: 11,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    final subtotal = _cartService.subtotal;
    final shipping = _cartService.shipping;
    final tax = _cartService.tax;
    final discount = _cartService.discount;
    final total = _cartService.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Order Summery",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "serif",
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(12),
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
          ),
          child: Column(
            children: [
              _summaryRow("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
              _summaryRow("Shipping", "₹${shipping.toStringAsFixed(2)}"),
              _summaryRow("Tax (5%)", "₹${tax.toStringAsFixed(2)}"),
              if (discount > 0)
                _summaryRow("Discount", "-₹${discount.toStringAsFixed(2)}", green: true),
              const Divider(),
              _summaryRow(
                "Total",
                "₹${total.toStringAsFixed(2)}",
                large: true,
                green: true,
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
    bool large = false,
    bool green = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
              color: green ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: 280,
      height: 50,
      child: ElevatedButton(
        onPressed: _cartService.items.isEmpty
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeliveryAddressScreen(),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppResources.primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "Proceed to Checkout  →",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
