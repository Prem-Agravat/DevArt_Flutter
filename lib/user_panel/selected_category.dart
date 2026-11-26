import 'package:devart/common/app_shell.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/cart_service.dart';
import 'package:devart/services/product_service.dart';
import 'package:devart/services/wishlist_service.dart';
import 'package:devart/user_panel/detail_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedCategoryScreen extends StatefulWidget {
  final String category;

  const SelectedCategoryScreen({super.key, required this.category});

  @override
  State<SelectedCategoryScreen> createState() => _SelectedCategoryScreenState();
}

class _SelectedCategoryScreenState extends State<SelectedCategoryScreen> {
  final ProductService _productService = ProductService.instance;

  final Map<String, String> categoryDescriptions = {
    "All":
        "Explore our complete collection of premium\nhandcrafted home decor products.",
    "Cushion Covers":
        "Premium handmade cushion covers with timeless\ncraftsmanship and comfort.",
    "CushionCovers":
        "Premium handmade cushion covers with timeless\ncraftsmanship and comfort.",
    "Toran":
        "Beautiful handmade toran designed to add\ntraditional elegance to your home.",
    "Sofa Covers":
        "Elegant sofa covers crafted for comfort,\nstyle and everyday protection.",
    "SofaCovers":
        "Elegant sofa covers crafted for comfort,\nstyle and everyday protection.",
    "Bedsheet":
        "Premium bedsheets with beautiful designs\nfor a comfortable sleeping experience.",
    "Bedsheets":
        "Premium bedsheets with beautiful designs\nfor a comfortable sleeping experience.",
    "Pottery":
        "Authentic terracotta and clay pottery,\nhandcrafted with rustic natural glazes.",
    "Handicrafts":
        "Timeless artisan woodwork and traditional\nhandcrafted folk collectibles.",
  };

  Widget _buildProductImage(String imagePath) {
    final path =
        imagePath.isNotEmpty ? imagePath : AppResources.placeholderProduct;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          AppResources.placeholderProduct,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      path,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        AppResources.placeholderProduct,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final description =
        categoryDescriptions[widget.category] ??
        "Explore our premium collection of handcrafted artisan creations.";

    context.watch<WishlistService>();

    return AppShell(
      selectedIndex: 1,
      selectedDrawerItem: "Categories",
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppResources.bgImageHome, fit: BoxFit.cover),
          ),
          Column(
            children: [
              _buildTitle(),
              _buildDescription(description),
              Expanded(
                child: StreamBuilder<List<ProductModel>>(
                  stream: _productService.getProductsStream(
                    category: widget.category,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppResources.primaryColor,
                        ),
                      );
                    }
                    final List<ProductModel> products = snapshot.data ?? [];
                    return _buildProductGrid(products);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 59,
      width: double.infinity,
      color: const Color(0xFFF5E9E5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black54, width: 2),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Text(
            widget.category,
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB56F6F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          description,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          "No products found in this category.",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(22, 5, 22, 85),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 22,
        childAspectRatio: 0.78,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailItemScreen(productModel: product),
              ),
            );
          },
          child: _buildProductCard(product),
        );
      },
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final wishlistService = context.read<WishlistService>();
    final isWishlisted = wishlistService.isProductWishlisted(product);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _buildProductImage(product.image),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          context.read<WishlistService>().toggleWishlist(product);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 22,
                            color: isWishlisted
                                ? const Color(0xFFB56F6F)
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 2),
                      Text(
                        "4.5",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        "₹${product.price.toStringAsFixed(product.price % 1 == 0 ? 0 : 2)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 3),
                        Text(
                          "₹${product.oldPrice!.toStringAsFixed(product.oldPrice! % 1 == 0 ? 0 : 2)}",
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      const Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          context.read<CartService>().addItem(product);
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8CB8F2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
