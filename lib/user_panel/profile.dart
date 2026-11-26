import 'package:devart/admin/dashboard/admin_dashboard.dart';
import 'package:devart/common/action_popup.dart';
import 'package:devart/common/app_shell.dart';
import 'package:devart/services/auth_service.dart';
import 'package:devart/services/wishlist_service.dart';
import 'package:devart/user_panel/login.dart';
import 'package:devart/user_panel/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devart/user_panel/edit_profile.dart';
import 'package:devart/user_panel/change_password.dart';
import 'package:devart/user_panel/wishlist.dart';
import 'package:devart/user_panel/coupons.dart';
import 'package:devart/user_panel/help_support.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _logout(BuildContext context) async {
    await context.read<AuthService>().logout();
    if (!context.mounted) return;
    showSuccessPopup(
      context,
      title: "Logout",
      message: "You have been logged out successfully.",
      buttonText: "Continue",
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final wishlistService = context.watch<WishlistService>();
    final user = authService.currentUser;
    final userEmail = user.email;
    final userName = user.displayName.isNotEmpty
        ? user.displayName
        : (userEmail.isNotEmpty ? userEmail.split('@')[0] : "User");
    final wishlistCount = wishlistService.count;

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
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail.isNotEmpty ? userEmail : "user@devart.com",
                      style: const TextStyle(color: Color(0xFF5F5550)),
                    ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WishlistScreen(),
                                    ),
                                  );
                                },
                                child: _statCard(
                                  Icons.favorite_border,
                                  "$wishlistCount Favorites",
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const OrdersScreen(),
                                    ),
                                  );
                                },
                                child: _statCard(
                                  Icons.shopping_bag_outlined,
                                  "My Orders",
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                        _sectionTitle("ACCOUNT SETTINGS"),
                        if (authService.isAdmin)
                          _profileItem(
                            icon: Icons.admin_panel_settings_outlined,
                            title: "Admin Panel",
                            color: const Color(0xFFBFD5FA),
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
                          icon: Icons.person_outline,
                          title: "Edit My Profile",
                          color: const Color(0xFFBFD5FA),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );
                          },
                        ),
                        _profileItem(
                          icon: Icons.local_offer_outlined,
                          title: "Coupons",
                          color: const Color(0xFFBFD5FA),
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
                          icon: Icons.lock_outline,
                          title: "Change Password",
                          color: const Color(0xFFBFD5FA),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChangePasswordScreen(
                                  fromProfile: true,
                                ),
                              ),
                            );
                          },
                        ),
                        _profileItem(
                          icon: Icons.favorite_border,
                          title: "Wishlist",
                          color: const Color(0xFFBFD5FA),
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
                          icon: Icons.help_outline,
                          title: "Help & Support",
                          color: const Color(0xFFBFD5FA),
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
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
    String? subtitle,
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
        child: Icon(icon, color: const Color(0xFF2A201A)),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF5F5550)),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }
}
