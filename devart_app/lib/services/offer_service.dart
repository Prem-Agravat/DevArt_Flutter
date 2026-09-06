import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devart/models/offer_model.dart';

class OfferService {
  final CollectionReference _offersRef =
      FirebaseFirestore.instance.collection('offers');

  // ============================================================
  // STREAM REAL-TIME OFFERS (Client-side filtering for index safety)
  // ============================================================
  Stream<List<OfferModel>> getOffersStream({
    String? filter,
    String? searchQuery,
  }) {
    return _offersRef.snapshots().map((snapshot) {
      List<OfferModel> offers = snapshot.docs
          .map((doc) => OfferModel.fromFirestore(doc))
          .toList();

      // Sort by newest created first
      offers.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      // Filter by Category / Status / Type
      if (filter != null && filter != "All Offers" && filter != "All" && filter.trim().isNotEmpty) {
        final f = filter.trim().toLowerCase();
        if (f == "active") {
          offers = offers.where((o) => !o.isExpired && o.status.toLowerCase() == "active").toList();
        } else if (f == "expired") {
          offers = offers.where((o) => o.isExpired || o.status.toLowerCase() == "expired").toList();
        } else if (f == "percentage") {
          offers = offers.where((o) => o.discountType.toLowerCase() == "percentage").toList();
        } else if (f == "fixed") {
          offers = offers.where((o) => o.discountType.toLowerCase() == "fixed").toList();
        }
      }

      // Filter by Search Query
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        offers = offers.where((o) {
          return o.title.toLowerCase().contains(q) ||
              o.code.toLowerCase().contains(q) ||
              (o.description != null && o.description!.toLowerCase().contains(q));
        }).toList();
      }

      return offers;
    });
  }

  // ============================================================
  // ADD OFFER
  // ============================================================
  Future<String> addOffer(OfferModel offer) async {
    final docRef = await _offersRef.add(offer.toMap());
    return docRef.id;
  }

  // ============================================================
  // UPDATE OFFER
  // ============================================================
  Future<void> updateOffer(OfferModel offer) async {
    await _offersRef.doc(offer.id).update(offer.toMap());
  }

  // ============================================================
  // DELETE OFFER
  // ============================================================
  Future<void> deleteOffer(String offerId) async {
    await _offersRef.doc(offerId).delete();
  }

  // ============================================================
  // SEED INITIAL OFFERS (Runs only if database collection is empty)
  // ============================================================
  Future<void> seedInitialOffersIfEmpty() async {
    try {
      final snapshot = await _offersRef.limit(1).get();
      if (snapshot.docs.isEmpty) {
        final now = DateTime.now();
        final initialOffers = [
          OfferModel(
            id: '',
            title: 'Festive Special',
            code: 'FESTIVE20',
            discount: 20.0,
            discountType: 'Percentage',
            validFrom: DateTime(now.year, now.month, 1),
            validUntil: DateTime(now.year, now.month + 1, 15),
            status: 'Active',
            description: 'Get 20% off on all festive handcrafted items.',
          ),
          OfferModel(
            id: '',
            title: 'New User Offer',
            code: 'WELCOME10',
            discount: 10.0,
            discountType: 'Percentage',
            validFrom: DateTime(now.year, 1, 1),
            validUntil: DateTime(now.year, 12, 31),
            status: 'Active',
            description: 'Exclusive 10% discount for first-time shoppers.',
          ),
          OfferModel(
            id: '',
            title: 'Flat ₹500 Off',
            code: 'FLAT500',
            discount: 500.0,
            discountType: 'Fixed',
            validFrom: DateTime(now.year, now.month - 1, 1),
            validUntil: DateTime(now.year, now.month - 1, 25),
            status: 'Expired',
            description: 'Flat ₹500 off on orders above ₹2000.',
            minSpend: 2000.0,
          ),
        ];

        for (final offer in initialOffers) {
          await _offersRef.add(offer.toMap());
        }
      }
    } catch (_) {
      // Ignored if offline or rules restrict
    }
  }
}
