import 'package:devart/admin/dashboard/admin_dashboard.dart';
import 'package:devart/user_panel/delivery_address.dart';
import 'package:devart/user_panel/help_support.dart';
import 'package:devart/user_panel/login.dart';
import 'package:flutter/material.dart';
import 'package:devart/user_panel/dashboard.dart';
import 'package:devart/user_panel/categories.dart';
import 'package:devart/user_panel/orders.dart';
import 'package:devart/user_panel/profile.dart';
import 'package:devart/user_panel/wishlist.dart';
import 'package:devart/services/auth_service.dart';

class AppDrawer extends StatefulWidget {
  final String selectedItem;

  const AppDrawer({super.key, required this.selectedItem});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthService _authService = AuthService();
  bool _isAdmin = false;
  String _userName = "User";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = _authService.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        _userName = user.displayName!;
      } else if (user.email != null && user.email!.isNotEmpty) {
        _userName = user.email!.split('@')[0];
      }

      try {
        final doc = await _authService.getUserProfile();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['name'] != null && data['name'].toString().isNotEmpty) {
            _userName = data['name'].toString();
          }
          final role = data['role']?.toString().toLowerCase().trim();
          _isAdmin = (role == "admin");
        }
      } catch (_) {}

      if (!_isAdmin) {
        _isAdmin = await _authService.isCurrentUserAdmin();
      }

      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _authService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _navigate(BuildContext context, String item, Widget page) {
    Navigator.pop(context);

    if (item == widget.selectedItem) {
      return;
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    });
  }

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
              _buildProfile(context),

              const SizedBox(height: 20),

              _buildMenuItem(
                context,
                icon: Icons.home,
                title: "Home",
                selected: widget.selectedItem == "Home",
                onTap: () {
                  _navigate(context, "Home", const HomeScreen());
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.category_outlined,
                title: "Categories",
                selected: widget.selectedItem == "Categories",
                onTap: () {
                  _navigate(context, "Categories", const CategoriesScreen());
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.favorite_border,
                title: "Wishlist",
                selected: widget.selectedItem == "Wishlist",
                onTap: () {
                  _navigate(context, "Wishlist", const WishlistScreen());
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.receipt_long_outlined,
                title: "Orders",
                selected: widget.selectedItem == "Orders",
                onTap: () {
                  _navigate(context, "Orders", const OrdersScreen());
                },
              ),

              if (_isAdmin)
                _buildMenuItem(
                  context,
                  icon: Icons.admin_panel_settings_outlined,
                  title: "Admin Panel",
                  selected: widget.selectedItem == "Admin Panel",
                  highlightColor: const Color(0xFFBFD5FA),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminDashboard(),
                      ),
                    );
                  },
                ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Divider(color: Color(0xFFD6D0D0), thickness: 1),
              ),

              _buildMenuItem(
                context,
                icon: Icons.person_outline,
                title: "My Profile",
                selected: widget.selectedItem == "My Profile",
                onTap: () {
                  _navigate(context, "My Profile", const ProfileScreen());
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.location_on_outlined,
                title: "Shipping Addresses",
                selected: widget.selectedItem == "Shipping Addresses",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DeliveryAddressScreen(),
                    ),
                  );
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.help_outline,
                title: "Help & Support",
                selected: widget.selectedItem == "Help & Support",
                onTap: () {
                  _navigate(
                    context,
                    "Help & Support",
                    const HelpSupportScreen(),
                  );
                },
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

  Widget _buildProfile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 30, 20, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _userName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF805B3E),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _isAdmin ? "Administrator" : "Welcome back",
              style: TextStyle(
                fontSize: 15,
                color: _isAdmin ? const Color(0xFF1E3A8A) : Colors.black54,
                fontWeight: _isAdmin ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _navigate(context, "My Profile", const ProfileScreen());
              },
              child: const DecoratedBox(
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
    required bool selected,
    Color? highlightColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 43,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFFFD9DD)
                : (highlightColor?.withValues(alpha: 0.3) ?? Colors.transparent),
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
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _logout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Logout"),
                  ),
                ],
              );
            },
          );
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
