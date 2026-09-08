import 'package:devart/common/app_shell.dart';
import 'package:devart/models/order_model.dart';
import 'package:devart/user_panel/dashboard.dart';
import 'package:flutter/material.dart';

class ConfirmOrderScreen extends StatelessWidget {
  final OrderModel? order;

  const ConfirmOrderScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 0,
      selectedDrawerItem: "Confirm Order",
      showCart: false,
      showBottomNav: false,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.check_circle,
                      size: 125,
                      color: Color(0xFF79A985),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Order Placed!",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        fontFamily: "serif",
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Thank you for supporting authentic artisans.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: "serif",
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildOrderDetails(),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA06D42),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text("Home"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA06D42),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text("Continue Shopping"),
                            ),
                          ),
                        ),
                      ],
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Confirm Order",
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

  Widget _buildOrderDetails() {
    final orderId = order?.orderId ?? "#DVT-2026-7841";
    final amountPaid = order != null
        ? "₹${order!.totalAmount.toStringAsFixed(2)}"
        : "₹870.00";
    final addressText = order?.address ??
        "Alex Rivers, 124 Artisans Lane,\nStudio 4B, Brooklyn,\nNY 11201";
    final statusText = order?.status ?? "Processing";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: const Border(left: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Column(
        children: [
          _detailRow("Order Status", statusText, status: true),
          const Divider(color: Colors.black),
          _detailRow("Order ID", orderId),
          _detailRow("Amount Paid", amountPaid, green: true),
          _detailRow(
            "Delivery Date",
            "Estimated 4-5 Days\nStandard Shipping",
          ),
          _detailRow("Shipping Address", addressText),
        ],
      ),
    );
  }

  Widget _detailRow(
    String title,
    String value, {
    bool green = false,
    bool status = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "serif",
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: status
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBBD9FF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: green ? Colors.green : Colors.black,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
