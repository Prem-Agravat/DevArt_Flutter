import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> customers = [
    {
      "name": "Dev Chauhan",
      "email": "devchauhan@gmail.com",
      "phone": "+91 98765 43210",
      "orders": 12,
      "spent": "₹18,499",
      "status": "Active",
    },
    {
      "name": "Rahul Patel",
      "email": "rahulpatel@gmail.com",
      "phone": "+91 98765 12345",
      "orders": 8,
      "spent": "₹12,799",
      "status": "Active",
    },
    {
      "name": "Priya Shah",
      "email": "priyashah@gmail.com",
      "phone": "+91 98765 67890",
      "orders": 15,
      "spent": "₹24,899",
      "status": "Active",
    },
    {
      "name": "Amit Joshi",
      "email": "amitjoshi@gmail.com",
      "phone": "+91 98765 24680",
      "orders": 3,
      "spent": "₹4,299",
      "status": "Inactive",
    },
    {
      "name": "Neha Mehta",
      "email": "nehamehta@gmail.com",
      "phone": "+91 98765 13579",
      "orders": 21,
      "spent": "₹31,599",
      "status": "Active",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredCustomers {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return customers;
    }

    return customers.where((customer) {
      return customer["name"].toString().toLowerCase().contains(query) ||
          customer["email"].toString().toLowerCase().contains(query) ||
          customer["phone"].toString().toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: 0,
      isCustomerPage: true,
      child: Column(
        children: [
          _buildTitle(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(13, 15, 13, 25),
              child: Column(
                children: [
                  _buildSearch(),

                  const SizedBox(height: 18),

                  _buildCustomerSummary(),

                  const SizedBox(height: 18),

                  ...filteredCustomers.map(
                    (customer) => _buildCustomerCard(customer),
                  ),

                  if (filteredCustomers.isEmpty) _buildEmptyState(),
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
        "Customer Management",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB56F6F),
          fontFamily: "serif",
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE1E1E1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) {
          setState(() {});
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, size: 25),
          hintText: "Search customer...",
          hintStyle: TextStyle(color: Colors.black54, fontSize: 13),
          contentPadding: EdgeInsets.only(top: 12),
        ),
      ),
    );
  }

  Widget _buildCustomerSummary() {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black54),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFD0E3FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.people_outline,
              color: Color(0xFF704522),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Customers",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              SizedBox(height: 4),
              Text(
                customers.length.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "serif",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black54),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildAvatar(customer["name"]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer["name"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "serif",
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer["email"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

          const SizedBox(height: 14),

          const Divider(height: 1, color: Colors.black26),

          const SizedBox(height: 13),

          _infoRow(Icons.phone_outlined, "Phone", customer["phone"]),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _smallInfo(
                  Icons.shopping_bag_outlined,
                  "Orders",
                  customer["orders"].toString(),
                ),
              ),
              Expanded(
                child: _smallInfo(
                  Icons.currency_rupee,
                  "Total Spent",
                  customer["spent"],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 43,
            child: ElevatedButton.icon(
              onPressed: () {
                _showCustomerDetails(customer);
              },
              icon: const Icon(Icons.visibility_outlined, size: 19),
              label: const Text(
                "View Customer",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA06D42),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name) {
    String initials = "";

    final parts = name.split(" ");

    if (parts.isNotEmpty) {
      initials = parts.first[0];

      if (parts.length > 1) {
        initials += parts[1][0];
      }
    }

    return Container(
      width: 54,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFD0E3FF),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF704522),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 19, color: const Color(0xFF704522)),
        const SizedBox(width: 8),
        Text(
          "$title:",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
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

  Widget _smallInfo(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 19, color: const Color(0xFF704522)),
        const SizedBox(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  void _showCustomerDetails(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAvatar(customer["name"]),

              const SizedBox(height: 12),

              Text(
                customer["name"],
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  fontFamily: "serif",
                ),
              ),

              const SizedBox(height: 5),

              Text(
                customer["email"],
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),

              const SizedBox(height: 18),

              _dialogInfo(Icons.phone_outlined, customer["phone"]),

              const SizedBox(height: 10),

              _dialogInfo(
                Icons.shopping_bag_outlined,
                "${customer["orders"]} Orders",
              ),

              const SizedBox(height: 10),

              _dialogInfo(
                Icons.currency_rupee,
                "${customer["spent"]} Total Spent",
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 45,
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
                    "Close",
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

  Widget _dialogInfo(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9E5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF704522)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        children: [
          const Icon(Icons.people_outline, size: 65, color: Colors.black38),
          const SizedBox(height: 15),
          const Text(
            "No Customers Found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "serif",
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Try searching with another name or email.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
