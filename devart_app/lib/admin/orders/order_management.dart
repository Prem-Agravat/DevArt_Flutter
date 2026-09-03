import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';
import 'package:devart/admin/orders/order_details.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _statusScrollController = ScrollController();

  int selectedStatus = 0;

  final List<String> statuses = [
    "All",
    "Pending",
    "Confirmed",
    "Shipped",
    "Delivered",
    "Cancelled",
  ];

  final List<Map<String, dynamic>> orders = [
    {
      "id": "#DV1001",
      "customer": "Rahul Patel",
      "date": "23 Aug 2026",
      "items": "3 Items",
      "amount": "₹2,499",
      "status": "Pending",
    },
    {
      "id": "#DV1002",
      "customer": "Priya Shah",
      "date": "22 Aug 2026",
      "items": "2 Items",
      "amount": "₹1,899",
      "status": "Confirmed",
    },
    {
      "id": "#DV1003",
      "customer": "Amit Joshi",
      "date": "22 Aug 2026",
      "items": "4 Items",
      "amount": "₹3,799",
      "status": "Shipped",
    },
    {
      "id": "#DV1004",
      "customer": "Neha Mehta",
      "date": "21 Aug 2026",
      "items": "1 Item",
      "amount": "₹899",
      "status": "Delivered",
    },
    {
      "id": "#DV1005",
      "customer": "Dev Chauhan",
      "date": "20 Aug 2026",
      "items": "5 Items",
      "amount": "₹4,299",
      "status": "Cancelled",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _statusScrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredOrders {
    final search = _searchController.text.toLowerCase().trim();

    return orders.where((order) {
      final matchesSearch = search.isEmpty ||
          order["id"].toString().toLowerCase().contains(search) ||
          order["customer"].toString().toLowerCase().contains(search);

      final matchesStatus =
          selectedStatus == 0 || order["status"] == statuses[selectedStatus];

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: 2,
      child: Column(
        children: [
          _buildTitle(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 15, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: _buildSearch(),
                  ),

                  const SizedBox(height: 12),

                  _buildStatusFilters(),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      children: [
                        ...filteredOrders.map(
                          (order) => _buildOrderCard(context, order),
                        ),
                        if (filteredOrders.isEmpty) _buildEmptyState(),
                      ],
                    ),
                  ),
                ],
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
      alignment: Alignment.center,
      child: const Text(
        "Order Management",
        style: TextStyle(
          fontSize: 31,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB56F6F),
          fontFamily: "serif",
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 47,
      decoration: BoxDecoration(
        color: const Color(0xFFDCDCDC),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) {
          setState(() {});
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, size: 27, color: Colors.black),
          hintText: "Search Order ID or Customer",
          hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
          contentPadding: EdgeInsets.only(top: 12),
        ),
      ),
    );
  }

  Widget _buildStatusFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        controller: _statusScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = selectedStatus == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedStatus = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF704522)
                    : const Color(0xFFE2E2E2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? const Color(0xFF704522) : Colors.black26,
                ),
              ),
              child: Text(
                statuses[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black54, width: 1),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFD0E3FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF704522),
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order["id"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "serif",
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order["customer"],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(order["status"]),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(height: 1, color: Colors.black26),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _buildOrderInfo(
                  Icons.calendar_today_outlined,
                  "Date",
                  order["date"],
                ),
              ),
              Expanded(
                child: _buildOrderInfo(
                  Icons.shopping_cart_outlined,
                  "Items",
                  order["items"],
                ),
              ),
              Expanded(
                child: _buildOrderInfo(
                  Icons.currency_rupee,
                  "Total",
                  order["amount"],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 43,
            child: ElevatedButton(
              onPressed: () async {
                final updated = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailsScreen(order: order),
                  ),
                );
                if (updated != null && mounted) {
                  setState(() {
                    final idx =
                        orders.indexWhere((o) => o["id"] == updated["id"]);
                    if (idx != -1) {
                      orders[idx]["status"] = updated["status"];
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA06D42),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                "View Order Details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 19, color: Colors.black54),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color background;
    Color foreground;

    switch (status) {
      case "Pending":
        background = const Color(0xFFFFE5B5);
        foreground = const Color(0xFF9A6200);
        break;

      case "Confirmed":
        background = const Color(0xFFD0E8FF);
        foreground = const Color(0xFF1565C0);
        break;

      case "Shipped":
        background = const Color(0xFFE2D8FF);
        foreground = const Color(0xFF6546A0);
        break;

      case "Delivered":
        background = const Color(0xFFD8F0D8);
        foreground = const Color(0xFF39733B);
        break;

      case "Cancelled":
        background = const Color(0xFFFFD8D8);
        foreground = Colors.red;
        break;

      default:
        background = Colors.grey.shade300;
        foreground = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 65,
            color: Colors.black38,
          ),
          const SizedBox(height: 15),
          const Text(
            "No Orders Found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "serif",
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Try changing your search or filter.",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
