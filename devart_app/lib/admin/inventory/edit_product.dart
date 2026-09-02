import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/services/product_service.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();

  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController oldPriceController;
  late final TextEditingController imageUrlController;
  late final TextEditingController descriptionController;

  late String category;
  late int stock;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(
      text: widget.product.price % 1 == 0
          ? widget.product.price.toInt().toString()
          : widget.product.price.toString(),
    );
    oldPriceController = TextEditingController(
      text: widget.product.oldPrice != null
          ? (widget.product.oldPrice! % 1 == 0
              ? widget.product.oldPrice!.toInt().toString()
              : widget.product.oldPrice!.toString())
          : "",
    );
    imageUrlController = TextEditingController(
      text: widget.product.image.startsWith("http") ? widget.product.image : "",
    );
    descriptionController = TextEditingController(
      text: widget.product.description,
    );
    category = widget.product.category;
    stock = widget.product.stock;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    oldPriceController.dispose();
    imageUrlController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF704522)),
      ),
    );

    try {
      final double price = double.parse(priceController.text.trim());
      final double? oldPrice = oldPriceController.text.trim().isNotEmpty
          ? double.tryParse(oldPriceController.text.trim())
          : null;

      final updatedProduct = widget.product.copyWith(
        name: nameController.text.trim(),
        category: category,
        price: price,
        oldPrice: oldPrice,
        stock: stock,
        description: descriptionController.text.trim(),
        image: imageUrlController.text.trim().isNotEmpty
            ? imageUrlController.text.trim()
            : widget.product.image,
      );

      await _productService.updateProduct(updatedProduct);

      if (!mounted) return;
      Navigator.pop(context); // close loading

      setState(() {
        _isUpdating = false;
      });

      showDialog(
        context: context,
        builder: (dialogContext) {
          return _successDialog(
            dialogContext,
            "Product Updated!",
            "Product changes saved successfully.",
            () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // close loading

      setState(() {
        _isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating product: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteProduct() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFFFD7D7),
                child: Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                  size: 35,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Delete Product",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to delete\n\"${widget.product.name}\"? This action cannot be undone.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, height: 1.4),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    await _executeDelete();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Delete Product",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _executeDelete() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF704522)),
      ),
    );

    try {
      await _productService.deleteProduct(widget.product.id);
      if (!mounted) return;
      Navigator.pop(context); // close loading

      showDialog(
        context: context,
        builder: (dialogContext) {
          return _successDialog(
            dialogContext,
            "Product Deleted!",
            "Product has been removed from inventory.",
            () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting product: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: 1,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTitle("Edit Product"),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(13, 15, 13, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGallery(),
                    const SizedBox(height: 20),
                    _buildLabel("Product Name"),
                    TextFormField(
                      controller: nameController,
                      decoration: _inputDecoration(
                        Icons.edit,
                        "Product Name",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Product name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 17),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Category"),
                              _buildCategory(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Price (₹)"),
                              TextFormField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(null, "0.00"),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Required";
                                  }
                                  if (double.tryParse(value) == null) {
                                    return "Invalid number";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Old Price (₹)"),
                              TextFormField(
                                controller: oldPriceController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(null, "Optional"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Stock Quantity"),
                              _buildStock(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    _buildLabel("Image URL (Optional)"),
                    TextFormField(
                      controller: imageUrlController,
                      decoration: _inputDecoration(
                        Icons.image_outlined,
                        "https://example.com/image.jpg",
                      ),
                    ),
                    const SizedBox(height: 17),
                    _buildLabel("Description"),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Color(0xFFD8BBA9)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Color(0xFFA06D42),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Description is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _isUpdating ? null : _updateProduct,
                        icon: const Icon(Icons.save_outlined),
                        label: Text(
                          _isUpdating ? "Saving..." : "Update Changes",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF704522),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: _isUpdating ? null : _deleteProduct,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "Delete Product",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      height: 59,
      width: double.infinity,
      color: const Color(0xFFF5E9E5),
      alignment: Alignment.center,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 25,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB56F6F),
                  fontFamily: "serif",
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildGallery() {
    final imagePath = widget.product.image;
    return SizedBox(
      height: 200,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD8BBA9), width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: imagePath.startsWith("http")
              ? Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'lib/assets/images/devart_product_1.webp',
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  imagePath.isNotEmpty
                      ? imagePath
                      : 'lib/assets/images/devart_product_1.webp',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  InputDecoration _inputDecoration(IconData? icon, String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD8BBA9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFA06D42), width: 2),
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8BBA9)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: category,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: const [
            DropdownMenuItem(value: "Pottery", child: Text("Pottery")),
            DropdownMenuItem(
              value: "Cushion Covers",
              child: Text("Cushion Covers"),
            ),
            DropdownMenuItem(value: "Toran", child: Text("Toran")),
            DropdownMenuItem(value: "Sofa Covers", child: Text("Sofa Covers")),
            DropdownMenuItem(value: "Handicrafts", child: Text("Handicrafts")),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                category = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildStock() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (stock > 1) {
              setState(() {
                stock--;
              });
            }
          },
          child: Container(
            width: 32,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E2E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.remove),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD8BBA9)),
            ),
            child: Text(
              "$stock",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              stock++;
            });
          },
          child: Container(
            width: 32,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E2E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _successDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onPressed,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      contentPadding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFC9E0FF),
            child: Icon(
              Icons.check_circle_outline,
              size: 38,
              color: Color(0xFF496B8D),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA06D42),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Return to Inventory",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
