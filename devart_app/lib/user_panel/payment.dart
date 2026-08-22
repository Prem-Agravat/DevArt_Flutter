import 'package:flutter/material.dart';
import 'package:devart/user_panel/confirm_order.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedPayment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "lib/assets/images/devart-bgimage.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.white.withOpacity(0.72)),
            ),
            Column(
              children: [
                _buildTopBar(),
                _buildTitle(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(25, 12, 25, 30),
                    child: Column(
                      children: [
                        _buildSteps(),
                        const SizedBox(height: 20),
                        _paymentCard(
                          0,
                          Icons.credit_card_outlined,
                          "Credit/Debit Card",
                          "----------4242",
                        ),
                        _paymentCard(
                          1,
                          Icons.account_balance_outlined,
                          "UPI/NetBanking",
                          "PayviaanyUPIApp",
                        ),
                        _paymentCard(
                          2,
                          Icons.payments_outlined,
                          "CashOnDelivery",
                          "PayWhenDelivered",
                        ),
                        const SizedBox(height: 20),
                        _buildOrderTotal(),
                        const SizedBox(height: 35),
                        SizedBox(
                          width: 280,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ConfirmOrderScreen(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 85,
      color: const Color(0xFFC3D9FF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 25),
          ),
          Image.asset(
            "lib/assets/images/devart-logo.png",
            width: 70,
            height: 70,
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 64,
      color: const Color(0xFFFFF5F3),
      child: const Center(
        child: Text(
          "Payment",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB66D6D),
            fontFamily: "serif",
          ),
        ),
      ),
    );
  }

  Widget _buildSteps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _PaymentStep(number: "✓", title: "Address", active: true),
        Text(">"),
        _PaymentStep(number: "2", title: "Payment", active: true),
        Text(">"),
        _PaymentStep(number: "3", title: "Confirm"),
      ],
    );
  }

  Widget _paymentCard(int index, IconData icon, String title, String subtitle) {
    final selected = selectedPayment == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        height: 98,
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "serif",
                    ),
                  ),
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
            "OrderTotal",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "serif",
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
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
          ),
          child: Column(
            children: [
              _row("2Item", "₹899.00"),
              _row("Discount", "-₹29.00", red: true),
              _row("Delivery", "Free"),
              const Divider(),
              _row("Total", "₹870.00", green: true, large: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(
    String title,
    String value, {
    bool red = false,
    bool green = false,
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
              color: red
                  ? Colors.red
                  : green
                  ? Colors.green
                  : Colors.black,
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
