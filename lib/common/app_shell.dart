import 'package:flutter/material.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/user_panel/app_drawer.dart';
import 'package:devart/user_panel/dashboard.dart';
import 'package:devart/user_panel/categories.dart';
import 'package:devart/user_panel/orders.dart';
import 'package:devart/user_panel/profile.dart';
import 'package:devart/user_panel/cart.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final String selectedDrawerItem;
  final bool showCart;
  final bool showBottomNav;

  const AppShell({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.selectedDrawerItem,
    this.showCart = true,
    this.showBottomNav = true,
  });

  void _navigate(BuildContext context, int index) {
    if (index == selectedIndex) {
      return;
    }

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

      case 3:
        page = const ProfileScreen();
        break;

      default:
        return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  void _openCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(selectedItem: selectedDrawerItem),
      appBar: AppBar(
        backgroundColor: AppResources.appBarBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          AppResources.logo,
          width: 65,
          height: 65,
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, size: 32, color: AppResources.textPrimaryColor),
            );
          },
        ),
        actions: [
          if (showCart)
            IconButton(
              onPressed: () {
                _openCart(context);
              },
              icon: Icon(
                Icons.shopping_cart,
                size: 32,
                color: AppResources.textPrimaryColor,
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppResources.homeBackgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child,
        ],
      ),
      bottomNavigationBar: showBottomNav
          ? Container(
              decoration: BoxDecoration(
                color: AppResources.bottomNavBackgroundColor,
                border: Border(
                  top: BorderSide(color: AppResources.bottomNavBorderColor, width: 1.5),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  _navigate(context, index);
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: AppResources.textPrimaryColor,
                unselectedItemColor: Colors.black,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined, size: 28),
                    activeIcon: const Icon(Icons.home, size: 28),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.assignment_outlined, size: 28),
                    activeIcon: const Icon(Icons.assignment, size: 28),
                    label: "Categories",
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.inventory_2_outlined, size: 28),
                    activeIcon: const Icon(Icons.inventory_2, size: 28),
                    label: "Orders",
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.account_circle_outlined, size: 30),
                    activeIcon: const Icon(Icons.account_circle, size: 30),
                    label: "Profile",
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
