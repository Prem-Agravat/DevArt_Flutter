import 'package:devart/common/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:devart/user_panel/add_address.dart';
import 'package:devart/user_panel/payment.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  int selectedAddress = 0;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 0,
      selectedDrawerItem: "Delivery Address",
      showCart: false,
      showBottomNav: false,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
                child: Column(
                  children: [
                    _buildSteps(),
                    const SizedBox(height: 22),
                    _buildAddressCard(
                      0,
                      "Home",
                      "Alex Rivers, 124 Artisans Lane, Studio 4B,\nBrooklyn, NY 11201",
                    ),
                    const SizedBox(height: 14),
                    _buildAddressCard(
                      1,
                      "Office",
                      "Alex Rivers, 124 Artisans Lane, Studio 4B,\nBrooklyn, NY 11201",
                    ),
                    const SizedBox(height: 25),
                    _buildAddAddress(),
                    const SizedBox(height: 70),
                    SizedBox(
                      width: 280,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaymentScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA06D42),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Continue to Payment  →",
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

  Widget _buildTitle() {
    return Container(
      height: 64,
      width: double.infinity,
      color: const Color(0xFFFFF5F3),
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

  Widget _buildSteps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _StepItem(number: "1", title: "Address", active: true),
        Text(">", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        _StepItem(number: "2", title: "Payment"),
        Text(">", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        _StepItem(number: "3", title: "Confirm"),
      ],
    );
  }

  Widget _buildAddressCard(int index, String title, String address) {
    final selected = selectedAddress == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddress = index;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black54),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 28),
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
                    style: const TextStyle(fontSize: 11, height: 1.7),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddress() {
    return GestureDetector(
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
          color: Colors.white.withOpacity(0.65),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: const Color(0xFFD7BFAF), width: 3),
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

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final bool active;

  const _StepItem({
    required this.number,
    required this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.black : Colors.white,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: active ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "serif",
          ),
        ),
      ],
    );
  }
}
