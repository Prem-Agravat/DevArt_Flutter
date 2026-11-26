import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:devart/models/product_model.dart';

class WishlistService extends ChangeNotifier {
  static final WishlistService instance = WishlistService._internal();
  factory WishlistService() => instance;
  WishlistService._internal();

  String? _uid;
  final List<ProductModel> items = [];
  int count = 0;

  String? get _effectiveUid {
    if (_uid != null && _uid!.isNotEmpty) return _uid;
    final authUid = FirebaseAuth.instance.currentUser?.uid;
    return (authUid != null && authUid.isNotEmpty) ? authUid : null;
  }

  CollectionReference<Map<String, dynamic>>? get _wishlistRef {
    final uid = _effectiveUid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('wishlist');
  }

  Future<void> loadForUser(String? uid) async {
    _uid = uid;
    items.clear();
    count = 0;

    if (uid == null || uid.isEmpty) {
      notifyListeners();
      return;
    }

    try {
      final snap = await _wishlistRef!.get();
      for (final doc in snap.docs) {
        items.add(ProductModel.fromMap(doc.data(), id: doc.id));
      }
      count = items.length;
    } catch (_) {}

    notifyListeners();
  }

  bool isWishlisted(String productId) {
    if (productId.isEmpty) return false;
    final query = productId.trim().toLowerCase();
    return items.any((item) =>
        item.id.trim().toLowerCase() == query ||
        item.name.trim().toLowerCase() == query);
  }

  bool isProductWishlisted(ProductModel product) {
    if (product.id.isNotEmpty && isWishlisted(product.id)) return true;
    if (product.name.isNotEmpty && isWishlisted(product.name)) return true;
    return false;
  }

  void toggleWishlist(ProductModel product) {
    final pId = product.id.trim().toLowerCase();
    final pName = product.name.trim().toLowerCase();

    final index = items.indexWhere((item) {
      final matchesId = pId.isNotEmpty && item.id.trim().toLowerCase() == pId;
      final matchesName =
          pName.isNotEmpty && item.name.trim().toLowerCase() == pName;
      return matchesId || matchesName;
    });

    if (index >= 0) {
      final removed = items.removeAt(index);
      _deleteFromFirestore(removed.id);
    } else {
      items.add(product);
      _saveToFirestore(product);
    }
    count = items.length;
    notifyListeners();
  }

  void addToWishlist(ProductModel product) {
    if (!isProductWishlisted(product)) {
      items.add(product);
      count = items.length;
      _saveToFirestore(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(String productId) {
    items.removeWhere(
      (item) => item.id == productId || item.name == productId,
    );
    count = items.length;
    _deleteFromFirestore(productId);
    notifyListeners();
  }

  Future<void> clearWishlist() async {
    items.clear();
    count = 0;
    notifyListeners();

    final ref = _wishlistRef;
    if (ref != null) {
      try {
        final snap = await ref.get();
        final batch = FirebaseFirestore.instance.batch();
        for (final doc in snap.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      } catch (_) {}
    }
  }

  Future<void> _saveToFirestore(ProductModel product) async {
    final ref = _wishlistRef;
    if (ref == null || product.id.isEmpty) return;
    try {
      await ref.doc(product.id).set(product.toMap());
    } catch (e) {
      debugPrint('WishlistService save error: $e');
    }
  }

  Future<void> _deleteFromFirestore(String productId) async {
    final ref = _wishlistRef;
    if (ref == null || productId.isEmpty) return;
    try {
      await ref.doc(productId).delete();
    } catch (e) {
      debugPrint('WishlistService delete error: $e');
    }
  }
}
