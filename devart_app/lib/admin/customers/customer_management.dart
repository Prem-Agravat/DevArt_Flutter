import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devart/common/admin_shell.dart';
import 'package:devart/models/customer_model.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<CustomerModel> _defaultCustomers = [
    CustomerModel(
      id: "cust_1",
      name: "Dev Chauhan",
      email: "devchauhan@gmail.com",
      phone: "+91 98765 43210",
      orders: 12,
      spent: "₹18,499",
    ),
    CustomerModel(
      id: "cust_2",
      name: "Rahul Patel",
      email: "rahulpatel@gmail.com",
      phone: "+91 98765 12345",
      orders: 8,
      spent: "₹12,799",
    ),
    CustomerModel(
      id: "cust_3",
      name: "Priya Shah",
      email: "priyashah@gmail.com",
      phone: "+91 98765 67890",
      orders: 15,
      spent: "₹24,899",
    ),
    CustomerModel(
      id: "cust_4",
      name: "Amit Joshi",
      email: "amitjoshi@gmail.com",
      phone: "+91 98765 24680",
      orders: 3,
      spent: "₹4,299",
    ),
    CustomerModel(
      id: "cust_5",
      name: "Neha Mehta",
      email: "nehamehta@gmail.com",
      phone: "+91 98765 13579",
      orders: 21,
      spent: "₹31,599",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<List<CustomerModel>> _getCustomersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) {
      final List<CustomerModel> firestoreUsers = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final role = data['role']?.toString().toLowerCase().trim() ?? 'user';
        if (role == 'admin') continue; // Don't show admins in customer list

        final name = data['name']?.toString() ?? 'User';
        final email = data['email']?.toString() ?? '';
        final phone = data['phone']?.toString() ?? 'N/A';

        firestoreUsers.add(
          CustomerModel(
            id: doc.id,
            name: name,
            email: email,
            phone: phone,
            orders: (data['orders'] is num)
                ? (data['orders'] as num).toInt()
                : 1,
            spent: data['spent']?.toString() ?? '₹899',
          ),
        );
      }

      // Merge Firestore users with default customers (avoiding duplicates by email)
      final List<CustomerModel> combined = List.from(firestoreUsers);
      for (final def in _defaultCustomers) {
        if (!combined.any((c) =>
            c.email.toLowerCase().trim() == def.email.toLowerCase().trim())) {
          combined.add(def);
        }
      }

      return combined;
    });
  }

  List<CustomerModel> _filterCustomers(List<CustomerModel> list) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return list;

    return list.where((customer) {
      return customer.name.toLowerCase().contains(query) ||
          customer.email.toLowerCase().contains(query) ||
          customer.phone.toLowerCase().contains(query);
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
            child: StreamBuilder<List<CustomerModel>>(
              stream: _getCustomersStream(),
              builder: (context, snapshot) {
                final allCustomers = snapshot.data ?? _defaultCustomers;
                final filtered = _filterCustomers(allCustomers);

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16, bottom: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: _buildSearch(),
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: _buildCustomerSummary(allCustomers.length),
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          children: [
                            ...filtered.map(
                              (customer) => _buildCustomerCard(customer),
                            ),
                            if (filtered.isEmpty) _buildEmptyState(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
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
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) {
          setState(() {});
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, size: 24, color: Colors.black),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18, color: Colors.black54),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          hintText: "Search customer by name, email, phone...",
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          contentPadding: const EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  Widget _buildCustomerSummary(int totalCustomers) {
    return Container(
      width: double.infinity,
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black54),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
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
              const Text(
                "Total Customers",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                totalCustomers.toString(),
                style: const TextStyle(
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

  Widget _buildCustomerCard(CustomerModel customer) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black54),
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
            children: [
              _buildAvatar(customer.name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "serif",
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      customer.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.black26),
          const SizedBox(height: 12),

          _infoRow(Icons.phone_outlined, "Phone", customer.phone),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _smallInfo(
                  Icons.shopping_bag_outlined,
                  "Orders",
                  "${customer.orders} ${customer.orders == 1 ? 'Order' : 'Orders'}",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _smallInfo(
                  Icons.currency_rupee,
                  "Total Spent",
                  customer.spent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name) {
    String initials = "";
    final parts = name.trim().split(" ");
    if (parts.isNotEmpty && parts.first.isNotEmpty) {
      initials = parts.first[0];
      if (parts.length > 1 && parts[1].isNotEmpty) {
        initials += parts[1][0];
      }
    } else {
      initials = "C";
    }

    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFD0E3FF),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color(0xFF704522),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF704522)),
        const SizedBox(width: 8),
        Text(
          "$title:",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _smallInfo(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF704522)),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFFF5E9E5),
                borderRadius: BorderRadius.circular(35),
              ),
              child: const Icon(
                Icons.people_outline,
                size: 35,
                color: Color(0xFF704522),
              ),
            ),
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
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Show All Customers"),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF704522),
                side: const BorderSide(color: Color(0xFF704522)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
