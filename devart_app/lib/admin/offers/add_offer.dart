import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';
import 'package:devart/models/offer_model.dart';
import 'package:devart/services/offer_service.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final OfferService _offerService = OfferService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _minSpendController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _discountType = "Percentage"; // "Percentage" or "Fixed"
  String _status = "Active"; // "Active" or "Expired"
  DateTime _validFrom = DateTime.now();
  DateTime _validUntil = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _discountController.dispose();
    _minSpendController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickValidFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _validFrom,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF704522),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _validFrom = picked;
        if (_validUntil.isBefore(_validFrom)) {
          _validUntil = _validFrom.add(const Duration(days: 7));
        }
      });
    }
  }

  Future<void> _pickValidUntilDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _validUntil.isBefore(_validFrom) ? _validFrom : _validUntil,
      firstDate: _validFrom,
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF704522),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _validUntil = picked;
      });
    }
  }

  Future<void> _saveOffer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final discountVal = double.tryParse(_discountController.text.trim()) ?? 0.0;
    if (_discountType == "Percentage" && (discountVal <= 0 || discountVal > 100)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Percentage discount must be between 1% and 100%"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_discountType == "Fixed" && discountVal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fixed discount must be greater than ₹0"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final double? minSpendVal = _minSpendController.text.trim().isNotEmpty
        ? double.tryParse(_minSpendController.text.trim())
        : null;

    setState(() {
      _isLoading = true;
    });

    try {
      final newOffer = OfferModel(
        id: '',
        title: _titleController.text.trim(),
        code: _codeController.text.trim().toUpperCase(),
        discount: discountVal,
        discountType: _discountType,
        validFrom: _validFrom,
        validUntil: _validUntil,
        status: _status,
        description: _descriptionController.text.trim(),
        minSpend: minSpendVal,
        createdAt: DateTime.now(),
      );

      await _offerService.addOffer(newOffer);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save offer: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                backgroundColor: Color(0xFFC9E0FF),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 38,
                  color: Color(0xFF496B8D),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Offer Added!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "The offer has been successfully saved to database.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA06D42),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Back to Offers",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isPercentage = _discountType == "Percentage";

    return AdminShell(
      selectedIndex: 3,
      child: Column(
        children: [
          _buildTitle(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Offer Title"),
                    _buildTextField(
                      controller: _titleController,
                      hint: "e.g. Festive Special",
                      icon: Icons.local_offer_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter offer title";
                        }
                        if (value.trim().length < 3) {
                          return "Title must be at least 3 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    _buildLabel("Promo Code"),
                    _buildTextField(
                      controller: _codeController,
                      hint: "e.g. FESTIVE20",
                      icon: Icons.confirmation_number_outlined,
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter promo code";
                        }
                        if (value.trim().length < 3) {
                          return "Code must be at least 3 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Discount Type"),
                              _buildDropdown(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(
                                isPercentage ? "Discount (%)" : "Discount (₹)",
                              ),
                              _buildDiscountField(isPercentage),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Valid From"),
                              _buildDateSelector(
                                date: _validFrom,
                                onTap: _pickValidFromDate,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Valid Until"),
                              _buildDateSelector(
                                date: _validUntil,
                                onTap: _pickValidUntilDate,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Min Spend (₹) (Optional)"),
                              _buildTextField(
                                controller: _minSpendController,
                                hint: "e.g. 999",
                                icon: Icons.currency_rupee,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Initial Status"),
                              _buildStatusDropdown(),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _buildLabel("Description (Optional)"),
                    _buildTextField(
                      controller: _descriptionController,
                      hint: "e.g. Flat 20% off on all terracotta pottery items",
                      icon: Icons.description_outlined,
                      maxLines: 2,
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _saveOffer,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check_circle_outline),
                        label: Text(
                          _isLoading ? "Saving Offer..." : "Save Offer",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF704522),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: Colors.black,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Add New Offer",
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF704522), size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8BBA9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFA06D42), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDiscountField(bool isPercentage) {
    return TextFormField(
      controller: _discountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: isPercentage ? "20" : "500",
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
        prefixIcon: isPercentage
            ? const Icon(Icons.percent, color: Color(0xFF704522), size: 19)
            : const Icon(Icons.currency_rupee, color: Color(0xFF704522), size: 19),
        suffixText: isPercentage ? "%" : "₹",
        suffixStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Color(0xFF704522),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8BBA9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFA06D42), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Enter discount";
        }
        final parsed = double.tryParse(value.trim());
        if (parsed == null || parsed <= 0) {
          return "Invalid";
        }
        if (isPercentage && parsed > 100) {
          return "Max 100%";
        }
        return null;
      },
    );
  }

  Widget _buildDropdown() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8BBA9)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _discountType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF704522), size: 20),
          items: const [
            DropdownMenuItem(
              value: "Percentage",
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.percent, size: 16, color: Color(0xFF704522)),
                  SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      "Percentage",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "Fixed",
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.currency_rupee, size: 16, color: Color(0xFF704522)),
                  SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      "Fixed (₹)",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _discountType = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8BBA9)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _status,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF704522), size: 20),
          items: const [
            DropdownMenuItem(
              value: "Active",
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 15, color: Colors.green),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      "Active",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "Expired",
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel, size: 15, color: Colors.red),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      "Expired",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _status = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD8BBA9)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Color(0xFF704522),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                OfferModel.formatDate(date),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
