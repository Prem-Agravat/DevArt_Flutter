import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:devart/common/admin_shell.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Map<String, dynamic> _currentOrder;
  late String _status;

  final List<String> availableStatuses = [
    "Pending",
    "Confirmed",
    "Shipped",
    "Delivered",
    "Cancelled",
  ];

  @override
  void initState() {
    super.initState();
    _currentOrder = Map<String, dynamic>.from(widget.order);
    _status = _currentOrder["status"] ?? "Pending";
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _status = newStatus;
      _currentOrder["status"] = newStatus;
      if (newStatus == "Cancelled") {
        _currentOrder["paymentStatus"] = "Refunded";
        _currentOrder["deliveryDate"] = "Cancelled on ${DateTime.now().day} Aug 2026";
      } else if (newStatus == "Delivered") {
        _currentOrder["paymentStatus"] = "Paid";
        _currentOrder["deliveryDate"] = "Delivered on ${DateTime.now().day} Aug 2026";
      } else if (newStatus == "Shipped") {
        if (_currentOrder["trackingNumber"] == "N/A" || _currentOrder["trackingNumber"] == null) {
          _currentOrder["trackingNumber"] = "DTDC-9920184";
          _currentOrder["courier"] = "DTDC Express";
        }
      }
    });

    _showStatusSuccessDialog(newStatus);
  }

  void _showStatusSuccessDialog(String statusValue) {
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
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFD0E8FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 38,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Status Updated!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "serif",
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Order ${_currentOrder["id"]} status changed to $statusValue.",
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

  void _confirmCancelOrder() {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(Icons.cancel_outlined, color: Colors.red, size: 26),
              SizedBox(width: 10),
              Text("Cancel Order", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Are you sure you want to cancel this order? Please specify the reason:",
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: "e.g. Customer requested cancellation / Out of stock",
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child:
                  const Text("Back", style: TextStyle(color: Colors.black54)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _updateStatus("Cancelled");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Confirm Cancel",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showInvoiceDialog() {
    final items = (_currentOrder["items"] as List?) ?? [];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "DevArt Handicrafts",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "serif",
                              color: Color(0xFF704522),
                            ),
                          ),
                          Text(
                            "TAX INVOICE",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5E9E5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _currentOrder["id"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xFFB56F6F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Billed To:",
                              style: TextStyle(
                                  fontSize: 11, color: Colors.black54)),
                          Text(
                            _currentOrder["customer"] ?? "Customer",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            _currentOrder["phone"] ?? "",
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Date:",
                              style: TextStyle(
                                  fontSize: 11, color: Colors.black54)),
                          Text(
                            _currentOrder["date"] ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                          Text(
                            "Status: ${_currentOrder["status"]}",
                            style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF704522),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Items Summary",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: "serif")),
                  const SizedBox(height: 8),
                  ...items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${item["name"]} (x${item["quantity"]})",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Text(
                            item["price"] ?? "",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Grand Total:",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(
                        _currentOrder["amount"] ?? "",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF704522),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Invoice PDF saved to downloads!"),
                                backgroundColor: Color(0xFF704522),
                              ),
                            );
                          },
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text("Download"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF704522),
                            side: const BorderSide(color: Color(0xFF704522)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF704522),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Close"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$label copied to clipboard!"),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = (_currentOrder["items"] as List?) ?? [];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _currentOrder);
        }
      },
      child: AdminShell(
        selectedIndex: 2,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 15, 14, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderHeader(),
                    const SizedBox(height: 16),
                    _buildStatusStepper(),
                    const SizedBox(height: 18),
                    _buildQuickActionButtons(),
                    const SizedBox(height: 18),
                    _buildSectionTitle("Customer Information"),
                    _buildCustomerCard(),
                    const SizedBox(height: 18),
                    _buildSectionTitle("Order Items (${items.length})"),
                    ...items.map((item) => _buildItemCard(item)),
                    const SizedBox(height: 18),
                    _buildSectionTitle("Payment & Order Summary"),
                    _buildSummary(),
                    const SizedBox(height: 18),
                    _buildSectionTitle("Delivery & Courier Tracking"),
                    _buildDeliveryTrackingCard(),
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
              Navigator.pop(context, _currentOrder);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 23,
              color: Colors.black,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Order Details",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB56F6F),
                  fontFamily: "serif",
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: "View Invoice",
            onPressed: _showInvoiceDialog,
            icon: const Icon(
              Icons.receipt_outlined,
              size: 24,
              color: Color(0xFF704522),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black26),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFD0E3FF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 28,
              color: Color(0xFF704522),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentOrder["id"] ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _currentOrder["date"] ?? "",
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          _buildStatusBadge(_status),
        ],
      ),
    );
  }

  Widget _buildStatusStepper() {
    if (_status == "Cancelled") {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEEE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel_outlined, color: Colors.red, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Cancelled",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Payment status is updated to Refunded. ${_currentOrder["deliveryDate"] ?? ""}",
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final steps = ["Pending", "Confirmed", "Shipped", "Delivered"];
    final currentIdx = steps.indexOf(_status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8BBA9)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Order Status Progress",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "serif",
                ),
              ),
              Text(
                "Step ${currentIdx >= 0 ? currentIdx + 1 : 1} of 4",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF704522),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                final stepNum = index ~/ 2;
                final isPassed = currentIdx > stepNum;
                return Expanded(
                  child: Container(
                    height: 3,
                    color: isPassed
                        ? const Color(0xFF704522)
                        : const Color(0xFFE0E0E0),
                  ),
                );
              } else {
                final stepNum = index ~/ 2;
                final isCompleted = currentIdx >= stepNum;
                final isCurrent = currentIdx == stepNum;

                return Column(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFF704522)
                            : (isCompleted
                                ? const Color(0xFFA06D42)
                                : const Color(0xFFE0E0E0)),
                        shape: BoxShape.circle,
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF704522)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle,
                        size: isCompleted ? 16 : 8,
                        color: isCompleted ? Colors.white : Colors.black38,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      steps[stepNum],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.w500,
                        color: isCurrent
                            ? const Color(0xFF704522)
                            : (isCompleted
                                ? Colors.black87
                                : Colors.black45),
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    String? nextStatus;
    String nextLabel = "";
    IconData nextIcon = Icons.arrow_forward;

    if (_status == "Pending") {
      nextStatus = "Confirmed";
      nextLabel = "Confirm Order";
      nextIcon = Icons.check_circle_outline;
    } else if (_status == "Confirmed") {
      nextStatus = "Shipped";
      nextLabel = "Mark as Shipped";
      nextIcon = Icons.local_shipping_outlined;
    } else if (_status == "Shipped") {
      nextStatus = "Delivered";
      nextLabel = "Mark as Delivered";
      nextIcon = Icons.done_all;
    }

    return Row(
      children: [
        if (nextStatus != null) ...[
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () => _updateStatus(nextStatus!),
                icon: Icon(nextIcon, size: 18),
                label: Text(
                  nextLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF704522),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
        if (_status != "Cancelled" && _status != "Delivered")
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 46,
              child: OutlinedButton.icon(
                onPressed: _confirmCancelOrder,
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text("Cancel"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "serif",
        ),
      ),
    );
  }

  Widget _buildCustomerCard() {
    final customerName = _currentOrder["customer"] ?? "Customer";
    final phone = _currentOrder["phone"] ?? "+91 98765 43210";
    final email = _currentOrder["email"] ?? "customer@example.com";
    final address = _currentOrder["address"] ?? "Rajkot, Gujarat, India";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8BBA9)),
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
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFF5E9E5),
                child: Text(
                  customerName.isNotEmpty ? customerName[0] : "C",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF704522),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Customer ID: #CUST-${_currentOrder["id"]?.replaceAll('#', '') ?? '100'}",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _infoRow(
            Icons.phone_outlined,
            "Phone",
            phone,
            onCopy: () => _copyToClipboard(phone, "Phone number"),
          ),
          const Divider(height: 16),
          _infoRow(
            Icons.email_outlined,
            "Email",
            email,
            onCopy: () => _copyToClipboard(email, "Email address"),
          ),
          const Divider(height: 16),
          _infoRow(
            Icons.location_on_outlined,
            "Address",
            address,
            onCopy: () => _copyToClipboard(address, "Shipping address"),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value,
      {VoidCallback? onCopy}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: const Color(0xFF704522)),
        const SizedBox(width: 10),
        Text(
          "$title:",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ),
        if (onCopy != null)
          GestureDetector(
            onTap: onCopy,
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.copy_rounded, size: 16, color: Colors.black45),
            ),
          ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item["image"] ?? "lib/assets/images/devart_product_1.webp",
              width: 65,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"] ?? "Item",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif",
                  ),
                ),
                const SizedBox(height: 4),
                if (item["category"] != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item["category"],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF704522),
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  "Quantity: ${item["quantity"]} • Unit: ${item["price"]}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            item["price"] ?? "",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF704522),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8BBA9)),
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
          _summaryRow("Subtotal", _currentOrder["subtotal"] ?? _currentOrder["amount"]),
          const SizedBox(height: 8),
          _summaryRow("Delivery Fee", _currentOrder["deliveryFee"] ?? "₹0 (Free)"),
          const SizedBox(height: 8),
          _summaryRow("Discount Applied", _currentOrder["discount"] ?? "-₹0",
              color: Colors.green),
          const SizedBox(height: 8),
          _summaryRow("Taxes (GST included)", _currentOrder["tax"] ?? "₹0"),
          const Divider(height: 20),
          _summaryRow(
            "Grand Total",
            _currentOrder["amount"] ?? "",
            bold: true,
            color: const Color(0xFF704522),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5E9E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.payment, size: 18, color: Color(0xFF704522)),
                    const SizedBox(width: 8),
                    Text(
                      _currentOrder["paymentMethod"] ?? "UPI Payment",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildPaymentBadge(_currentOrder["paymentStatus"] ?? "Paid"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value,
      {bool bold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color ?? (bold ? Colors.black : Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryTrackingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8BBA9)),
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
          _infoRow(
            Icons.local_shipping_outlined,
            "Courier",
            _currentOrder["courier"] ?? "Blue Dart Express",
          ),
          const Divider(height: 16),
          _infoRow(
            Icons.confirmation_number_outlined,
            "Tracking #",
            _currentOrder["trackingNumber"] ?? "DEV-TRK-88319",
            onCopy: () => _copyToClipboard(
                _currentOrder["trackingNumber"] ?? "", "Tracking number"),
          ),
          const Divider(height: 16),
          _infoRow(
            Icons.calendar_month_outlined,
            "Estimated",
            _currentOrder["deliveryDate"] ?? "Expected in 3-4 days",
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8BBA9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: availableStatuses.contains(_status) ? _status : "Pending",
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF704522)),
          items: availableStatuses.map((st) {
            return DropdownMenuItem<String>(
              value: st,
              child: Row(
                children: [
                  _getStatusDot(st),
                  const SizedBox(width: 10),
                  Text(
                    st,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null && value != _status) {
              _updateStatus(value);
            }
          },
        ),
      ),
    );
  }

  Widget _getStatusDot(String status) {
    Color color;
    switch (status) {
      case "Pending":
        color = const Color(0xFFB37400);
        break;
      case "Confirmed":
        color = const Color(0xFF1565C0);
        break;
      case "Shipped":
        color = const Color(0xFF6546A0);
        break;
      case "Delivered":
        color = const Color(0xFF2E7D32);
        break;
      case "Cancelled":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
