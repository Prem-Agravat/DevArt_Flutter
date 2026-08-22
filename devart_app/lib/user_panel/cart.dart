import 'package:flutter/material.dart';
import 'package:devart/user_panel/delivery_address.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<_CartItem> _items = [
    _CartItem(
      name: "IndigoGeometry",
      category: "Handwoven-cotton",
      price: 899,
      oldPrice: 1099,
      quantity: 1,
      image: "lib/assets/images/devart_product_1.webp",
    ),
    _CartItem(
      name: "IndigoGeometry",
      category: "Handwoven-cotton",
      price: 899,
      oldPrice: 1099,
      quantity: 1,
      image: "lib/assets/images/devart_product_1.webp",
    ),
  ];

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

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get shipping {
    return _items.isEmpty ? 0 : 36;
  }

  double get tax {
    return subtotal * 0.05;
  }

  double get total {
    return subtotal + shipping - tax;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "lib/assets/images/devart-bgimage.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.white.withOpacity(0.72)),
            ),
            Column(
              children: [
                _buildTopBar(),
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
                        const SizedBox(height: 10),
                        _buildPromoCode(),
                        const SizedBox(height: 15),
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
                              fontSize: 15,
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
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(color: Color(0xFFC3D9FF)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu, size: 34)),
          Image.asset(
            "lib/assets/images/devart-logo.png",
            width: 70,
            height: 70,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart, size: 34),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 64,
      width: double.infinity,
      color: const Color(0xFFFFF5F3),
      child: const Center(
        child: Text(
          "AddToCart",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB66D6D),
            fontFamily: "serif",
          ),
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
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
                Text(
                  item.category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
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
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFC99FA0),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 35),
                      onPressed: () => _decrease(index),
                      icon: const Icon(Icons.remove, size: 17),
                    ),
                    Text(
                      "${item.quantity}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 35),
                      onPressed: () => _increase(index),
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
        const SizedBox(height: 3),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D8D8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.sell_outlined),
                    SizedBox(width: 10),
                    Text(
                      "ApplyCouponCode",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 85,
              height: 38,
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
            onPressed: () {},
            child: const Text(
              "ViewAvailableOffers",
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
          "OrderSummery",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "serif",
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
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
              _summaryRow("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
              _summaryRow("Shipping", "₹${shipping.toStringAsFixed(2)}"),
              _summaryRow("Tax(5%)", "₹${tax.toStringAsFixed(2)}"),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: 280,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DeliveryAddressScreen(),
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
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: 2,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFC3D9FF),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      onTap: (index) {},
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          label: "Categories",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: "Orders",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: "Account",
        ),
      ],
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
    required this.quantity,
    required this.image,
  });
}
