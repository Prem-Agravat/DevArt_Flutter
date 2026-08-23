import 'package:devart/common/app_shell.dart';
import 'package:devart/user_panel/confirm_order.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedPayment = 0;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 0,
      selectedDrawerItem: "Payment",
      showCart: false,
      showBottomNav: false,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 30),
                child: Column(
                  children: [
                    _buildSteps(),
                    const SizedBox(height: 22),
                    _buildPaymentCard(
                      0,
                      Icons.credit_card_outlined,
                      "Credit/Debit Card",
                      "----------4242",
                    ),
                    _buildPaymentCard(
                      1,
                      Icons.account_balance_outlined,
                      "UPI/NetBanking",
                      "Pay via any UPI App",
                    ),
                    _buildPaymentCard(
                      2,
                      Icons.payments_outlined,
                      "Cash On Delivery",
                      "Pay When Delivered",
                    ),
                    const SizedBox(height: 18),
                    _buildOrderTotal(),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 280,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConfirmOrderScreen(),
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
                          "Pay ₹870  →",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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

  Widget _buildTitle() {
    return Container(
      height: 64,
      width: double.infinity,
      color: const Color(0xFFF5E9E5),
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
                "Payment",
                style: TextStyle(
                  fontSize: 30,
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

  Widget _buildSteps() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _PaymentStep(number: "✓", title: "Address", active: true),
        Text(">", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        _PaymentStep(number: "2", title: "Payment", active: true),
        Text(">", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        _PaymentStep(number: "3", title: "Confirm"),
      ],
    );
  }

  Widget _buildPaymentCard(
    int index,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final selected = selectedPayment == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = index;
        });
      },
      child: Container(
        width: double.infinity,
        height: 98,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black54),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: "serif",
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTotal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Order Total",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "serif",
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            border: const Border(
              left: BorderSide(color: Colors.black, width: 3),
            ),
          ),
          child: Column(
            children: [
              _summaryRow("2 Item", "₹899.00"),
              _summaryRow("Discount", "-₹29.00", color: Colors.red),
              _summaryRow("Delivery", "Free"),
              const Divider(),
              _summaryRow("Total", "₹870.00", large: true, color: Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    Color? color,
    bool large = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: large ? 20 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: large ? 20 : 13,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentStep extends StatelessWidget {
  final String number;
  final String title;
  final bool active;

  const _PaymentStep({
    required this.number,
    required this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.black : Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: active ? Colors.white : Colors.black,
                fontSize: 12,
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
