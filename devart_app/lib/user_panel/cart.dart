import 'package:devart/admin/offers/offer_management.dart';
import 'package:devart/common/app_shell.dart';
import 'package:devart/user_panel/coupons.dart';
import 'package:devart/user_panel/delivery_address.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  final List<_CartItem> _items = [
    _CartItem(
      name: "IndigoGeometry",
      category: "Handwoven-cotton",
      price: 899,
      oldPrice: 1099,
      image: "lib/assets/images/devart_product_1.webp",
    ),
    _CartItem(
      name: "IndigoGeometry",
      category: "Handwoven-cotton",
      price: 899,
      oldPrice: 1099,
      image: "lib/assets/images/devart_product_1.webp",
    ),
  ];

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  double get shipping {
    return _items.isEmpty ? 0 : 36;
  }

  double get tax {
    return subtotal * 0.05;
  }

  double get total {
    return subtotal + shipping - 29;
  }

  void _increase(int index) {
    setState(() {
      _items[index].quantity++;
    });
  }

  void _decrease(int index) {
    setState(() {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      }
    });
  }

  void _remove(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    ...List.generate(
                      _items.length,
                      (index) => _buildCartItem(index),
                    ),
                    const SizedBox(height: 5),
                    _buildPromoCode(),
                    const SizedBox(height: 12),
                    _buildOrderSummary(),
                    const SizedBox(height: 12),
                    _buildCheckoutButton(),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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

  Widget _buildCartItem(int index) {
    final item = _items[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
      height: 122,
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item.image,
              width: 97,
              height: 97,
              fit: BoxFit.cover,
            ),
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
                  item.category,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "₹${item.price}",
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "₹${item.oldPrice}",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _remove(index),
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
                      onPressed: () => _decrease(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32),
                      icon: const Icon(Icons.remove, size: 17),
                    ),
                    Text(
                      "${item.quantity}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => _increase(index),
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
                decoration: InputDecoration(
                  hintText: "Enter Promo Code",
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8D8D8),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Apply",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                color: Colors.black.withOpacity(0.18),
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
        onPressed: _items.isEmpty
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
          backgroundColor: const Color(0xFFA06D42),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
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

class _CartItem {
  final String name;
  final String category;
  final int price;
  final int oldPrice;
  final String image;
  int quantity;

  _CartItem({
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.image,
    this.quantity = 1,
  });
}
