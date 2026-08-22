import 'package:devart/common/action_popup.dart';
import 'package:devart/common/app_shell.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<_WishlistItem> items = [
    _WishlistItem(
      name: "IndigoGeometry",
      category: "Handwoven-cotton",
      image: "lib/assets/images/devart_product_1.webp",
    ),
    _WishlistItem(
      name: "IndigoGeometry",
      category: "Handwoven-cotton",
      image: "lib/assets/images/devart_product_1.webp",
    ),
    _WishlistItem(
      name: "IndigoGeometry",
      category: "Handwoven-cotton",
      image: "lib/assets/images/devart_product_1.webp",
    ),
  ];

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });

    showSuccessPopup(
      context,
      title: "Product Remove",
      message: "successfully Remove.",
      buttonText: "Return to Wishlist",
    );
  }

  void _addToCart(int index) {
    showSuccessPopup(
      context,
      title: "Added to Cart",
      message: "${items[index].name} successfully added to cart.",
      buttonText: "Continue Shopping",
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 3,
      selectedDrawerItem: "Wishlist",
      showCart: true,
      showBottomNav: true,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
                child: Column(
                  children: [
                    _buildSearch(),
                    const SizedBox(height: 25),
                    ...List.generate(
                      items.length,
                      (index) => _buildItem(index),
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
      color: const Color(0xFFF5E9E5),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Wishlist",
                style: TextStyle(
                  fontSize: 31,
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

  Widget _buildSearch() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search, size: 30),
        filled: true,
        fillColor: const Color(0xFFD8D8D8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = items[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      height: 122,
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.black, style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
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
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "₹899",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "₹1009",
                      style: TextStyle(
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
                onTap: () => _removeItem(index),
                child: const Icon(Icons.close, size: 25),
              ),
              SizedBox(
                width: 76,
                height: 32,
                child: ElevatedButton(
                  onPressed: () => _addToCart(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA06D42),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WishlistItem {
  final String name;
  final String category;
  final String image;

  _WishlistItem({
    required this.name,
    required this.category,
    required this.image,
  });
}
