import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  String category = "Pottery";
  int stock = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return _successDialog(
          dialogContext,
          "Product Added!",
          "Product successfully added.",
          () {
            Navigator.pop(dialogContext);
            Navigator.pop(context);
          },
        );
      },
    );
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
                                    return "Invalid";
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

                    _buildLabel("Stock Quantity"),

                    _buildStockCounter(),

                    const SizedBox(height: 17),

                    _buildLabel("Description"),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
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
            onPressed: () {
              Navigator.pop(context);
            },
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
    return SizedBox(
      height: 280,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 225,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFD8BBA9), width: 2),
              ),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(15),
                child: const Column(
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

                    SizedBox(height: 15),

                    Text(
                      "Tap to upload product photo",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "High resolution PNG or JPG",
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 28),

          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_smallImageBox(), _smallImageBox(), _smallImageBox()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallImageBox() {
    return Container(
      height: 87,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8BBA9), width: 2),
      ),
      child: const Center(
        child: CircleAvatar(
          radius: 23,
          backgroundColor: Color(0xFFD0E3FF),
          child: Icon(
            Icons.add_a_photo_outlined,
            size: 27,
            color: Color(0xFF704522),
          ),
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
        borderSide: const BorderSide(color: Color(0xFFA06D42), width: 2),
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
            setState(() {
              category = value!;
            });
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
            width: 30,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE3E3E3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.remove, size: 20),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD8BBA9)),
            ),
            child: Text(
              "$stock",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(width: 15),

        GestureDetector(
          onTap: () {
            setState(() {
              stock++;
            });
          },
          child: Container(
            width: 30,
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
        color: Colors.white.withOpacity(0.9),
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
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF704522),
                  side: const BorderSide(color: Color(0xFF704522)),
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

          const SizedBox(width: 5),

          Expanded(
            flex: 2,
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  "Save Product",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF704522),
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
