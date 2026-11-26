import 'package:devart/common/app_shell.dart';
import 'package:devart/data/local_data.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/product_service.dart';
import 'package:devart/services/wishlist_service.dart';
import 'package:devart/user_panel/detail_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devart/user_panel/categories.dart';
import 'package:devart/user_panel/selected_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService.instance;

  late final List<Map<String, String>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = LocalData.getCategories();
    _productService.seedInitialProductsIfEmpty();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    return AppShell(
      selectedIndex: 0,
      selectedDrawerItem: "Home",
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.30,
                child: Image.asset(
                  AppResources.bgImageDashboard,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.white.withValues(alpha: 0.35)),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          _buildSearchBar(),
                          const SizedBox(height: 12),
                          _buildBanner(),
                          const SizedBox(height: 10),
                          _buildSectionHeader(
                            "Categories",
                            "See All",
                          ),
                          const SizedBox(height: 8),
                          _buildCategories(),
                          const SizedBox(height: 15),
                          _buildSectionHeader(
                            "Featured Products",
                            "See All",
                          ),
                          const SizedBox(height: 8),
                          _buildFeaturedGrid(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "serif",
          ),
        ),
        TextButton(
          onPressed: () {
            if (title == "Categories") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoriesScreen()),
              );
            }

            if (title == "Featured Products" ||
                title == "Featured") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SelectedCategoryScreen(category: "All"),
                ),
              );
            }
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "serif",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, size: 28, color: Colors.black),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                  },
                  child: const Icon(
                    Icons.clear,
                    size: 20,
                    color: Colors.black54,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Image.asset(AppResources.homeBanner, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 3,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(cat["image"]!, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedGrid() {
    final wishlistService = context.watch<WishlistService>();

    return StreamBuilder<List<ProductModel>>(
      stream: _productService.getProductsStream(
        searchQuery: _searchController.text.trim(),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(
                color: AppResources.primaryColor,
              ),
            ),
          );
        }

        final List<ProductModel> products = snapshot.data ?? [];

        final screenWidth = MediaQuery.of(context).size.width;
        final cardWidth = (screenWidth - 42) / 2;
        final cardHeight = cardWidth / 1.15 + 100;

        if (products.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            alignment: Alignment.center,
            child: const Text(
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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 18,
            mainAxisSpacing: 14,
            mainAxisExtent: cardHeight,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final isWishlisted = wishlistService.isProductWishlisted(
              product,
            );

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailItemScreen(productModel: product),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.15,
                            child: _buildProductImage(product.image),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 5, 8, 7),
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "serif",
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        wishlistService.toggleWishlist(
                                          product,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(
                                          isWishlisted
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 23,
                                          color: isWishlisted
                                              ? const Color(0xFFB56F6F)
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      "4.5",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
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
                                      const SizedBox(width: 5),
                                      Text(
                                        "₹${product.oldPrice!.toStringAsFixed(product.oldPrice! % 1 == 0 ? 0 : 2)}",
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Colors.red,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ],
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
          },
        );
  }
}
