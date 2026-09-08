import 'package:devart/common/app_shell.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/services/product_service.dart';
import 'package:devart/user_panel/detail_item.dart';
import 'package:flutter/material.dart';
import 'package:devart/user_panel/categories.dart';
import 'package:devart/user_panel/selected_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();
  final Set<String> _wishlisted = {};

  final List<Map<String, String>> _categories = [
    {"name": "Cushion Covers", "image": "lib/assets/images/devart_product_1.webp"},
    {"name": "Toran", "image": "lib/assets/images/devart_product_1.webp"},
    {"name": "Pottery", "image": "lib/assets/images/devart_product_1.webp"},
    {"name": "Sofa Covers", "image": "lib/assets/images/devart_product_1.webp"},
  ];

  final List<ProductModel> _fallbackProducts = [
    ProductModel(
      id: 'p1',
      name: 'IndigoGeometry Cushion',
      category: 'Cushion Covers',
      price: 899.0,
      oldPrice: 1099.0,
      stock: 15,
      description: 'Hand-dyed indigo fabric with unique geometric patterns.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
    ProductModel(
      id: 'p2',
      name: 'Handcrafted Toran',
      category: 'Toran',
      price: 1299.0,
      oldPrice: 1599.0,
      stock: 8,
      description: 'Traditional doorway hanging crafted with vibrant patches.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
    ProductModel(
      id: 'p3',
      name: 'Terracotta Ceramic Vase',
      category: 'Pottery',
      price: 749.0,
      oldPrice: 899.0,
      stock: 12,
      description: 'Earthy clay pottery vase fired with natural glazes.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
    ProductModel(
      id: 'p4',
      name: 'Artisan Embroidered Sofa Cover',
      category: 'Sofa Covers',
      price: 1899.0,
      oldPrice: 2299.0,
      stock: 6,
      description: 'Luxurious hand-embroidered sofa slip cover.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
    ProductModel(
      id: 'p5',
      name: 'Handmade Wooden Wall Hanging',
      category: 'Handicrafts',
      price: 1199.0,
      oldPrice: 1499.0,
      stock: 10,
      description: 'Intricately carved wooden wall panel.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
    ProductModel(
      id: 'p6',
      name: 'Floral Handloom Bedsheet',
      category: 'Bedsheet',
      price: 999.0,
      oldPrice: 1299.0,
      stock: 14,
      description: 'Pure cotton floral handloom printed sheet.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
  ];

  @override
  void initState() {
    super.initState();
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
    if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          "lib/assets/images/devart_product_1.webp",
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        "lib/assets/images/devart_product_1.webp",
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
                  "lib/assets/images/devart_bgimg_dashboard.png",
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
                          _buildSectionHeader("Categories", "Seeall"),
                          const SizedBox(height: 8),
                          _buildCategories(),
                          const SizedBox(height: 15),
                          _buildSectionHeader("Featured", "Seeall"),
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

            if (title == "Featured") {
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
                  child: const Icon(Icons.clear, size: 20, color: Colors.black54),
                )
              : null,
          hintText: "Search",
          hintStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
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
        child: Image.asset(
          "lib/assets/images/devart_new_arrival.webp",
          fit: BoxFit.cover,
        ),
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
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectedCategoryScreen(category: cat["name"]!),
                ),
              );
            },
            child: Container(
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
                child: Image.asset(
                  cat["image"]!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedGrid() {
    return StreamBuilder<List<ProductModel>>(
      stream: _productService.getProductsStream(
        searchQuery: _searchController.text.trim(),
      ),
      builder: (context, snapshot) {
        List<ProductModel> products = _fallbackProducts;

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          products = snapshot.data!;
        } else if (_searchController.text.trim().isNotEmpty) {
          final q = _searchController.text.trim().toLowerCase();
          products = _fallbackProducts
              .where((p) =>
                  p.name.toLowerCase().contains(q) ||
                  p.category.toLowerCase().contains(q) ||
                  p.description.toLowerCase().contains(q))
              .toList();
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final cardWidth = (screenWidth - 42) / 2;
        final cardHeight = cardWidth / 1.15 + 88;

        if (products.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            alignment: Alignment.center,
            child: const Text(
              "No products found",
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
            final productId = product.id.isNotEmpty ? product.id : "prod_$index";
            final isWishlisted = _wishlisted.contains(productId);

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
                  borderRadius: BorderRadius.circular(18),
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
                        top: Radius.circular(18),
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
                                  onTap: () {
                                    setState(() {
                                      if (isWishlisted) {
                                        _wishlisted.remove(productId);
                                      } else {
                                        _wishlisted.add(productId);
                                      }
                                    });
                                  },
                                  child: Icon(
                                    isWishlisted
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 23,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Row(
                              children: [
                                Icon(Icons.star_border, size: 18),
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
                                      decoration: TextDecoration.lineThrough,
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
