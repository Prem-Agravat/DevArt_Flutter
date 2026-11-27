import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/product_service.dart';

/// Admin screen for creating a new product in the inventory.
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String category = "Cushion Covers";
  int stock = 10;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _imageController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _oldPriceController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppResources.primaryColor),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final double price = double.parse(_priceController.text.trim());
      final double? oldPrice = _oldPriceController.text.trim().isNotEmpty
          ? double.tryParse(_oldPriceController.text.trim())
          : null;

      final newProduct = ProductModel(
        id: "prod_${DateTime.now().millisecondsSinceEpoch}",
        name: _nameController.text.trim(),
        category: category,
        price: price,
        oldPrice: oldPrice,
        stock: stock,
        description: _descriptionController.text.trim(),
        image: _imageController.text.trim().isNotEmpty
            ? _imageController.text.trim()
            : AppResources.placeholderProduct,
      );

      await ProductService.instance.addProduct(newProduct);

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      setState(() {
        _isSaving = false;
      });

      showDialog(
        context: context,
        builder: (dialogContext) {
          return _successDialog(
            dialogContext,
            "Product Added!",
            "Product successfully added to inventory.",
            () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save product: $e"),
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
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(13, 15, 13, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(),
                    const SizedBox(height: 24),
                    _buildLabel("Product Name"),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        "e.g. Handcrafted Ceramic Vase",
                        Icons.edit,
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
                              _buildCategoryDropdown(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Price (₹)"),
                              TextFormField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration("0.00", null),
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
                              _buildLabel("Old / Original Price (₹)"),
                              TextFormField(
                                controller: _oldPriceController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration("Optional", null),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Stock Quantity"),
                              _buildStockCounter(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    _buildLabel("Asset Image (Optional)"),
                    TextFormField(
                      controller: _imageController,
                      decoration: _inputDecoration(
                        "lib/assets/images/devart_product_1.webp (or leave blank for default)",
                        Icons.image_outlined,
                      ),
                    ),
                    const SizedBox(height: 17),
                    _buildLabel("Description"),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Tell the story behind this piece...",
                        hintStyle: TextStyle(color: Colors.black54),
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
                            color: AppResources.primaryColor,
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
                    const SizedBox(height: 18),
                    _buildBottomButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
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
          const Expanded(
            child: Center(
              child: Text(
                "Add New Product",
                style: TextStyle(
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

  Widget _buildImageSection() {
    final imageText = _imageController.text.trim();
    final hasImage = imageText.isNotEmpty;

    return SizedBox(
      height: 220,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFD8BBA9), width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imageText,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      AppResources.placeholderProduct,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Preview",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFD0E3FF),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      size: 35,
                      color: Color(0xFF704522),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Product Image Preview",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Artisan local image asset or default artwork will be used",
                    style: TextStyle(fontSize: 11, color: Colors.black45),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData? icon) {
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
        borderSide: const BorderSide(color: AppResources.primaryColor, width: 2),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
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
            DropdownMenuItem(
              value: "Cushion Covers",
              child: Text("Cushion Covers"),
            ),
            DropdownMenuItem(value: "Toran", child: Text("Toran")),
            DropdownMenuItem(value: "Sofa Covers", child: Text("Sofa Covers")),
            DropdownMenuItem(value: "Bedsheet", child: Text("Bedsheet")),
            DropdownMenuItem(value: "Pottery", child: Text("Pottery")),
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

  Widget _buildStockCounter() {
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
              color: const Color(0xFFE3E3E3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.remove, size: 20),
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
              color: const Color(0xFFE3E3E3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: _isSaving ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppResources.primaryColor,
                  side: const BorderSide(color: AppResources.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveProduct,
                icon: const Icon(Icons.check_circle_outline),
                label: Text(
                  _isSaving ? "Saving..." : "Save Product",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppResources.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
                backgroundColor: AppResources.primaryColor,
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
