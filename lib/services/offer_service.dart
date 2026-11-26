import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devart/data/local_data.dart';
import 'package:devart/models/offer_model.dart';

class OfferService {
  static final OfferService instance = OfferService._internal();
  factory OfferService() => instance;
  OfferService._internal();

  final CollectionReference<Map<String, dynamic>> _offersRef =
      FirebaseFirestore.instance.collection('offers');

  bool _seeded = false;

  Stream<List<OfferModel>> getOffersStream({
    String? filter,
    String? searchQuery,
  }) {
    return _offersRef.snapshots().map((snapshot) {
      List<OfferModel> filtered = snapshot.docs
          .map((doc) => OfferModel.fromMap(doc.data(), id: doc.id))
          .toList()
        ..sort((a, b) => (b.createdAt ?? DateTime(2000))
            .compareTo(a.createdAt ?? DateTime(2000)));

      if (filter != null &&
          filter != "All Offers" &&
          filter != "All" &&
          filter.trim().isNotEmpty) {
        final f = filter.trim().toLowerCase();
        if (f == "active") {
          filtered = filtered
              .where((o) => !o.isExpired && o.status.toLowerCase() == "active")
              .toList();
        } else if (f == "expired") {
          filtered = filtered
              .where((o) => o.isExpired || o.status.toLowerCase() == "expired")
              .toList();
        } else if (f == "percentage") {
          filtered = filtered
              .where((o) => o.discountType.toLowerCase() == "percentage")
              .toList();
        } else if (f == "fixed") {
          filtered = filtered
              .where((o) => o.discountType.toLowerCase() == "fixed")
              .toList();
        }
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        filtered = filtered.where((o) {
          return o.title.toLowerCase().contains(q) ||
              o.code.toLowerCase().contains(q) ||
              (o.description != null &&
                  o.description!.toLowerCase().contains(q));
        }).toList();
      }

      return filtered;
    });
  }

  Future<String> addOffer(OfferModel offer) async {
    final docRef =
        offer.id.isNotEmpty ? _offersRef.doc(offer.id) : _offersRef.doc();

    final newOffer = offer.copyWith(
      id: docRef.id,
      createdAt: offer.createdAt ?? DateTime.now(),
    );

    await docRef.set(newOffer.toMap());
    return docRef.id;
  }

  Future<void> updateOffer(OfferModel offer) async {
    await _offersRef
        .doc(offer.id)
        .set(offer.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteOffer(String offerId) async {
    await _offersRef.doc(offerId).delete();
  }

  Future<OfferModel?> getOfferByCode(String code) async {
    final cleanCode = code.trim().toUpperCase();
    final snap = await _offersRef
        .where('code', isEqualTo: cleanCode)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    final doc = snap.docs.first;
    return OfferModel.fromMap(doc.data(), id: doc.id);
  }

  Future<void> seedInitialOffersIfEmpty() async {
    if (_seeded) return;
    _seeded = true;

    try {
      final existing = await _offersRef.limit(1).get();
      if (existing.docs.isEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        for (final offer in LocalData.getInitialOffers()) {
          final docRef = _offersRef.doc(offer.id);
          batch.set(docRef, offer.toMap());
        }
        await batch.commit();
      }
    } catch (_) {
      _seeded = false;
    }
  }
}
