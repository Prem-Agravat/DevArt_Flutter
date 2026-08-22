import 'package:devart/common/app_shell.dart';
import 'package:devart/common/action_popup.dart';
import 'package:flutter/material.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 3,
      selectedDrawerItem: "Coupons",
      showCart: true,
      showBottomNav: true,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 35, 18, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Available Coupons",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    _couponCard(
                      context,
                      label: "WELCOME OFFER",
                      title: "15% OFF First Order",
                      detail: "Valid until AUG 31, 2026",
                      code: "NEWARTISAN15",
                      icon: Icons.local_offer_outlined,
                    ),
                    _couponCard(
                      context,
                      label: "FREESHIP",
                      title: "Free Delivery",
                      detail: "Min spend ₹500",
                      code: "FREESHIPPART",
                      icon: Icons.local_shipping_outlined,
                    ),
                    _couponCard(
                      context,
                      label: "BUNDLE DEAL",
                      title: "₹200 Reward Credit",
                      detail: "For recurring customers",
                      code: "DEVARTLOYAL",
                      icon: Icons.payments_outlined,
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

  Widget _buildTitle(BuildContext context) {
    return Container(
      height: 64,
      color: const Color(0xFFF5E9E5),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Coupons",
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB56F6F),
                  fontFamily: "serif",
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _couponCard(
    BuildContext context, {
    required String label,
    required String title,
    required String detail,
    required String code,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(18, 14, 15, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8DDD7), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF41648A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Icon(icon, color: const Color(0xFF8D5D3A), size: 23),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Color(0xFFE0C7B8)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF594E49),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      code,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF80502F),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  showSuccessPopup(
                    context,
                    title: "Coupon Copied",
                    message: "$code has been copied successfully.",
                    buttonText: "Continue",
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF2EDE9),
                ),
                icon: const Icon(Icons.copy_outlined, color: Color(0xFF8D5D3A)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
