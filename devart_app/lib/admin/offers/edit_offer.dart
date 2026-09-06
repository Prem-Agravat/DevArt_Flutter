import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';
import 'package:devart/models/offer_model.dart';
import 'package:devart/services/offer_service.dart';

class EditOfferScreen extends StatefulWidget {
  final OfferModel offer;

  const EditOfferScreen({super.key, required this.offer});

  @override
  State<EditOfferScreen> createState() => _EditOfferScreenState();
}

class _EditOfferScreenState extends State<EditOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final OfferService _offerService = OfferService();

  late TextEditingController _titleController;
  late TextEditingController _codeController;
  late TextEditingController _discountController;
  late TextEditingController _minSpendController;
  late TextEditingController _descriptionController;

  late String _discountType;
  late String _status;
  late DateTime _validFrom;
  late DateTime _validUntil;
  bool _isLoading = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.offer.title);
    _codeController = TextEditingController(text: widget.offer.code);

    final discountVal = widget.offer.discount;
    _discountController = TextEditingController(
      text: (discountVal % 1 == 0)
          ? discountVal.toInt().toString()
          : discountVal.toString(),
    );

    _minSpendController = TextEditingController(
      text: widget.offer.minSpend != null
          ? (widget.offer.minSpend! % 1 == 0
              ? widget.offer.minSpend!.toInt().toString()
              : widget.offer.minSpend!.toString())
          : "",
    );

    _descriptionController =
        TextEditingController(text: widget.offer.description ?? "");

    _discountType = widget.offer.discountType;
    _status = widget.offer.status;
    _validFrom = widget.offer.validFrom ?? DateTime.now();
    _validUntil = widget.offer.validUntil ??
        DateTime.now().add(const Duration(days: 30));
  }

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

  Future<void> _updateOffer() async {
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
      final updatedOffer = widget.offer.copyWith(
        title: _titleController.text.trim(),
        code: _codeController.text.trim().toUpperCase(),
        discount: discountVal,
        discountType: _discountType,
        validFrom: _validFrom,
        validUntil: _validUntil,
        status: _status,
        description: _descriptionController.text.trim(),
        minSpend: minSpendVal,
      );

      await _offerService.updateOffer(updatedOffer);

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
          content: Text("Failed to update offer: $e"),
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
                "Offer Updated!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Offer details have been successfully updated in database.",
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

  Future<void> _executeDelete() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      await _offerService.deleteOffer(widget.offer.id);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Offer deleted successfully."),
          backgroundColor: Color(0xFF704522),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDeleting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete offer: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: const EdgeInsets.fromLTRB(25, 25, 25, 18),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFFFD8D8),
                child: Icon(Icons.delete_outline, size: 35, color: Colors.red),
              ),
              const SizedBox(height: 18),
              const Text(
                "Delete Offer?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Are you sure you want to delete \"${widget.offer.title}\"?",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _executeDelete();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
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
                      hint: "Festive Special",
                      icon: Icons.local_offer_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter offer title";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    _buildLabel("Promo Code"),
                    _buildTextField(
                      controller: _codeController,
                      hint: "FESTIVE20",
                      icon: Icons.confirmation_number_outlined,
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter promo code";
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
                        const SizedBox(width: 14),
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
                        const SizedBox(width: 14),
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
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Status"),
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
                      hint: "e.g. Flat 20% off on all items",
                      icon: Icons.description_outlined,
                      maxLines: 2,
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _updateOffer,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(
                          _isLoading ? "Updating..." : "Update Offer",
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

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: _isDeleting ? null : _confirmDelete,
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        label: const Text(
                          "Delete Offer",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1.5),
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
                "Edit Offer",
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
        prefixIcon: Icon(icon, color: const Color(0xFF704522), size: 22),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
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
            ? const Icon(Icons.percent, color: Color(0xFF704522), size: 22)
            : const Icon(Icons.currency_rupee, color: Color(0xFF704522), size: 22),
        suffixText: isPercentage ? "%" : "₹",
        suffixStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF704522),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
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
          return "Invalid amount";
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8BBA9)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _discountType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF704522)),
          items: const [
            DropdownMenuItem(
              value: "Percentage",
              child: Row(
                children: [
                  Icon(Icons.percent, size: 18, color: Color(0xFF704522)),
                  SizedBox(width: 8),
                  Text("Percentage (%)"),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "Fixed",
              child: Row(
                children: [
                  Icon(Icons.currency_rupee, size: 18, color: Color(0xFF704522)),
                  SizedBox(width: 8),
                  Text("Fixed Amount (₹)"),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8BBA9)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _status,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF704522)),
          items: const [
            DropdownMenuItem(
              value: "Active",
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Text("Active"),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "Expired",
              child: Row(
                children: [
                  Icon(Icons.cancel, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Expired"),
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD8BBA9)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Color(0xFF704522),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                OfferModel.formatDate(date),
                style: const TextStyle(
                  fontSize: 13,
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
