import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:devart/models/product_model.dart';
import 'package:devart/models/offer_model.dart';
import 'package:devart/services/offer_service.dart';

class CartItemModel {
  final String id;
  final String productId;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String image;
  final String size;
  int quantity;
  double totalPrice;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.image,
    required this.size,
    this.quantity = 1,
  }) : totalPrice = price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'category': category,
      'price': price,
      'oldPrice': oldPrice,
      'image': image,
      'size': size,
      'quantity': quantity,
    };
  }

  static CartItemModel fromMap(Map<String, dynamic> data, {String? id}) {
    return CartItemModel(
      id: id ?? data['id']?.toString() ?? '',
      productId: data['productId']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      price: (data['price'] is num) ? (data['price'] as num).toDouble() : 0.0,
      oldPrice: (data['oldPrice'] is num)
          ? (data['oldPrice'] as num).toDouble()
          : null,
      image: data['image']?.toString() ??
          'lib/assets/images/devart_product_1.webp',
      size: data['size']?.toString() ?? '16×16',
      quantity:
          (data['quantity'] is num) ? (data['quantity'] as num).toInt() : 1,
    );
  }
}

class CartService extends ChangeNotifier {
  static final CartService instance = CartService._internal();
  factory CartService() => instance;
  CartService._internal();

  String? _uid;
  final List<CartItemModel> items = [];
  int itemCount = 0;
  String? appliedPromoCode;
  OfferModel? appliedOffer;
  double discount = 0.0;
  double subtotal = 0.0;
  double shipping = 0.0;
  double tax = 0.0;
  double total = 0.0;

  String? get _effectiveUid {
    if (_uid != null && _uid!.isNotEmpty) return _uid;
    final authUid = FirebaseAuth.instance.currentUser?.uid;
    return (authUid != null && authUid.isNotEmpty) ? authUid : null;
  }

  CollectionReference<Map<String, dynamic>>? get _cartRef {
    final uid = _effectiveUid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart');
  }

  Future<void> loadForUser(String? uid) async {
    _uid = uid;
    items.clear();
    appliedOffer = null;
    appliedPromoCode = null;
    discount = 0.0;

    if (uid == null || uid.isEmpty) {
      _calculateTotals();
      notifyListeners();
      return;
    }

    try {
      final snap = await _cartRef!.get();
      for (final doc in snap.docs) {
        items.add(CartItemModel.fromMap(doc.data(), id: doc.id));
      }
    } catch (_) {}

    _calculateTotals();
    notifyListeners();
  }

  void _calculateTotals() {
    itemCount = 0;
    subtotal = 0.0;
    for (var item in items) {
      item.totalPrice = item.price * item.quantity;
      itemCount += item.quantity;
      subtotal += item.totalPrice;
    }
    shipping = items.isEmpty ? 0.0 : 36.0;
    tax = subtotal * 0.05;
    final totalCalc = subtotal + shipping + tax - discount;
    total = totalCalc > 0 ? totalCalc : 0.0;
  }

  Future<void> _saveCartItem(CartItemModel item) async {
    final ref = _cartRef;
    if (ref == null) return;
    try {
      await ref.doc(item.id).set(item.toMap());
    } catch (e) {
      debugPrint('CartService save error: $e');
    }
  }

  Future<void> _deleteCartItem(String itemId) async {
    final ref = _cartRef;
    if (ref == null) return;
    try {
      await ref.doc(itemId).delete();
    } catch (e) {
      debugPrint('CartService delete error: $e');
    }
  }

  void addItem(
    ProductModel product, {
    int quantity = 1,
    String size = "16×16",
  }) {
    final itemId = "${product.id}_$size";
    final index = items.indexWhere((item) => item.id == itemId);

    if (index >= 0) {
      items[index].quantity += quantity;
      _saveCartItem(items[index]);
    } else {
      final newItem = CartItemModel(
        id: itemId,
        productId: product.id,
        name: product.name,
        category: product.category,
        price: product.price,
        oldPrice: product.oldPrice,
        image: product.image,
        size: size,
        quantity: quantity,
      );
      items.add(newItem);
      _saveCartItem(newItem);
    }
    _recalculateDiscount();
    _calculateTotals();
    notifyListeners();
  }

  void increaseQuantity(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      items[index].quantity++;
      _saveCartItem(items[index]);
      _recalculateDiscount();
      _calculateTotals();
      notifyListeners();
    }
  }

  void decreaseQuantity(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
        _saveCartItem(items[index]);
      } else {
        items.removeAt(index);
        _deleteCartItem(itemId);
      }
      _recalculateDiscount();
      _calculateTotals();
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
    _deleteCartItem(itemId);
    _recalculateDiscount();
    _calculateTotals();
    notifyListeners();
  }

  bool applyOffer(OfferModel offer) {
    if (offer.isExpired) {
      return false;
    }
    if (offer.minSpend != null && subtotal < offer.minSpend!) {
      return false;
    }

    appliedOffer = offer;
    appliedPromoCode = offer.code;
    _computeDiscount();
    _calculateTotals();
    notifyListeners();
    return true;
  }

  Future<({bool success, String message})> applyPromoAsync(String code) async {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      return (success: false, message: "Please enter a valid coupon code.");
    }

    if (items.isEmpty) {
      return (success: false, message: "Your cart is empty.");
    }

    try {
      final offer = await OfferService.instance.getOfferByCode(cleanCode);
      if (offer != null) {
        if (offer.isExpired || offer.status.toLowerCase() == "expired") {
          return (success: false, message: "This coupon has expired.");
        }
        if (offer.status.toLowerCase() != "active") {
          return (success: false, message: "This coupon is currently inactive.");
        }
        if (offer.minSpend != null && subtotal < offer.minSpend!) {
          final req = offer.minSpend! % 1 == 0
              ? offer.minSpend!.toInt()
              : offer.minSpend!;
          return (
            success: false,
            message: "Minimum cart value of ₹$req required."
          );
        }

        appliedOffer = offer;
        appliedPromoCode = offer.code;
        _computeDiscount();
        _calculateTotals();
        notifyListeners();
        return (
          success: true,
          message: "Coupon applied! Saved ₹${discount.toStringAsFixed(0)}"
        );
      }
    } catch (_) {}

    return (success: false, message: "Invalid coupon code.");
  }

  bool applyPromo(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) return false;

    if (appliedOffer != null && appliedOffer!.code == cleanCode) {
      _computeDiscount();
      _calculateTotals();
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    appliedOffer = null;
    appliedPromoCode = null;
    discount = 0.0;
    _calculateTotals();
    notifyListeners();
  }

  void _computeDiscount() {
    if (appliedOffer != null) {
      if (appliedOffer!.minSpend != null && subtotal < appliedOffer!.minSpend!) {
        discount = 0.0;
      } else if (appliedOffer!.discountType.toLowerCase() == "fixed") {
        discount = appliedOffer!.discount.clamp(0.0, subtotal);
      } else {
        discount =
            (subtotal * (appliedOffer!.discount / 100.0)).clamp(0.0, subtotal);
      }
    }
  }

  void _recalculateDiscount() {
    if (items.isEmpty) {
      discount = 0.0;
    } else if (appliedOffer != null) {
      _computeDiscount();
    } else if (appliedPromoCode != null) {
      applyPromo(appliedPromoCode!);
    }
  }

  Future<void> clearCart() async {
    items.clear();
    appliedOffer = null;
    appliedPromoCode = null;
    discount = 0.0;
    _calculateTotals();
    notifyListeners();

    final ref = _cartRef;
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
}
