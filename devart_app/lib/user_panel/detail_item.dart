import 'package:flutter/material.dart';
import 'package:devart/common/app_shell.dart';

class DetailItemScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const DetailItemScreen({super.key, required this.product});

  @override
  State<DetailItemScreen> createState() => _DetailItemScreenState();
}

class _DetailItemScreenState extends State<DetailItemScreen> {
  int selectedImage = 0;
  int quantity = 1;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final List<String> images = product["images"] != null
        ? List<String>.from(product["images"])
        : [product["image"]];

    final List<String> sizes = product["sizes"] != null
        ? List<String>.from(product["sizes"])
        : ["16×16"];

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
              _buildTitle(product["name"]),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 95),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImages(images),
                      _buildProductInfo(product, sizes),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildAddToCart(),
        ],
      ),
    );
  }

  Widget _buildTitle(String name) {
    return Container(
      height: 59,
      width: double.infinity,
      color: const Color(0xFFF5E9E5),
      alignment: Alignment.center,
      child: const Text(
        "Detail-Item",
        style: TextStyle(
          fontSize: 31,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB56F6F),
        ),
      ),
    );
  }

  Widget _buildImages(List<String> images) {
    return SizedBox(
      height: 310,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFD8C8A5),
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        images[selectedImage],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      return Container(
                        width: 9,
                        height: 9,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedImage == index
                              ? Colors.grey
                              : Colors.grey.shade400,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30),
            SizedBox(
              width: 91,
              child: Column(
                children: List.generate(images.length > 4 ? 4 : images.length, (
                  index,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImage = index;
                        });
                      },
                      child: Container(
                        height: 72,
                        width: 91,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedImage == index
                                ? const Color(0xFFA06D42)
                                : const Color(0xFFD8C8A5),
                            width: selectedImage == index ? 2 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(images[index], fit: BoxFit.cover),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(Map<String, dynamic> product, List<String> sizes) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product["name"],
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
              ),
              Text(
                product["price"],
                style: const TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  fontFamily: "serif",
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  product["oldPrice"],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(Icons.star, size: 18, color: Colors.black),
              const Icon(Icons.star, size: 18, color: Colors.black),
              const Icon(Icons.star, size: 18, color: Colors.black),
              const Icon(Icons.star, size: 18, color: Colors.black),
              const Icon(Icons.star_border, size: 18, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                "${product["rating"]} (${product["reviews"]} Reviews)",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Size",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: sizes.map((size) {
              final selected = selectedSize == size;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSize = size;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFA06D42)
                        : const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Text(
                          "-",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "$quantity",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Text(
                          "+",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCart() {
    return Positioned(
      left: 60,
      right: 60,
      bottom: 20,
      child: SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          label: const Text(
            "Add To Cart",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA06D42),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
    );
  }
}
