import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';
import 'package:devart/models/order_model.dart';
import 'package:devart/models/customer_model.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/services/auth_service.dart';
import 'package:devart/services/order_service.dart';
import 'package:devart/services/customer_service.dart';
import 'package:devart/services/product_service.dart';
import 'package:devart/admin/orders/order_management.dart';
import 'package:devart/admin/orders/order_details.dart';
import 'package:devart/admin/profile/admin_profile.dart';
import 'package:devart/user_panel/dashboard.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final OrderService _orderService = OrderService();
  final CustomerService _customerService = CustomerService();
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _orderService.seedInitialOrdersIfEmpty();
    _customerService.seedInitialCustomersIfEmpty();
    _productService.seedInitialProductsIfEmpty();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final adminEmail = user?.email ?? "admin@devart.com";
    final adminName = user?.displayName ??
        (adminEmail.isNotEmpty ? adminEmail.split('@')[0] : "Admin");
    final firstName = adminName.split(" ").first;

    return AdminShell(
      selectedIndex: 0,
      child: StreamBuilder<List<OrderModel>>(
        stream: _orderService.getOrdersStream(),
        builder: (context, orderSnapshot) {
          final orders = orderSnapshot.data ?? [];

          // Compute live sales and total orders
          final double totalSales = orders
              .where((o) => o.status != "Cancelled")
              .fold(0.0, (acc, o) => acc + o.totalAmount);
          final int totalOrders = orders.length;
          final List<OrderModel> recentOrders = orders.take(5).toList();

          return StreamBuilder<List<CustomerModel>>(
            stream: _customerService.getCustomersStream(),
            builder: (context, customerSnapshot) {
              final customers = customerSnapshot.data ?? [];
              final int customerCount = customers.length;

              return StreamBuilder<List<ProductModel>>(
                stream: _productService.getProductsStream(),
                builder: (context, productSnapshot) {
                  final products = productSnapshot.data ?? [];
                  final int totalProducts = products.length;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Admin Header & Profile Shortcut
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminProfileScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        adminName,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "serif",
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.edit_outlined,
                                        size: 19,
                                        color: Color(0xFF704522),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    adminEmail,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "Welcome back, $firstName.",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF65452F),
                            fontFamily: "serif",
                          ),
                        ),

                        const SizedBox(height: 14),

                        // 4 Live Metric Stat Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.payments_outlined,
                                title: "Total Sales",
                                value:
                                    "₹${totalSales.toStringAsFixed(totalSales % 1 == 0 ? 0 : 2)}",
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.shopping_bag_outlined,
                                title: "Total Orders",
                                value: totalOrders.toString(),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.people_outline,
                                title: "Customers",
                                value: customerCount.toString(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.inventory_2_outlined,
                                title: "Total Products",
                                value: totalProducts.toString(),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // Recent Orders Live Table
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8D8D8),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black, width: 1.2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 10, 10, 8),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "Recent Orders",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "serif",
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const OrderManagementScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "View All",
                                        style: TextStyle(
                                          color: Color(0xFF7A4A2A),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                color: Colors.white,
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "ORDER ID",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "PRODUCT",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "CUSTOMER",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (recentOrders.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: Text(
                                      "No orders yet.",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                )
                              else
                                ...recentOrders.map((order) {
                                  final firstProduct = order.items.isNotEmpty
                                      ? order.items.first.name
                                      : "Artisan Craft";
                                  return _buildOrderRow(
                                    context: context,
                                    order: order,
                                    orderId: order.orderId,
                                    product: firstProduct,
                                    customer: order.customer,
                                  );
                                }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Back to App.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF65452F),
                            fontFamily: "serif",
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
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text(
                              "Back to App",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA06D42),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  static Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 1.2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: const Color(0xFF704522)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(height: 1, color: Colors.black38),
                const SizedBox(height: 6),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildOrderRow({
    required BuildContext context,
    required OrderModel order,
    required String orderId,
    required String product,
    required String customer,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(order: order),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: const BoxDecoration(
          color: Color(0xFFD8D8D8),
          border: Border(top: BorderSide(color: Colors.black26)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                orderId,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF704522),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                product,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 11),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
