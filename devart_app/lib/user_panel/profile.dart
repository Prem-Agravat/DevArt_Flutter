import 'package:devart/admin/dashboard/admin_dashboard.dart';
import 'package:devart/common/action_popup.dart';
import 'package:devart/common/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:devart/user_panel/edit_profile.dart';
import 'package:devart/user_panel/change_password.dart';
import 'package:devart/user_panel/help_support.dart';
import 'package:devart/user_panel/wishlist.dart';
import 'package:devart/user_panel/coupons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    showSuccessPopup(
      context,
      title: "Logout",
      message: "You have been logged out successfully.",
      buttonText: "Continue",
      onPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 3,
      selectedDrawerItem: "Profile",
      showCart: true,
      showBottomNav: true,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 20, 26, 25),
                child: Column(
                  children: [
                    const Text(
                      "Prem Agravat",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "premagravat00@gmail.com",
                      style: TextStyle(color: Color(0xFF5F5550)),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            Icons.favorite_border,
                            "12 Favorites",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            Icons.shopping_bag_outlined,
                            "orders",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _sectionTitle("ACCOUNT SETTINGS"),
                    _profileItem(
                      icon: Icons.person_outline,
                      title: "Edit My Profile",
                      color: const Color(0xFFFFDCC6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    _profileItem(
                      icon: Icons.location_on_outlined,
                      title: "Shipping Addresses",
                      color: const Color(0xFFCCE1FF),
                      onTap: () {},
                    ),
                    _profileItem(
                      icon: Icons.payment_outlined,
                      title: "Payment Methods",
                      color: const Color(0xFFF0D7D9),
                      onTap: () {},
                    ),
                    _profileItem(
                      icon: Icons.local_offer_outlined,
                      title: "Coupons",
                      color: const Color(0xFFFFE2D1),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CouponsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    _sectionTitle("ACTIVITY & PREFERENCES"),
                    _profileItem(
                      icon: Icons.inventory_2_outlined,
                      title: "Order History",
                      color: const Color(0xFFE4E4E4),
                      onTap: () {},
                    ),
                    _profileItem(
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      color: const Color(0xFFE1E7EE),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ChangePasswordScreen(fromProfile: true),
                          ),
                        );
                      },
                    ),
                    _profileItem(
                      icon: Icons.favorite_border,
                      title: "Wishlist",
                      color: const Color(0xFFFFDADA),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WishlistScreen(),
                          ),
                        );
                      },
                    ),
                    _profileItem(
                      icon: Icons.admin_panel_settings_outlined,
                      title: "Admin Panel",
                      color: const Color(0xFFFFDADA),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminDashboard(),
                          ),
                        );
                      },
                    ),
                    _profileItem(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                      color: const Color(0xFFE5E5E5),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HelpSupportScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => _logout(context),
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD6D2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
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
      alignment: Alignment.center,
      child: const Text(
        "Profile",
        style: TextStyle(
          fontSize: 31,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB56F6F),
          fontFamily: "serif",
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String title) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD38B8B)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26),
          const SizedBox(height: 3),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }
}
