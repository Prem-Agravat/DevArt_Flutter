import 'package:devart/common/app_shell.dart';
import 'package:devart/common/action_popup.dart';
import 'package:devart/models/offer_model.dart';
import 'package:devart/services/offer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final OfferService _offerService = OfferService();

  @override
  void initState() {
    super.initState();
    _offerService.seedInitialOffersIfEmpty();
  }

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
                padding: const EdgeInsets.fromLTRB(18, 25, 18, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Available Coupons",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    StreamBuilder<List<OfferModel>>(
                      stream: _offerService.getOffersStream(filter: "Active"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF704522),
                              ),
                            ),
                          );
                        }

                        final offers = snapshot.data ?? [];

                        if (offers.isEmpty) {
                          return _buildEmptyState();
                        }

                        return Column(
                          children: offers.map((offer) {
                            return _buildOfferCouponCard(context, offer);
                          }).toList(),
                        );
                      },
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

  Widget _buildOfferCouponCard(BuildContext context, OfferModel offer) {
    final String label = offer.discountType == "Fixed"
        ? "FLAT DISCOUNT"
        : "${offer.formattedDiscount} OFF";
    final String title = offer.title;
    final String detail = offer.minSpend != null && offer.minSpend! > 0
        ? "Min spend ₹${offer.minSpend! % 1 == 0 ? offer.minSpend!.toInt() : offer.minSpend!} • Valid until ${offer.formattedValidUntil}"
        : "Valid until ${offer.formattedValidUntil}";

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(18, 14, 15, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8DDD7), width: 2),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD0E3FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                offer.discountType == "Fixed"
                    ? Icons.currency_rupee
                    : Icons.local_offer_outlined,
                color: const Color(0xFF8D5D3A),
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              fontFamily: "serif",
            ),
          ),
          if (offer.description != null && offer.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              offer.description!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
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
                        fontSize: 11,
                        color: Color(0xFF594E49),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      offer.code,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF80502F),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: offer.code));
                  showSuccessPopup(
                    context,
                    title: "Coupon Copied",
                    message: "${offer.code} has been copied to clipboard.",
                    buttonText: "Continue",
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF2EDE9),
                ),
                icon: const Icon(
                  Icons.copy_outlined,
                  color: Color(0xFF8D5D3A),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
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
                Icons.local_offer_outlined,
                size: 35,
                color: Color(0xFF704522),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "No Active Coupons",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "serif",
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Check back later for exciting offers and discounts!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
