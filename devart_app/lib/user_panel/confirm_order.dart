import 'package:flutter/material.dart';

class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key});

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
                _buildTopBar(context),
                _buildTitle(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        const Icon(
                          Icons.check_circle,
                          size: 130,
                          color: Color(0xFF79A985),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Order Placed!",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            fontFamily: "serif",
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Thankyouforsupporting.",
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
                                    Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
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
                                    Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFA06D42),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text("ContinueShopping"),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
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
            icon: const Icon(Icons.menu, size: 34),
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
          "ConfirmOrder",
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

  Widget _buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: const Border(left: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Column(
        children: [
          _detailRow("OrderStatus", "Processing", status: true),
          const Divider(color: Colors.black),
          _detailRow("OrderID", "#DVT-2026-7841"),
          _detailRow("AmountPaid", "₹870.00", green: true),
          _detailRow("DeliveryDate", "Estimated Nov14\nStandardShipping"),
          _detailRow(
            "ShippingAddress",
            "Alex Rivers, 124 Artisans\nLane,\nStudio 4B, Brooklyn,\nNY 11201",
          ),
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
                      child: const Text(
                        "Processing",
                        style: TextStyle(
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
