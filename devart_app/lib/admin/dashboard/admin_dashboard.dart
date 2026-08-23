import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';
import 'package:devart/admin/orders/order_management.dart';
import 'package:devart/user_panel/dashboard.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: 0,
      selectedDrawerItem: "Dashboard",
      title: "Admin Panel",
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    "Dev Chauhan",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "premium@devart.com",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Welcome back, Dev.",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.payments_outlined,
                    title: "Total Sales",
                    value: "₹9875.00",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard(
                    icon: Icons.shopping_bag_outlined,
                    title: "Total Orders",
                    value: "650",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.person_outline,
                    title: "Customers",
                    value: "896",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard(
                    icon: Icons.inventory_2_outlined,
                    title: "Active Orders",
                    value: "34",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD8D8D8),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Recent Orders",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OrderManagementScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                              color: Color(0xFF7A4A2A),
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.black54),
                        bottom: BorderSide(color: Colors.black54),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "ORDER ID",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "PRODUCT",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "CUSTOMER",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _orderRow("#ORD-2094", "IndigoGeometry", "Matt Donovan"),
                  _orderRow("#ORD-2094", "IndigoGeometry", "Matt Donovan"),
                  _orderRow("#ORD-2094", "IndigoGeometry", "Matt Donovan"),
                  _orderRow("#ORD-2094", "IndigoGeometry", "Matt Donovan"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Back to App.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  "Back to App",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA06D42),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _orderRow(String orderId, String product, String customer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFFD8D8D8),
        border: Border(bottom: BorderSide(color: Colors.black)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              orderId,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              product,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              customer,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
