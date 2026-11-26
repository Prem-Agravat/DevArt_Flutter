import 'package:devart/common/app_shell.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/address_service.dart';
import 'package:devart/user_panel/add_address.dart';
import 'package:devart/user_panel/payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryAddressScreen extends StatelessWidget {
  const DeliveryAddressScreen({super.key});

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case "office":
      case "work":
        return Icons.business_outlined;
      case "home":
        return Icons.home_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressService = context.watch<AddressService>();
    final addresses = addressService.addresses;
    final currentSelection = addresses.isEmpty
        ? 0
        : addressService.selectedIndex.clamp(0, addresses.length - 1);

    return AppShell(
      selectedIndex: 0,
      selectedDrawerItem: "Delivery Address",
      showCart: false,
      showBottomNav: false,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
                child: Column(
                  children: [
                    if (addresses.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFD5B7A5)),
                        ),
                        child: const Text(
                          "No saved addresses yet.\nTap 'Add New Address' below to add your delivery address.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      )
                    else
                      ...List.generate(addresses.length, (index) {
                        final item = addresses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildAddressCard(
                            context: context,
                            index: index,
                            selectedIndex: currentSelection,
                            title: item.type,
                            address: item.address,
                            phone: item.phone,
                            icon: _iconForType(item.type),
                          ),
                        );
                      }),
                    _buildAddAddress(context),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 280,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (addresses.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please add a delivery address first.",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          final chosenAddress =
                              addresses[currentSelection].address;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                selectedAddress: chosenAddress,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppResources.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Continue to Payment",
                          style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildTitle(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      color: const Color(0xFFF5E9E5),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Delivery Address",
                style: TextStyle(
                  fontSize: 28,
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

  Widget _buildAddressCard({
    required BuildContext context,
    required int index,
    required int selectedIndex,
    required String title,
    required String address,
    required String phone,
    required IconData icon,
  }) {
    final selected = selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<AddressService>().selectAddress(index);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(16),
          border: selected
              ? Border.all(color: AppResources.primaryColor, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      fontFamily: "serif",
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    address,
                    style: const TextStyle(fontSize: 11, height: 1.6),
                  ),
                  if (phone.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      "Phone: $phone",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: "Delete address",
              onPressed: () {
                context.read<AddressService>().removeAddress(index);
              },
            ),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? AppResources.primaryColor : Colors.black54,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddress(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddAddressScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        height: 122,
        decoration: BoxDecoration(
          color: const Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 30),
            SizedBox(height: 5),
            Text(
              "Add New Address",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "serif",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
