import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Map<String, dynamic> _order;
  late String status;

  final List<Map<String, dynamic>> items = [
    {"name": "Indigo Cushion Cover", "quantity": 2, "price": "₹899"},
    {"name": "Handmade Toran", "quantity": 1, "price": "₹699"},
  ];

  @override
  void initState() {
    super.initState();
    _order = Map<String, dynamic>.from(widget.order);
    status = _order["status"] ?? "Pending";
  }

  List<String> get _availableDropdownStatuses {
    if (status == "Delivered") {
      return ["Delivered", "Cancelled"];
    } else if (status == "Cancelled") {
      return ["Cancelled"];
    }
    return ["Pending", "Shipped", "Delivered", "Cancelled"];
  }

  void _updateStatus(String value) {
    setState(() {
      status = value;
      _order["status"] = value;
      if (value == "Delivered") {
        _order["paymentStatus"] = "Paid";
      } else if (value == "Cancelled") {
        _order["paymentStatus"] = "Refunded";
      }
    });

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFC9E0FF),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 38,
                  color: Color(0xFF496B8D),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Status Updated!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Order status changed to $value.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA06D42),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _order);
        }
      },
      child: AdminShell(
        selectedIndex: 2,
        child: Column(
          children: [
            _buildTitle(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(13, 15, 13, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderHeader(),

                    const SizedBox(height: 18),

                    _buildSectionTitle("Customer Information"),

                    _buildCustomerCard(),

                    const SizedBox(height: 18),

                    _buildSectionTitle("Order Items"),

                    ...items.map((item) => _buildItemCard(item)),

                    const SizedBox(height: 18),

                    _buildSectionTitle("Order Summary"),

                    _buildSummary(),

                    const SizedBox(height: 18),

                    _buildSectionTitle("Update Order Status"),

                    _buildStatusDropdown(),
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
      height: 59,
      width: double.infinity,
      color: const Color(0xFFF5E9E5),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, _order);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 25,
              color: Colors.black,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Order Details",
                style: TextStyle(
                  fontSize: 31,
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

  Widget _buildOrderHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black54),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFD0E3FF),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 30,
              color: Color(0xFF704522),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _order["id"] ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _order["date"] ?? "",
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          _buildStatusBadge(status),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          fontFamily: "serif",
        ),
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8BBA9)),
      ),
      child: Column(
        children: [
          _infoRow(Icons.person_outline, "Customer", _order["customer"] ?? "Customer"),
          const Divider(),
          _infoRow(Icons.email_outlined, "Email", "customer@example.com"),
          const Divider(),
          _infoRow(Icons.phone_outlined, "Phone", "+91 98765 43210"),
          const Divider(),
          _infoRow(
            Icons.location_on_outlined,
            "Address",
            "Rajkot, Gujarat, India",
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 21, color: const Color(0xFF704522)),
        const SizedBox(width: 12),
        Text(
          "$title:",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "lib/assets/images/devart_product_1.webp",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Quantity: ${item["quantity"]}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            item["price"],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final isDelivered = status == "Delivered";
    final isCancelled = status == "Cancelled";

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8BBA9)),
      ),
      child: Column(
        children: [
          _summaryRow("Subtotal", "₹2,497"),
          const SizedBox(height: 9),
          _summaryRow("Delivery", "₹0"),
          const SizedBox(height: 9),
          _summaryRow("Discount", "-₹0"),
          const Divider(height: 22),
          _summaryRow("Total", _order["amount"] ?? "₹2,499", bold: true),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDelivered
                  ? const Color(0xFFD8F0D8)
                  : (isCancelled
                      ? const Color(0xFFFFEAEA)
                      : const Color(0xFFF5E9E5)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Payment Status",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDelivered
                        ? const Color(0xFF2E7D32)
                        : (isCancelled ? Colors.red : const Color(0xFF704522)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isDelivered
                        ? "PAID"
                        : (isCancelled
                            ? "REFUNDED"
                            : (_order["paymentStatus"] ?? "PAID")),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 19 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    final dropdownItems = _availableDropdownStatuses;

    return Container(
      height: 53,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8BBA9)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownItems.contains(status) ? status : dropdownItems.first,
          isExpanded: true,
          items: dropdownItems.map((st) {
            return DropdownMenuItem<String>(
              value: st,
              child: Text(
                st,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: st == "Cancelled" ? Colors.red : Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null && value != status) {
              _updateStatus(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String value) {
    Color background;
    Color foreground;

    switch (value) {
      case "Pending":
        background = const Color(0xFFFFE5B5);
        foreground = const Color(0xFF9A6200);
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
        value,
        style: TextStyle(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
