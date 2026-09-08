import 'package:devart/common/action_popup.dart';
import 'package:devart/common/app_shell.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/services/cart_service.dart';
import 'package:devart/services/wishlist_service.dart';
import 'package:devart/user_panel/dashboard.dart';
import 'package:devart/user_panel/detail_item.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final TextEditingController searchController = TextEditingController();
  final WishlistService _wishlistService = WishlistService();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildProductImage(String imagePath) {
    if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
      return Image.network(
        imagePath,
        width: 97,
        height: 97,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          "lib/assets/images/devart_product_1.webp",
          width: 97,
          height: 97,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      imagePath,
      width: 97,
      height: 97,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        "lib/assets/images/devart_product_1.webp",
        width: 97,
        height: 97,
        fit: BoxFit.cover,
      ),
    );
  }

  void _removeItem(ProductModel item) {
    _wishlistService.removeFromWishlist(item.id);

    showSuccessPopup(
      context,
      title: "Product Removed",
      message: "${item.name} removed from your wishlist.",
      buttonText: "Return to Wishlist",
    );
  }

  void _addToCart(ProductModel item) {
    CartService().addItem(item);

    showSuccessPopup(
      context,
      title: "Added to Cart",
      message: "${item.name} successfully added to cart.",
      buttonText: "Continue Shopping",
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _wishlistService,
      builder: (context, _) {
        final query = searchController.text.trim().toLowerCase();
        final allItems = _wishlistService.items;
        final items = query.isEmpty
            ? allItems
            : allItems
                .where((i) =>
                    i.name.toLowerCase().contains(query) ||
                    i.category.toLowerCase().contains(query))
                .toList();

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
                        if (items.isEmpty)
                          _buildEmptyWishlist()
                        else
                          ...List.generate(
                            items.length,
                            (index) => _buildItem(items[index]),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        suffixIcon: searchController.text.isNotEmpty
            ? GestureDetector(
                onTap: () => searchController.clear(),
                child: const Icon(Icons.clear, size: 20),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFD8D8D8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.favorite_border,
            size: 65,
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 14),
          const Text(
            "Your Wishlist is Empty",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "serif",
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Save items you love by tapping the heart icon on any product card.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA06D42),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Explore Items",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(ProductModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailItemScreen(productModel: item),
          ),
        );
      },
      child: Container(
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
              child: _buildProductImage(item.image),
            ),
            const SizedBox(width: 15),
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
                        "₹${item.price.toStringAsFixed(item.price % 1 == 0 ? 0 : 2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.oldPrice != null) ...[
                        const SizedBox(width: 6),
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
                  onTap: () => _removeItem(item),
                  child: const Icon(Icons.close, size: 25),
                ),
                SizedBox(
                  width: 76,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () => _addToCart(item),
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
      ),
    );
  }
}
