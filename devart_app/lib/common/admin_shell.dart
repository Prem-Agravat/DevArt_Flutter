import 'package:flutter/material.dart';
import 'package:devart/admin/dashboard/admin_dashboard.dart';
import 'package:devart/admin/inventory/inventory_management.dart';
import 'package:devart/admin/orders/order_management.dart';
import 'package:devart/admin/offers/offer_management.dart';
import 'package:devart/admin/customers/customer_management.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final String? selectedDrawerItem;
  final bool showBackButton;
  final String title;

  const AdminShell({
    super.key,
    required this.child,
    required this.selectedIndex,
    this.selectedDrawerItem,
    this.showBackButton = false,
    this.title = "Admin Panel",
  });

  void _navigate(BuildContext context, int index) {
    if (index == selectedIndex) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFD5FA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 18),

            Image.asset(
              "lib/assets/images/devart-logo.png",
              width: 58,
              height: 58,
            ),

            const SizedBox(width: 30),

            const Text(
              "Admin Panel",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomerManagementScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      size: 30,
                      color: Colors.black,
                    ),
                    Text(
                      "Customers",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
              "lib/assets/images/devart_bgimg_home.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.18)),
          ),
          Column(
            children: [
              if (showBackButton)
                Container(
                  height: 74,
                  color: const Color(0xFFFFF7F5),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new, size: 27),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              Expanded(child: child),
            ],
          ),
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
          currentIndex: selectedIndex,
          onTap: (index) => _navigate(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
              icon: Icon(Icons.shopping_cart_outlined, size: 30),
              activeIcon: Icon(Icons.shopping_cart, size: 30),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.discount_outlined, size: 30),
              activeIcon: Icon(Icons.discount, size: 30),
              label: "Offers",
            ),
          ],
        ),
      ),
    );
  }
}
