import 'package:devart/common/app_shell.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/cart_service.dart';
import 'package:devart/user_panel/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final currentProduct = widget.productModel ??
        ProductModel(
          id: widget.product?["name"]?.toString().toLowerCase().replaceAll(" ", "_") ??
              "item_${DateTime.now().millisecondsSinceEpoch}",
          name: widget.product?["name"]?.toString() ?? "Detail-Item",
          category: widget.product?["category"]?.toString() ?? "Cushion Covers",
          price: double.tryParse(
                  widget.product?["price"]?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ??
                      "899") ??
              899.0,
          oldPrice: double.tryParse(widget.product?["oldPrice"]
                  ?.toString()
                  .replaceAll(RegExp(r'[^0-9.]'), '') ??
              ""),
          stock: 10,
          description: widget.product?["description"]?.toString() ?? "",
          image: widget.product?["image"]?.toString() ??
              AppResources.placeholderProduct,
        );

    final name = currentProduct.name;
    final priceStr =
        "₹${currentProduct.price.toStringAsFixed(currentProduct.price % 1 == 0 ? 0 : 2)}";
    final oldPriceStr = currentProduct.oldPrice != null
        ? "₹${currentProduct.oldPrice!.toStringAsFixed(currentProduct.oldPrice! % 1 == 0 ? 0 : 2)}"
        : "";
    final singleImage = currentProduct.image.isNotEmpty
        ? currentProduct.image
        : AppResources.placeholderProduct;

    final List<String> images = widget.product?["images"] != null
        ? List<String>.from(widget.product!["images"])
        : [singleImage];

    final List<String> sizes = widget.product?["sizes"] != null
        ? List<String>.from(widget.product!["sizes"])
        : ["16×16", "18×18", "20×20"];

    final rating = widget.product?["rating"]?.toString() ?? "4.5";
    final reviews = widget.product?["reviews"]?.toString() ?? "109";
    final description = currentProduct.description;
    final isOutOfStock = currentProduct.stock <= 0;

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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 95),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImages(images),
                      _buildProductInfo(
                        product: currentProduct,
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
          _buildAddToCart(currentProduct, isOutOfStock),
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
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black54, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const Text(
            "Detail-Item",
            style: TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB56F6F),
              fontFamily: "serif",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImages(List<String> images) {
    final validIndex = selectedImage < images.length ? selectedImage : 0;

    if (images.length <= 1) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD8C8A5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildImageWidget(images[validIndex]),
        ),
      );
    }

    return SizedBox(
      height: 310,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
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
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFD8C8A5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                              ? AppResources.primaryColor
                              : Colors.grey.shade400,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 88,
              child: Column(
                children: List.generate(images.length > 4 ? 4 : images.length, (
                  index,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          selectedImage = index;
                        });
                      },
                      child: Container(
                        height: 68,
                        width: 88,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: validIndex == index
                                ? AppResources.primaryColor
                                : const Color(0xFFD8C8A5),
                            width: validIndex == index ? 2.5 : 1,
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
    required ProductModel product,
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: "serif",
                    ),
                  ),
                  if (oldPrice.isNotEmpty) ...[
                    Text(
                      oldPrice,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, size: 18, color: Colors.amber),
              const Icon(Icons.star, size: 18, color: Colors.amber),
              const Icon(Icons.star, size: 18, color: Colors.amber),
              const Icon(Icons.star, size: 18, color: Colors.amber),
              const Icon(Icons.star_half, size: 18, color: Colors.amber),
              const SizedBox(width: 6),
              Text(
                "$rating ($reviews Reviews)",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A4A4A),
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 14),
          const Text(
            "Size",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: sizes.map((size) {
              final selected = (selectedSize ?? sizes.first) == size;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    selectedSize = size;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppResources.primaryColor
                        : const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppResources.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
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
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                "Quantity",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
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
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "+",
                          style: TextStyle(
                            fontSize: 20,
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

  Widget _buildAddToCart(ProductModel product, bool isOutOfStock) {
    return Positioned(
      left: 50,
      right: 50,
      bottom: 20,
      child: SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          onPressed: isOutOfStock
              ? null
              : () {
                  context.read<CartService>().addItem(
                        product,
                        quantity: quantity,
                        size: selectedSize ?? "16×16",
                      );

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
            backgroundColor: AppResources.primaryColor,
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
