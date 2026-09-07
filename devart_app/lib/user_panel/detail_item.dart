import 'package:devart/models/product_model.dart';
import 'package:devart/user_panel/cart.dart';
import 'package:flutter/material.dart';
import 'package:devart/common/app_shell.dart';

class DetailItemScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  final ProductModel? productModel;

  const DetailItemScreen({
    super.key,
    this.product,
    this.productModel,
  }) : assert(product != null || productModel != null, "Either product or productModel must be provided");

  @override
  State<DetailItemScreen> createState() => _DetailItemScreenState();
}

class _DetailItemScreenState extends State<DetailItemScreen> {
  int selectedImage = 0;
  int quantity = 1;
  String? selectedSize;

  Widget _buildImageWidget(String imagePath) {
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
    final name = widget.productModel?.name ?? widget.product?["name"]?.toString() ?? "Detail-Item";
    final priceStr = widget.productModel != null
        ? "₹${widget.productModel!.price.toStringAsFixed(widget.productModel!.price % 1 == 0 ? 0 : 2)}"
        : (widget.product?["price"]?.toString() ?? "₹0");
    final oldPriceStr = widget.productModel != null
        ? (widget.productModel!.oldPrice != null
            ? "₹${widget.productModel!.oldPrice!.toStringAsFixed(widget.productModel!.oldPrice! % 1 == 0 ? 0 : 2)}"
            : "")
        : (widget.product?["oldPrice"]?.toString() ?? "");
    final singleImage = widget.productModel?.image ??
        widget.product?["image"]?.toString() ??
        "lib/assets/images/devart_product_1.webp";

    final List<String> images = widget.product?["images"] != null
        ? List<String>.from(widget.product!["images"])
        : [singleImage];

    final List<String> sizes = widget.product?["sizes"] != null
        ? List<String>.from(widget.product!["sizes"])
        : ["16×16", "18×18", "20×20"];

    final rating = widget.product?["rating"]?.toString() ?? "4.5";
    final reviews = widget.product?["reviews"]?.toString() ?? "109";
    final description = widget.productModel?.description ?? widget.product?["description"]?.toString() ?? "";
    final isOutOfStock = widget.productModel != null && widget.productModel!.stock <= 0;

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
              _buildTitle(name),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 95),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImages(images),
                      _buildProductInfo(
                        name: name,
                        price: priceStr,
                        oldPrice: oldPriceStr,
                        rating: rating,
                        reviews: reviews,
                        sizes: sizes,
                        description: description,
                        isOutOfStock: isOutOfStock,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildAddToCart(isOutOfStock),
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
          fontFamily: "serif",
        ),
      ),
    );
  }

  Widget _buildImages(List<String> images) {
    final validIndex = selectedImage < images.length ? selectedImage : 0;

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
                      child: _buildImageWidget(images[validIndex]),
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
                          color: validIndex == index
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
                            color: validIndex == index
                                ? const Color(0xFFA06D42)
                                : const Color(0xFFD8C8A5),
                            width: validIndex == index ? 2 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _buildImageWidget(images[index]),
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

  Widget _buildProductInfo({
    required String name,
    required String price,
    required String oldPrice,
    required String rating,
    required String reviews,
    required List<String> sizes,
    required String description,
    required bool isOutOfStock,
  }) {
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
                  name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  fontFamily: "serif",
                ),
              ),
              if (oldPrice.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    oldPrice,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
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
                "$rating ($reviews Reviews)",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isOutOfStock) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Out of Stock",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            "Size",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: sizes.map((size) {
              final selected = (selectedSize ?? sizes.first) == size;

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

  Widget _buildAddToCart(bool isOutOfStock) {
    return Positioned(
      left: 60,
      right: 60,
      bottom: 20,
      child: SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          onPressed: isOutOfStock
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          label: Text(
            isOutOfStock ? "Out of Stock" : "Add To Cart",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA06D42),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade400,
            disabledForegroundColor: Colors.white70,
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
