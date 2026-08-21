import 'package:flutter/material.dart';
import 'package:devart/user_panel/selected_category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int selectedCategory = 0;
  int selectedBottomNav = 1;

  final List<String> categories = [
    "All",
    "CushionCovers",
    "Toran",
    "SofaCovers",
    "Bedsheet",
  ];

  final List<Map<String, dynamic>> products = [
    {
      "name": "CushionCovers",
      "price": "25",
      "image": "lib/assets/images/cushion-cover.png",
    },
    {"name": "Toran", "price": "115", "image": "lib/assets/images/toran.png"},
    {
      "name": "SofaCovers",
      "price": "50",
      "image": "lib/assets/images/cushion-cover.png",
    },
    {
      "name": "HomeDecor",
      "price": "66",
      "image": "lib/assets/images/cushion-cover.png",
    },
    {
      "name": "Bedsheets",
      "price": "18",
      "image": "lib/assets/images/cushion-cover.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "lib/assets/images/devart_bgimage_dashboard.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              _buildHeader(),
              _buildTitle(),
              _buildCategoryList(),
              Expanded(child: _buildProductGrid()),
            ],
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 88,
      decoration: const BoxDecoration(color: Color(0xFFBFD5FA)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 20,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, size: 38, color: Colors.black),
            ),
          ),
          Image.asset(
            "lib/assets/images/devart-logo.png",
            width: 72,
            height: 72,
          ),
          Positioned(
            right: 20,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart,
                size: 38,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 67,
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFFF5E9E5)),
      alignment: Alignment.center,
      child: const Text(
        "Categories",
        style: TextStyle(
          fontSize: 31,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB56F6F),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 65,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF0F0F0)
                    : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: isSelected ? 2 : 1,
                  ),
                ),
              ),
              child: Text(
                categories[index],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 90),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 22,
        mainAxisSpacing: 27,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return _buildProductCard(
          name: product["name"],
          price: product["price"],
          image: product["image"],
        );
      },
    );
  }

  Widget _buildProductCard({
    required String name,
    required String price,
    required String image,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
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
              padding: const EdgeInsets.fromLTRB(6, 7, 6, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${price}Product",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Text(
                          "Explore",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_circle_right_outlined, size: 17),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 67,
        decoration: BoxDecoration(
          color: const Color(0xFFBFD5FA).withOpacity(0.95),
          border: const Border(
            top: BorderSide(color: Color(0xFF8FAEDC), width: 1),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomItem(icon: Icons.home_outlined, label: "Home", index: 0),
            _bottomItem(
              icon: Icons.list_alt_outlined,
              label: "Categories",
              index: 1,
            ),
            _bottomItem(
              icon: Icons.inventory_2_outlined,
              label: "Orders",
              index: 2,
            ),
            _bottomItem(
              icon: Icons.account_circle_outlined,
              label: "Account",
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedBottomNav == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBottomNav = index;
        });
      },
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 29, color: Colors.black),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
