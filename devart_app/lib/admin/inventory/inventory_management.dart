import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';
import 'package:devart/admin/inventory/add_product.dart';
import 'package:devart/admin/inventory/edit_product.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  int selectedCategory = 0;

  final List<String> categories = [
    "All",
    "Cushion Covers",
    "Toran",
    "Sofa Covers",
    "Handicrafts",
  ];

  final List<Map<String, String>> products = [
    {
      "name": "IndigoGeometry",
      "category": "Handwoven-cotton",
      "price": "₹899",
      "oldPrice": "₹1009",
      "image": "lib/assets/images/devart_product_1.webp",
    },
    {
      "name": "IndigoGeometry",
      "category": "Handwoven-cotton",
      "price": "₹899",
      "oldPrice": "₹1009",
      "image": "lib/assets/images/devart_product_1.webp",
    },
    {
      "name": "IndigoGeometry",
      "category": "Handwoven-cotton",
      "price": "₹899",
      "oldPrice": "₹1009",
      "image": "lib/assets/images/devart_product_1.webp",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: 1,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 59,
                width: double.infinity,
                color: const Color(0xFFF5E9E5),
                alignment: Alignment.center,
                child: const Text(
                  "Manage Inventory",
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB56F6F),
                    fontFamily: "serif",
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(10, 18, 10, 100),
                  child: Column(
                    children: [
                      _buildSearchBox(),
                      const SizedBox(height: 10),
                      _buildCategoryList(),
                      const SizedBox(height: 12),
                      ...products.map(
                        (product) => _buildProductCard(context, product),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 25,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
              child: Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF704522),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, size: 28, color: Colors.black),
          hintText: "Search",
          hintStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          contentPadding: EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 43,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final selected = selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFD1D1D1)
                    : const Color(0xFFE1E1E1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                categories[index],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: "serif",
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, String> product) {
    return Container(
      width: double.infinity,
      height: 124,
      margin: const EdgeInsets.only(bottom: 14, left: 10, right: 10),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(45),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 26),
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(
              product["image"]!,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product["name"]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product["category"]!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    Text(
                      product["price"]!,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: "serif",
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      product["oldPrice"]!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
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
              const Padding(
                padding: EdgeInsets.only(right: 8, top: 5),
                child: Icon(
                  Icons.delete_outline,
                  size: 21,
                  color: Colors.black54,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProductScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 78,
                  height: 34,
                  margin: const EdgeInsets.only(right: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA06D42),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 21),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
