import 'package:devart/user_panel/app_drawer.dart';
import 'package:devart/user_panel/orders.dart';
import 'package:flutter/material.dart';
import 'package:devart/user_panel/dashboard.dart';
import 'package:devart/user_panel/categories.dart';
//import 'package:devart/user_panel/account.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final String selectedDrawerItem;

  const AppShell({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.selectedDrawerItem,
  });

  void _navigate(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget page;

    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const CategoriesScreen();
        break;
      case 2:
        page = const OrdersScreen();
        break;
      // case 3:
      //   page = const AccountScreen();
      //   break;
      default:
        return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    String _getSelectedItem() {
      switch (selectedIndex) {
        case 0:
          return "Home";
        case 1:
          return "Categories";
        case 2:
          return "Orders";
        case 3:
          return "Account";
        default:
          return "Home";
      }
    }

    return Scaffold(
      drawer: AppDrawer(selectedItem: selectedDrawerItem),

      appBar: AppBar(
        backgroundColor: const Color(0xFFBFD5FA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: Image.asset(
          "lib/assets/images/devart-logo.png",
          width: 65,
          height: 65,
        ),

        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu, size: 32, color: Colors.black),
            );
          },
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              size: 32,
              color: Colors.black,
            ),
          ),
        ],
      ),

      body: child,
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
              icon: Icon(Icons.home_outlined, size: 28),
              activeIcon: Icon(Icons.home, size: 28),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined, size: 28),
              activeIcon: Icon(Icons.assignment, size: 28),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined, size: 28),
              activeIcon: Icon(Icons.inventory_2, size: 28),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, size: 30),
              activeIcon: Icon(Icons.account_circle, size: 30),
              label: "Account",
            ),
          ],
        ),
      ),
    );
  }
}
