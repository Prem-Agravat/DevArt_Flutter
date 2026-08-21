import 'package:devart/user_panel/categories.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 315,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.only(top: 0, bottom: 0, right: 5),
        decoration: const BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 15,
              offset: Offset(5, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProfile(),

              const SizedBox(height: 25),

              _buildMenuItem(
                context,
                icon: Icons.home,
                title: "Home",
                selected: true,
              ),

              _buildMenuItem(
                context,
                icon: Icons.category_outlined,
                title: "Categories",
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                  );
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.grid_view_outlined,
                title: "All Items",
              ),

              _buildMenuItem(
                context,
                icon: Icons.favorite_border,
                title: "Wishlist",
              ),

              _buildMenuItem(
                context,
                icon: Icons.receipt_long_outlined,
                title: "Orders",
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                child: Divider(color: Color(0xFFD6D0D0), thickness: 1),
              ),

              _buildMenuItem(
                context,
                icon: Icons.person_outline,
                title: "My Profile",
              ),

              _buildMenuItem(
                context,
                icon: Icons.location_on_outlined,
                title: "Shipping Addresses",
              ),

              _buildMenuItem(
                context,
                icon: Icons.payments_outlined,
                title: "Payment Methods",
              ),

              _buildMenuItem(
                context,
                icon: Icons.person_outline,
                title: "Help&Support",
              ),

              const Spacer(),

              _buildLogout(context),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(36, 30, 20, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Guest User",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF805B3E),
              ),
            ),
            SizedBox(height: 3),
            Text(
              "Welcome back",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            SizedBox(height: 16),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFE2E2E2),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: GestureDetector(
        onTap:
            onTap ??
            () {
              Navigator.pop(context);
            },
        child: Container(
          height: 43,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFD9DD) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Icon(icon, size: 23, color: const Color(0xFF554E4E)),
              const SizedBox(width: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF554E4E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 43,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD4D4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 22, color: Colors.red),
              SizedBox(width: 10),
              Text(
                "Logout",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
