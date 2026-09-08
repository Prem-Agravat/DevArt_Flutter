import 'package:devart/common/app_shell.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/services/product_service.dart';
import 'package:devart/user_panel/detail_item.dart';
import 'package:flutter/material.dart';

class SelectedCategoryScreen extends StatefulWidget {
  final String category;

  const SelectedCategoryScreen({super.key, required this.category});

  @override
  State<SelectedCategoryScreen> createState() => _SelectedCategoryScreenState();
}

class _SelectedCategoryScreenState extends State<SelectedCategoryScreen> {
  final ProductService _productService = ProductService();

  final Map<String, String> categoryDescriptions = {
    "All": "Explore our complete collection of premium\nhandcrafted home decor products.",
    "Cushion Covers": "Premium handmade cushion with timeless\ncraftsmanship and comfort.",
    "CushionCovers": "Premium handmade cushion with timeless\ncraftsmanship and comfort.",
    "Toran": "Beautiful handmade toran designed to add\ntraditional elegance to your home.",
    "Sofa Covers": "Elegant sofa covers crafted for comfort,\nstyle and everyday protection.",
    "SofaCovers": "Elegant sofa covers crafted for comfort,\nstyle and everyday protection.",
    "Bedsheet": "Premium bedsheets with beautiful designs\nfor a comfortable sleeping experience.",
    "Bedsheets": "Premium bedsheets with beautiful designs\nfor a comfortable sleeping experience.",
    "Pottery": "Authentic terracotta and clay pottery,\nhandcrafted with rustic natural glazes.",
    "Handicrafts": "Timeless artisan woodwork and traditional\nhandcrafted folk collectibles.",
  };

  final List<ProductModel> _fallbackAll = [
    ProductModel(
      id: 'p1',
      name: 'Traditional Toran',
      category: 'Toran',
      price: 599.0,
      oldPrice: 799.0,
      stock: 10,
      description: 'Traditional doorway hanging with mirror work.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
    ProductModel(
      id: 'p2',
      name: 'Premium SofaCover',
      category: 'Sofa Covers',
      price: 1299.0,
      oldPrice: 1599.0,
      stock: 6,
      description: 'Handcrafted durable sofa cover.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
    ProductModel(
      id: 'p3',
      name: 'Floral Bedsheet',
      category: 'Bedsheet',
      price: 799.0,
      oldPrice: 999.0,
      stock: 12,
      description: 'Pure cotton floral printed bedsheet.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
    ProductModel(
      id: 'p4',
      name: 'Designer Cushion',
      category: 'Cushion Covers',
      price: 999.0,
      oldPrice: 1199.0,
      stock: 15,
      description: 'Handcrafted designer cushion cover.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
    ProductModel(
      id: 'p5',
      name: 'Terracotta Ceramic Vase',
      category: 'Pottery',
      price: 749.0,
      oldPrice: 899.0,
      stock: 8,
      description: 'Earthy clay pottery vase fired with natural glazes.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
  ];

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
    final description = categoryDescriptions[widget.category] ??
        "Explore our premium collection of handcrafted artisan creations.";

    return AppShell(
      selectedIndex: 1,
      selectedDrawerItem: "Categories",
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "lib/assets/images/devart_bgimg_home.png",
              fit: BoxFit.cover,
            ),
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
                    List<ProductModel> products = _fallbackAll;

                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      products = snapshot.data!;
                    } else if (widget.category != "All") {
                      final catNorm = widget.category.toLowerCase().replaceAll(" ", "");
                      products = _fallbackAll
                          .where((p) =>
                              p.category.toLowerCase().replaceAll(" ", "") ==
                              catNorm)
                          .toList();
                      if (products.isEmpty) {
                        products = _fallbackAll;
                      }
                    }

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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15),
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
            child: _buildProductImage(product.image),
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
                      const Icon(Icons.favorite_border, size: 22),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(Icons.star_border, size: 18),
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
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8CB8F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, size: 19),
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
