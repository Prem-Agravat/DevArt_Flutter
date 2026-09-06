import 'package:flutter/material.dart';
import 'package:devart/admin/dashboard/admin_dashboard.dart';
import 'package:devart/admin/orders/order_management.dart';
import 'package:devart/admin/inventory/inventory_management.dart';
import 'package:devart/admin/offers/offer_management.dart';
import 'package:devart/admin/customers/customer_management.dart';
import 'package:devart/admin/profile/admin_profile.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final bool isCustomerPage;

  const AdminShell({
    super.key,
    required this.child,
    required this.selectedIndex,
    this.isCustomerPage = false,
  });

  void _navigate(BuildContext context, int index) {
    if (index == selectedIndex && !isCustomerPage) {
      return;
    }

    Widget page;

    switch (index) {
      case 0:
        page = const AdminDashboard();
        break;

      case 1:
        page = const InventoryManagementScreen();
        break;

      case 2:
        page = const OrderManagementScreen();
        break;

      case 3:
        page = const OfferManagementScreen();
        break;

      default:
        return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  void _openCustomers(BuildContext context) {
    if (isCustomerPage) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CustomerManagementScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFD5FA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            const SizedBox(width: 18),

            Image.asset(
              "lib/assets/images/devart-logo.png",
              width: 58,
              height: 58,
            ),

            const SizedBox(width: 25),

            const Text(
              "Admin Panel",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: () {
                _openCustomers(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isCustomerPage ? Icons.people : Icons.people_alt_outlined,
                      size: 26,
                      color: isCustomerPage ? Colors.black : Colors.black54,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Customers",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isCustomerPage ? Colors.black : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminProfileScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 26,
                      color: Colors.black54,
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "lib/assets/images/devart_bgimg_admin.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.15)),
          ),

          SafeArea(child: child),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFC4D9FF),
          border: Border(top: BorderSide(color: Color(0xFF8DAEEA), width: 1.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),

        child: BottomNavigationBar(
          currentIndex: isCustomerPage ? 0 : selectedIndex,

          onTap: (index) {
            _navigate(context, index);
          },

          type: BottomNavigationBarType.fixed,

          backgroundColor: Colors.transparent,

          elevation: 0,

          selectedItemColor: isCustomerPage ? Colors.black54 : Colors.black,

          unselectedItemColor: isCustomerPage ? Colors.black54 : Colors.black54,

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),

          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined, size: 28),
              activeIcon: Icon(Icons.dashboard, size: 28),
              label: "Dashboard",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined, size: 28),
              activeIcon: Icon(Icons.inventory_2, size: 28),
              label: "Inventory",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, size: 28),
              activeIcon: Icon(Icons.shopping_cart, size: 28),
              label: "Orders",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.discount_outlined, size: 28),
              activeIcon: Icon(Icons.discount, size: 28),
              label: "Offers",
            ),
          ],
        ),
      ),
    );
  }
}
