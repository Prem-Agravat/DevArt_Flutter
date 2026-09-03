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
  String selectedSort = "Newest First";

  final List<String> statuses = [
    "All",
    "Pending",
    "Confirmed",
    "Shipped",
    "Delivered",
    "Cancelled",
  ];

  final List<String> sortOptions = [
    "Newest First",
    "Oldest First",
    "Amount: High to Low",
    "Amount: Low to High",
    "Customer (A-Z)",
  ];

  List<Map<String, dynamic>> orders = [
    {
      "id": "#DV1001",
      "customer": "Rahul Patel",
      "email": "rahulpatel@gmail.com",
      "phone": "+91 98765 12345",
      "address": "402, Shivam Heights, Kalawad Road, Rajkot, Gujarat - 360005",
      "date": "23 Aug 2026, 02:45 PM",
      "timestamp": DateTime(2026, 8, 23, 14, 45),
      "items": [
        {
          "name": "Handcrafted Terracotta Clay Pot",
          "quantity": 1,
          "price": "₹1,299",
          "rawPrice": 1299.0,
          "category": "Pottery",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Indigo Embroidered Cushion Cover",
          "quantity": 2,
          "price": "₹600",
          "rawPrice": 600.0,
          "category": "Cushion Covers",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
      "itemCount": "3 Items",
      "amount": "₹2,499",
      "rawAmount": 2499.0,
      "status": "Pending",
      "paymentMethod": "UPI (Google Pay)",
      "paymentStatus": "Paid",
      "subtotal": "₹2,499",
      "deliveryFee": "₹0 (Free)",
      "discount": "₹0",
      "tax": "₹0",
      "trackingNumber": "DEV-TRK-88319",
      "courier": "Blue Dart Express",
      "deliveryDate": "Expected by 28 Aug 2026",
    },
    {
      "id": "#DV1002",
      "customer": "Priya Shah",
      "email": "priyashah@gmail.com",
      "phone": "+91 98765 67890",
      "address": "12, Shanti Niketan Society, University Road, Rajkot - 360005",
      "date": "22 Aug 2026, 11:30 AM",
      "timestamp": DateTime(2026, 8, 22, 11, 30),
      "items": [
        {
          "name": "Traditional Bandhani Cushion Set",
          "quantity": 2,
          "price": "₹949.50",
          "rawPrice": 949.50,
          "category": "Cushion Covers",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
      "itemCount": "2 Items",
      "amount": "₹1,899",
      "rawAmount": 1899.0,
      "status": "Confirmed",
      "paymentMethod": "Credit Card",
      "paymentStatus": "Paid",
      "subtotal": "₹1,899",
      "deliveryFee": "₹0 (Free)",
      "discount": "₹0",
      "tax": "₹0",
      "trackingNumber": "DEV-TRK-99421",
      "courier": "Delhivery Courier",
      "deliveryDate": "Expected by 26 Aug 2026",
    },
    {
      "id": "#DV1003",
      "customer": "Amit Joshi",
      "email": "amitjoshi@gmail.com",
      "phone": "+91 98765 24680",
      "address": "B-304, Royal Palms, 150 Feet Ring Road, Rajkot - 360004",
      "date": "22 Aug 2026, 09:15 AM",
      "timestamp": DateTime(2026, 8, 22, 9, 15),
      "items": [
        {
          "name": "Handmade Pearl & Mirror Toran",
          "quantity": 2,
          "price": "₹1,199",
          "rawPrice": 1199.0,
          "category": "Toran",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Royal Jacquard Sofa Slipcover",
          "quantity": 2,
          "price": "₹700.50",
          "rawPrice": 700.50,
          "category": "Sofa Covers",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
      "itemCount": "4 Items",
      "amount": "₹3,799",
      "rawAmount": 3799.0,
      "status": "Shipped",
      "paymentMethod": "Cash on Delivery",
      "paymentStatus": "Pending (COD)",
      "subtotal": "₹3,799",
      "deliveryFee": "₹0 (Free)",
      "discount": "₹0",
      "tax": "₹0",
      "trackingNumber": "DTDC-6628190",
      "courier": "DTDC Express",
      "deliveryDate": "In Transit - Delivery by 25 Aug 2026",
    },
    {
      "id": "#DV1004",
      "customer": "Neha Mehta",
      "email": "nehamehta@gmail.com",
      "phone": "+91 98765 13579",
      "address": "78, Golden Park, Amin Marg, Rajkot - 360001",
      "date": "21 Aug 2026, 04:20 PM",
      "timestamp": DateTime(2026, 8, 21, 16, 20),
      "items": [
        {
          "name": "Handcrafted Brass Diya Set",
          "quantity": 1,
          "price": "₹899",
          "rawPrice": 899.0,
          "category": "Handicrafts",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
      "itemCount": "1 Item",
      "amount": "₹899",
      "rawAmount": 899.0,
      "status": "Delivered",
      "paymentMethod": "UPI (PhonePe)",
      "paymentStatus": "Paid",
      "subtotal": "₹899",
      "deliveryFee": "₹0 (Free)",
      "discount": "₹0",
      "tax": "₹0",
      "trackingNumber": "DEL-4418290",
      "courier": "Delhivery Courier",
      "deliveryDate": "Delivered on 23 Aug 2026",
    },
    {
      "id": "#DV1005",
      "customer": "Dev Chauhan",
      "email": "devchauhan@gmail.com",
      "phone": "+91 98765 43210",
      "address": "501, Silver Crest, Nana Mava Road, Rajkot - 360005",
      "date": "20 Aug 2026, 01:10 PM",
      "timestamp": DateTime(2026, 8, 20, 13, 10),
      "items": [
        {
          "name": "Designer Velvet Sofa Cover 5 Seater",
          "quantity": 1,
          "price": "₹2,499",
          "rawPrice": 2499.0,
          "category": "Sofa Covers",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Hand-painted Blue Pottery Vase",
          "quantity": 2,
          "price": "₹900",
          "rawPrice": 900.0,
          "category": "Pottery",
          "image": "lib/assets/images/devart_product_1.webp",
        },
        {
          "name": "Marigold Garland Door Toran",
          "quantity": 2,
          "price": "₹450",
          "rawPrice": 450.0,
          "category": "Toran",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
      "itemCount": "5 Items",
      "amount": "₹4,299",
      "rawAmount": 4299.0,
      "status": "Cancelled",
      "paymentMethod": "Net Banking",
      "paymentStatus": "Refunded",
      "subtotal": "₹4,299",
      "deliveryFee": "₹0 (Free)",
      "discount": "₹0",
      "tax": "₹0",
      "trackingNumber": "N/A",
      "courier": "N/A",
      "deliveryDate": "Cancelled on 20 Aug 2026",
    },
    {
      "id": "#DV1006",
      "customer": "Ananya Sharma",
      "email": "ananya.sharma@gmail.com",
      "phone": "+91 98765 99887",
      "address": "15, Green Acres, Mavdi Main Road, Rajkot - 360004",
      "date": "24 Aug 2026, 10:05 AM",
      "timestamp": DateTime(2026, 8, 24, 10, 5),
      "items": [
        {
          "name": "Ceramic Handcrafted Tea Set",
          "quantity": 1,
          "price": "₹1,450",
          "rawPrice": 1450.0,
          "category": "Pottery",
          "image": "lib/assets/images/devart_product_1.webp",
        },
      ],
      "itemCount": "1 Item",
      "amount": "₹1,450",
      "rawAmount": 1450.0,
      "status": "Pending",
      "paymentMethod": "Cash on Delivery",
      "paymentStatus": "Pending (COD)",
      "subtotal": "₹1,450",
      "deliveryFee": "₹0 (Free)",
      "discount": "₹0",
      "tax": "₹0",
      "trackingNumber": "DEV-TRK-10294",
      "courier": "Blue Dart Express",
      "deliveryDate": "Expected by 29 Aug 2026",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _statusScrollController.dispose();
    super.dispose();
  }

  int _getStatusOrderCount(int index) {
    if (index == 0) return orders.length;
    final statusName = statuses[index];
    return orders.where((o) => o["status"] == statusName).length;
  }

  double get _totalRevenue {
    return orders
        .where((o) => o["status"] != "Cancelled")
        .fold(0.0, (sum, o) => sum + (o["rawAmount"] as double? ?? 0.0));
  }

  List<Map<String, dynamic>> get filteredOrders {
    final search = _searchController.text.trim().toLowerCase();

    final filtered = orders.where((order) {
      final idMatch = order["id"].toString().toLowerCase().contains(search);
      final customerMatch =
          order["customer"].toString().toLowerCase().contains(search);
      final phoneMatch =
          order["phone"].toString().toLowerCase().contains(search);
      final statusMatch =
          order["status"].toString().toLowerCase().contains(search);
      final paymentMatch =
          order["paymentMethod"].toString().toLowerCase().contains(search);

      final matchesSearch = search.isEmpty ||
          idMatch ||
          customerMatch ||
          phoneMatch ||
          statusMatch ||
          paymentMatch;

      final matchesStatus =
          selectedStatus == 0 || order["status"] == statuses[selectedStatus];

      return matchesSearch && matchesStatus;
    }).toList();

    switch (selectedSort) {
      case "Newest First":
        filtered.sort((a, b) =>
            (b["timestamp"] as DateTime).compareTo(a["timestamp"] as DateTime));
        break;
      case "Oldest First":
        filtered.sort((a, b) =>
            (a["timestamp"] as DateTime).compareTo(b["timestamp"] as DateTime));
        break;
      case "Amount: High to Low":
        filtered.sort((a, b) =>
            (b["rawAmount"] as double).compareTo(a["rawAmount"] as double));
        break;
      case "Amount: Low to High":
        filtered.sort((a, b) =>
            (a["rawAmount"] as double).compareTo(b["rawAmount"] as double));
        break;
      case "Customer (A-Z)":
        filtered.sort((a, b) =>
            (a["customer"] as String).compareTo(b["customer"] as String));
        break;
    }

    return filtered;
  }

  void _updateOrderStatus(String orderId, String newStatus) {
    setState(() {
      final index = orders.indexWhere((o) => o["id"] == orderId);
      if (index != -1) {
        orders[index]["status"] = newStatus;
        if (newStatus == "Cancelled") {
          orders[index]["paymentStatus"] = "Refunded";
        } else if (newStatus == "Delivered") {
          orders[index]["paymentStatus"] = "Paid";
        }
      }
    });
  }

  void _showQuickStatusSheet(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Update Order Status",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "serif",
                        ),
                      ),
                      Text(
                        "${order["id"]} • ${order["customer"]}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusBadge(order["status"]),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 10),
              ...statuses.where((s) => s != "All").map((statusName) {
                final isCurrent = order["status"] == statusName;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _getStatusIcon(statusName),
                  title: Text(
                    statusName,
                    style: TextStyle(
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.w500,
                      color: isCurrent
                          ? const Color(0xFF704522)
                          : Colors.black87,
                    ),
                  ),
                  trailing: isCurrent
                      ? const Icon(Icons.check_circle,
                          color: Color(0xFF704522))
                      : null,
                  onTap: () {
                    Navigator.pop(bottomContext);
                    _updateOrderStatus(order["id"], statusName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Order ${order["id"]} status updated to $statusName",
                        ),
                        backgroundColor: const Color(0xFF704522),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _getStatusIcon(String status) {
    IconData icon;
    Color color;
    switch (status) {
      case "Pending":
        icon = Icons.hourglass_top_outlined;
        color = const Color(0xFFB37400);
        break;
      case "Confirmed":
        icon = Icons.verified_outlined;
        color = const Color(0xFF1E6091);
        break;
      case "Shipped":
        icon = Icons.local_shipping_outlined;
        color = const Color(0xFF6546A0);
        break;
      case "Delivered":
        icon = Icons.check_circle_outline;
        color = const Color(0xFF2D7A31);
        break;
      case "Cancelled":
        icon = Icons.cancel_outlined;
        color = Colors.red;
        break;
      default:
        icon = Icons.receipt_outlined;
        color = Colors.black54;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  void _confirmCancelOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.red, size: 28),
              const SizedBox(width: 10),
              const Text("Cancel Order?",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            "Are you sure you want to cancel order ${order["id"]} for ${order["customer"]}? This will mark the order as cancelled and process refund.",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Keep Order",
                  style: TextStyle(color: Colors.black54)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _updateOrderStatus(order["id"], "Cancelled");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Order ${order["id"]} has been cancelled."),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Cancel Order",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredOrders;

    return AdminShell(
      selectedIndex: 2,
      child: Column(
        children: [
          _buildTitle(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 14, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: _buildMetricsOverview(),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: _buildSearchAndSortBar(),
                  ),
                  const SizedBox(height: 12),
                  _buildStatusFilters(),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      children: [
                        ...filtered.map((order) => _buildOrderCard(context, order)),
                        if (filtered.isEmpty) _buildEmptyState(),
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

  Widget _buildMetricsOverview() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF704522),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF704522).withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Orders Revenue",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "₹${_totalRevenue.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${orders.length} Total Orders",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniMetric(
                  "Pending",
                  "${_getStatusOrderCount(1)}",
                  const Color(0xFFFFD166)),
              _buildMiniMetric(
                  "Confirmed",
                  "${_getStatusOrderCount(2)}",
                  const Color(0xFF90E0EF)),
              _buildMiniMetric(
                  "Shipped",
                  "${_getStatusOrderCount(3)}",
                  const Color(0xFFE2D8FF)),
              _buildMiniMetric(
                  "Delivered",
                  "${_getStatusOrderCount(4)}",
                  const Color(0xFFB7E4C7)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildSearchAndSortBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search,
                    size: 24, color: Colors.black54),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            size: 18, color: Colors.black54),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                hintText: "Search ID, customer, phone...",
                hintStyle:
                    const TextStyle(color: Colors.black45, fontSize: 13),
                contentPadding: const EdgeInsets.only(top: 13),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          tooltip: "Sort Orders",
          onSelected: (val) {
            setState(() {
              selectedSort = val;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          itemBuilder: (context) {
            return sortOptions.map((opt) {
              final isSelected = selectedSort == opt;
              return PopupMenuItem(
                value: opt,
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      size: 18,
                      color: isSelected ? const Color(0xFF704522) : Colors.black45,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      opt,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? const Color(0xFF704522) : Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.sort_rounded, color: Color(0xFF704522), size: 22),
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: Colors.black54, size: 20),
              ],
            ),
          ),
        ),
      ],
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
          final count = _getStatusOrderCount(index);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                setState(() {
                  selectedStatus = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF704522)
                      : const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF704522)
                        : const Color(0xFFD0D0D0),
                    width: selected ? 1.5 : 1,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFF704522).withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      statuses[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.white.withValues(alpha: 0.25)
                            : const Color(0xFFD4D4D4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "$count",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final status = order["status"] as String;
    final itemsList = (order["items"] as List?) ?? [];
    final firstItemName = itemsList.isNotEmpty ? itemsList[0]["name"] : "";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black26),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFD0E3FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Color(0xFF704522),
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order["id"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "serif",
                          ),
                        ),
                        const SizedBox(width: 6),
                        _buildPaymentBadge(order["paymentStatus"] ?? "Paid"),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      order["date"],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline,
                    size: 18, color: Color(0xFF704522)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${order["customer"]} • ${order["phone"]}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (firstItemName.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Items: $firstItemName${itemsList.length > 1 ? ' + ${itemsList.length - 1} more' : ''}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.black26),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  Text(
                    order["amount"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF704522),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showQuickStatusSheet(order),
                    icon: const Icon(Icons.swap_horiz, size: 16),
                    label: const Text("Status", style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF704522),
                      side: const BorderSide(color: Color(0xFF704522)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
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
                            orders[idx] = updated;
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA06D42),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    child: const Text(
                      "Details",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (val) {
                      if (val == "status") {
                        _showQuickStatusSheet(order);
                      } else if (val == "cancel") {
                        _confirmCancelOrder(order);
                      }
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: "status",
                        child: Row(
                          children: [
                            Icon(Icons.edit_note, size: 18),
                            SizedBox(width: 8),
                            Text("Change Status"),
                          ],
                        ),
                      ),
                      if (status != "Cancelled")
                        const PopupMenuItem(
                          value: "cancel",
                          child: Row(
                            children: [
                              Icon(Icons.cancel_outlined,
                                  size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text("Cancel Order",
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBadge(String status) {
    Color bg;
    Color fg;
    if (status.contains("Paid")) {
      bg = const Color(0xFFD4EDDA);
      fg = const Color(0xFF155724);
    } else if (status.contains("Refunded")) {
      bg = const Color(0xFFFFEAEA);
      fg = Colors.red;
    } else {
      bg = const Color(0xFFFFF3CD);
      fg = const Color(0xFF856404);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: fg),
      ),
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
        foreground = const Color(0xFF2E7D32);
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
      padding: const EdgeInsets.only(top: 50),
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
            "Try changing your search query or filter.",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                selectedStatus = 0;
              });
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("Reset All Filters"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF704522),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
