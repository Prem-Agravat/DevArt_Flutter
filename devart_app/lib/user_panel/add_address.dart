import 'package:devart/common/app_shell.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _houseController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();

  String? selectedState;
  String selectedSaveAs = "Home";

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _houseController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(context);
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF806F65)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC89E83)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFA06D42), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 0,
      selectedDrawerItem: "Add New Address",
      showCart: false,
      showBottomNav: false,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 25, 24, 25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.94),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label("CONTACT DETAILS"),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _nameController,
                              decoration: _inputDecoration(
                                hint: "Full Name",
                                icon: Icons.person_outline,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Enter your name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration(
                                hint: "Phone Number",
                                icon: Icons.phone_outlined,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    !RegExp(
                                      r'^[0-9]{10}$',
                                    ).hasMatch(value.trim())) {
                                  return "Enter valid phone number";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),
                            _label("ADDRESS DETAILS"),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _houseController,
                              maxLines: 2,
                              decoration: _inputDecoration(
                                hint: "Flat/House No., Building,\nApartment",
                                icon: Icons.apartment,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Enter address";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _areaController,
                              decoration: _inputDecoration(
                                hint: "Area, Colony, Street, Sector",
                                icon: Icons.location_on_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Enter area";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _landmarkController,
                              decoration: _inputDecoration(
                                hint: "Landmark (Optional)",
                                icon: Icons.flag_outlined,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _pincodeController,
                                    keyboardType: TextInputType.number,
                                    decoration: _inputDecoration(
                                      hint: "Pincode",
                                      icon: Icons.location_on_outlined,
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          !RegExp(
                                            r'^[0-9]{6}$',
                                          ).hasMatch(value.trim())) {
                                        return "Invalid";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _cityController,
                                    decoration: _inputDecoration(
                                      hint: "Town/City",
                                      icon: Icons.location_city_outlined,
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: selectedState,
                              decoration: _inputDecoration(
                                hint: "Select State",
                                icon: Icons.map_outlined,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "Gujarat",
                                  child: Text("Gujarat"),
                                ),
                                DropdownMenuItem(
                                  value: "Maharashtra",
                                  child: Text("Maharashtra"),
                                ),
                                DropdownMenuItem(
                                  value: "Rajasthan",
                                  child: Text("Rajasthan"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedState = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Select state";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),
                            _label("SAVE AS"),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _saveButton("Home", Icons.home_outlined),
                                const SizedBox(width: 10),
                                _saveButton("Office", Icons.work_outline),
                                const SizedBox(width: 10),
                                _saveButton("Other", Icons.more_horiz),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA06D42),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Save Address  ▣",
                            style: TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 64,
      width: double.infinity,
      color: const Color(0xFFFFF5F3),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Add New Address",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB66D6D),
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

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        letterSpacing: 1,
        color: Color(0xFF806F65),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _saveButton(String text, IconData icon) {
    final selected = selectedSaveAs == text;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSaveAs = text;
          });
        },
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFCE5D5) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFC89E83)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Text(text, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
