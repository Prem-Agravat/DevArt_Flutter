import 'package:devart/common/app_shell.dart';
import 'package:devart/user_panel/detail_item.dart';
import 'package:flutter/material.dart';

class SelectedCategoryScreen extends StatefulWidget {
  final String category;

  const SelectedCategoryScreen({super.key, required this.category});

  @override
  State<SelectedCategoryScreen> createState() => _SelectedCategoryScreenState();
}

class _SelectedCategoryScreenState extends State<SelectedCategoryScreen> {
  final Map<String, Map<String, dynamic>> categoryData = {
    "All": {
      "description":
          "Explore our complete collection of premium\nhandcrafted home decor products.",
      "products": [
        {
          "name": "IndigoGeometry",
          "rating": "4.5",
          "price": "₹899",
          "oldPrice": "₹1090",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Traditional Toran",
          "rating": "4.5",
          "price": "₹599",
          "oldPrice": "₹799",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Premium SofaCover",
          "rating": "4.4",
          "price": "₹1299",
          "oldPrice": "₹1599",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Floral Bedsheet",
          "rating": "4.6",
          "price": "₹799",
          "oldPrice": "₹999",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Designer Cushion",
          "rating": "4.5",
          "price": "₹999",
          "oldPrice": "₹1199",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Home Decor",
          "rating": "4.3",
          "price": "₹699",
          "oldPrice": "₹899",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
    },
    "CushionCovers": {
      "description":
          "Premium handmade cushion with timeless\ncraftsmanship and comfort.",
      "products": [
        {
          "name": "IndigoGeometry",
          "rating": "4.5",
          "price": "₹899",
          "oldPrice": "₹1090",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "IndigoGeometry",
          "rating": "4.5",
          "price": "₹899",
          "oldPrice": "₹1090",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "IndigoGeometry",
          "rating": "4.5",
          "price": "₹899",
          "oldPrice": "₹1090",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "IndigoGeometry",
          "rating": "4.5",
          "price": "₹899",
          "oldPrice": "₹1090",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
    },
    "Toran": {
      "description":
          "Beautiful handmade toran designed to add\ntraditional elegance to your home.",
      "products": [
        {
          "name": "Traditional Toran",
          "rating": "4.5",
          "price": "₹599",
          "oldPrice": "₹799",
          "images": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Designer Toran",
          "rating": "4.6",
          "price": "₹699",
          "oldPrice": "₹899",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
    },
    "SofaCovers": {
      "description":
          "Elegant sofa covers crafted for comfort,\nstyle and everyday protection.",
      "products": [
        {
          "name": "Premium SofaCover",
          "rating": "4.4",
          "price": "₹1299",
          "oldPrice": "₹1599",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Designer SofaCover",
          "rating": "4.5",
          "price": "₹1499",
          "oldPrice": "₹1799",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
    },
    "Bedsheet": {
      "description":
          "Premium bedsheets with beautiful designs\nfor a comfortable sleeping experience.",
      "products": [
        {
          "name": "Floral Bedsheet",
          "rating": "4.5",
          "price": "₹799",
          "oldPrice": "₹999",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Cotton Bedsheet",
          "rating": "4.6",
          "price": "₹899",
          "oldPrice": "₹1199",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final data =
        categoryData[widget.category] ??
        {"description": "Explore our premium collection.", "products": []};

    final products = data["products"] as List;
    final description = data["description"] as String;

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
              Expanded(child: _buildProductGrid(products)),
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
                  color: Colors.white.withOpacity(0.7),
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

  Widget _buildProductGrid(List products) {
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
                builder: (_) => DetailItemScreen(product: product),
              ),
            );
          },
          child: _buildProductCard(
            name: product["name"],
            rating: product["rating"],
            price: product["price"],
            oldPrice: product["oldPrice"],
            image: product["image"],
          ),
        );
      },
    );
  }

  Widget _buildProductCard({
    required String name,
    required String rating,
    required String price,
    required String oldPrice,
    required String image,
  }) {
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
            child: Image.asset(
              image,
              width: double.infinity,
              fit: BoxFit.cover,
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
                          name,
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
                  Row(
                    children: [
                      const Icon(Icons.star_border, size: 18),
                      const SizedBox(width: 2),
                      Text(
                        rating,
                        style: const TextStyle(
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
                        price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        oldPrice,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
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
