import 'package:devart/common/app_shell.dart';
import 'package:devart/data/local_data.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:devart/user_panel/selected_category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ProductService _productService = ProductService.instance;
  int selectedCategory = 0;

  final List<String> categories = [
    "All",
    "Cushion Covers",
    "Toran",
    "Sofa Covers",
    "Bedsheet",
    "Pottery",
    "Handicrafts",
  ];

  late final List<Map<String, String>> _categoryCards;

  @override
  void initState() {
    super.initState();
    _categoryCards = LocalData.getCategories();
  }

  Widget _buildProductImage(String imagePath) {
    return Image.asset(
      imagePath.isNotEmpty ? imagePath : AppResources.placeholderProduct,
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
      selectedIndex: 1,
      selectedDrawerItem: "Categories",
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppResources.bgImageHome,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              _buildTitle(),
              _buildCategoryList(),
              Expanded(child: _buildProductGrid()),
            ],
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
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });

              if (index != 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SelectedCategoryScreen(category: categories[index]),
                  ),
                );
              }
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
    return StreamBuilder<List<ProductModel>>(
      stream: _productService.getProductsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppResources.primaryColor,
            ),
          );
        }
        final products = snapshot.data ?? [];

        // Count products dynamically per category if available
        Map<String, int> counts = {};
        for (final p in products) {
          final cat = p.category.trim();
          counts[cat] = (counts[cat] ?? 0) + 1;
        }

        final activeCategory = categories[selectedCategory];

        final displayCards = activeCategory == "All"
            ? _categoryCards
            : _categoryCards
                .where((c) =>
                    c["name"]!.toLowerCase().replaceAll(" ", "") ==
                    activeCategory.toLowerCase().replaceAll(" ", ""))
                .toList();

        final cardsToShow = displayCards.isNotEmpty ? displayCards : _categoryCards;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 90),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 22,
            mainAxisSpacing: 27,
            childAspectRatio: 0.72,
          ),
          itemCount: cardsToShow.length,
          itemBuilder: (context, index) {
            final card = cardsToShow[index];
            final catName = card["name"]!;
            final liveCount = counts[catName] ?? int.tryParse(card["count"] ?? "10") ?? 10;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SelectedCategoryScreen(category: catName),
                  ),
                );
              },
              child: _buildProductCard(
                name: catName,
                count: liveCount.toString(),
                image: card["image"]!,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductCard({
    required String name,
    required String count,
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
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _buildProductImage(image),
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
                    "$count Products",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Row(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
