import 'package:flutter/material.dart';
import 'package:devart/common/admin_shell.dart';
import 'package:devart/admin/offers/add_offer.dart';
import 'package:devart/admin/offers/edit_offer.dart';
import 'package:devart/models/offer_model.dart';
import 'package:devart/services/offer_service.dart';

class OfferManagementScreen extends StatefulWidget {
  const OfferManagementScreen({super.key});

  @override
  State<OfferManagementScreen> createState() => _OfferManagementScreenState();
}

class _OfferManagementScreenState extends State<OfferManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _offerFilterScrollController = ScrollController();
  final OfferService _offerService = OfferService();

  int selectedOfferFilter = 0;

  final List<String> offerFilters = [
    "All Offers",
    "Active",
    "Expired",
    "Percentage",
    "Fixed",
  ];

  @override
  void initState() {
    super.initState();
    _offerService.seedInitialOffersIfEmpty();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _offerFilterScrollController.dispose();
    super.dispose();
  }

  Future<void> _deleteOffer(OfferModel offer) async {
    try {
      await _offerService.deleteOffer(offer.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Offer deleted successfully."),
          backgroundColor: Color(0xFF704522),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete offer: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDelete(BuildContext context, OfferModel offer) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: const EdgeInsets.fromLTRB(25, 25, 25, 18),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFFFD8D8),
                child: Icon(Icons.delete_outline, size: 35, color: Colors.red),
              ),
              const SizedBox(height: 18),
              const Text(
                "Delete Offer?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Are you sure you want to delete\n\"${offer.title}\"?",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _deleteOffer(offer);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedFilterName = offerFilters[selectedOfferFilter];
    final canPop = Navigator.canPop(context);

    return AdminShell(
      selectedIndex: 3,
      child: Stack(
        children: [
          Column(
            children: [
              _buildTitle(canPop),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 18, bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _buildSearchBox(),
                      ),
                      const SizedBox(height: 12),
                      _buildOfferFilters(),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: StreamBuilder<List<OfferModel>>(
                          stream: _offerService.getOffersStream(
                            filter: selectedFilterName,
                            searchQuery: _searchController.text,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 80),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF704522),
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return _buildErrorState(
                                snapshot.error.toString(),
                              );
                            }

                            final offers = snapshot.data ?? [];

                            if (offers.isEmpty) {
                              return _buildEmptyState(
                                filter: selectedFilterName,
                                searchQuery: _searchController.text.trim(),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: offers.length,
                              itemBuilder: (context, index) {
                                return _buildOfferCard(
                                  context,
                                  offers[index],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Sticky Bottom "Add Offer" Button matching Inventory design
          Positioned(
            right: 20,
            bottom: 25,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddOfferScreen(),
                  ),
                );
              },
              child: Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF704522),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(bool canPop) {
    return Container(
      height: 59,
      width: double.infinity,
      color: const Color(0xFFF5E9E5),
      child: Row(
        children: [
          if (canPop)
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 24,
                color: Colors.black,
              ),
            )
          else
            const SizedBox(width: 20),
          const Expanded(
            child: Center(
              child: Text(
                "Offer Management",
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB56F6F),
                  fontFamily: "serif",
                ),
              ),
            ),
          ),
          if (canPop) const SizedBox(width: 48) else const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, size: 26, color: Colors.black),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20, color: Colors.black54),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          hintText: "Search offers by title or promo code...",
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  Widget _buildOfferFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        controller: _offerFilterScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: offerFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = selectedOfferFilter == index;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                setState(() {
                  selectedOfferFilter = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF704522)
                      : const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF704522)
                        : const Color(0xFFD0D0D0),
                    width: selected ? 1.5 : 1,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF704522).withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                ),
                child: Text(
                  offerFilters[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : const Color(0xFF333333),
                    fontFamily: "serif",
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, OfferModel offer) {
    final bool isExpired = offer.isExpired;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black54),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFD0E3FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.local_offer_outlined,
                  size: 28,
                  color: Color(0xFF704522),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "serif",
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        offer.code,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF704522),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(isExpired ? "Expired" : offer.status),
            ],
          ),

          if (offer.description != null && offer.description!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              offer.description!,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.black26),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _infoItem(
                  offer.discountType == "Fixed"
                      ? Icons.currency_rupee
                      : Icons.percent,
                  "Discount",
                  offer.formattedDiscount,
                ),
              ),
              Expanded(
                child: _infoItem(
                  Icons.category_outlined,
                  "Type",
                  offer.discountType == "Fixed" ? "Fixed Amount" : "Percentage",
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _infoItem(
                  Icons.calendar_today_outlined,
                  "Valid From",
                  offer.formattedValidFrom,
                ),
              ),
              Expanded(
                child: _infoItem(
                  Icons.event_outlined,
                  "Valid Until",
                  offer.formattedValidUntil,
                ),
              ),
            ],
          ),

          if (offer.minSpend != null && offer.minSpend! > 0) ...[
            const SizedBox(height: 10),
            _infoItem(
              Icons.shopping_bag_outlined,
              "Min Spend",
              "₹${offer.minSpend! % 1 == 0 ? offer.minSpend!.toInt() : offer.minSpend!}",
            ),
          ],

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditOfferScreen(offer: offer),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text(
                    "Edit",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF704522),
                    side: const BorderSide(color: Color(0xFF704522)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _confirmDelete(context, offer),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                  label: const Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF704522)),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final bool active = status == "Active";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFD8F0D8) : const Color(0xFFFFD8D8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: active ? const Color(0xFF39733B) : Colors.red,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required String filter,
    required String searchQuery,
  }) {
    String title = "No Offers Found";
    String subtitle = "Add your first offer by tapping the + button below.";

    if (searchQuery.isNotEmpty && filter != "All Offers") {
      title = "No Matching Offers";
      subtitle =
          "No offers matching \"$searchQuery\" in \"$filter\" filter.";
    } else if (searchQuery.isNotEmpty) {
      title = "No Results Found";
      subtitle = "No offers match \"$searchQuery\". Try another search term.";
    } else if (filter != "All Offers") {
      title = "Empty Filter";
      subtitle = "No offers found under \"$filter\".";
    }

    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF5E9E5),
              borderRadius: BorderRadius.circular(35),
            ),
            child: const Icon(
              Icons.local_offer_outlined,
              size: 38,
              color: Color(0xFF704522),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "serif",
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          if (filter != "All Offers" || searchQuery.isNotEmpty)
            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  selectedOfferFilter = 0; // reset to "All Offers"
                });
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Show All Offers"),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF704522),
                side: const BorderSide(color: Color(0xFF704522)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 55,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 14),
          const Text(
            "Unable to load offers",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Please check your internet connection or try again.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF704522),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
