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
  });

  double get totalPrice => price * quantity;
}

class CartService extends ChangeNotifier {
  // Singleton pattern for simple global access across screens
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItemModel> _items = [
    // Pre-populate with initial demo items for immediate display
    CartItemModel(
      id: 'demo_1_16x16',
      productId: 'p1',
      name: 'IndigoGeometry',
      category: 'Handwoven-cotton',
      price: 899.0,
      oldPrice: 1099.0,
      image: 'lib/assets/images/devart_product_1.webp',
      size: '16×16',
      quantity: 1,
    ),
  ];

  String? _appliedPromoCode;
  OfferModel? _appliedOffer;
  double _discountAmount = 0.0;

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  String? get appliedPromoCode => _appliedPromoCode;
  OfferModel? get appliedOffer => _appliedOffer;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shipping => _items.isEmpty ? 0.0 : 36.0;

  double get tax => subtotal * 0.05;

  double get discount => _discountAmount;

  double get total {
    if (_items.isEmpty) return 0.0;
    final totalCalc = subtotal + shipping + tax - discount;
    return totalCalc > 0 ? totalCalc : 0.0;
  }

  void addItem(
    ProductModel product, {
    int quantity = 1,
    String size = "16×16",
  }) {
    final itemId = "${product.id}_$size";
    final index = _items.indexWhere((item) => item.id == itemId);

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItemModel(
          id: itemId,
          productId: product.id,
          name: product.name,
          category: product.category,
          price: product.price,
          oldPrice: product.oldPrice,
          image: product.image,
          size: size,
          quantity: quantity,
        ),
      );
    }
    _recalculateDiscount();
    notifyListeners();
  }

  void increaseQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index].quantity++;
      _recalculateDiscount();
      notifyListeners();
    }
  }

  void decreaseQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      _recalculateDiscount();
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    _recalculateDiscount();
    notifyListeners();
  }

  // Apply offer directly from an OfferModel
  bool applyOffer(OfferModel offer) {
    if (offer.isExpired) {
      return false;
    }
    if (offer.minSpend != null && subtotal < offer.minSpend!) {
      return false;
    }

    _appliedOffer = offer;
    _appliedPromoCode = offer.code;
    _computeDiscount();
    notifyListeners();
    return true;
  }

  // Async lookup supporting live Firestore offers + fallback codes
  Future<({bool success, String message})> applyPromoAsync(String code) async {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      return (success: false, message: "Please enter a valid coupon code.");
    }

    if (_items.isEmpty) {
      return (success: false, message: "Your cart is empty.");
    }

    try {
      final offer = await OfferService().getOfferByCode(cleanCode);
      if (offer != null) {
        if (offer.isExpired || offer.status.toLowerCase() == "expired") {
          return (success: false, message: "This coupon has expired.");
        }
        if (offer.status.toLowerCase() != "active") {
          return (success: false, message: "This coupon is currently inactive.");
        }
        if (offer.minSpend != null && subtotal < offer.minSpend!) {
          final req = offer.minSpend! % 1 == 0 ? offer.minSpend!.toInt() : offer.minSpend!;
          return (success: false, message: "Minimum cart value of ₹$req required.");
        }

        _appliedOffer = offer;
        _appliedPromoCode = offer.code;
        _computeDiscount();
        notifyListeners();
        return (
          success: true,
          message: "Coupon applied! Saved ₹${_discountAmount.toStringAsFixed(0)}"
        );
      }
    } catch (_) {}

    // Fallback demo coupon codes
    if (cleanCode == "DEVART10" || cleanCode == "WELCOME10" || cleanCode == "DISCOUNT") {
      _appliedOffer = null;
      _appliedPromoCode = cleanCode;
      _discountAmount = (subtotal * 0.10).clamp(0.0, subtotal);
      notifyListeners();
      return (
        success: true,
        message: "Coupon applied! Saved ₹${_discountAmount.toStringAsFixed(0)}"
      );
    } else if (cleanCode == "ARTISAN20" || cleanCode == "DEVART20" || cleanCode == "FESTIVE20") {
      _appliedOffer = null;
      _appliedPromoCode = cleanCode;
      _discountAmount = (subtotal * 0.20).clamp(0.0, subtotal);
      notifyListeners();
      return (
        success: true,
        message: "Coupon applied! Saved ₹${_discountAmount.toStringAsFixed(0)}"
      );
    } else if (cleanCode == "FLAT500") {
      if (subtotal < 2000) {
        return (success: false, message: "Minimum cart value of ₹2000 required.");
      }
      _appliedOffer = null;
      _appliedPromoCode = cleanCode;
      _discountAmount = 500.0.clamp(0.0, subtotal);
      notifyListeners();
      return (
        success: true,
        message: "Coupon applied! Saved ₹${_discountAmount.toStringAsFixed(0)}"
      );
    }

    return (success: false, message: "Invalid coupon code.");
  }

  // Synchronous fallback
  bool applyPromo(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) return false;

    if (cleanCode == "DEVART10" || cleanCode == "WELCOME10" || cleanCode == "DISCOUNT") {
      _appliedOffer = null;
      _appliedPromoCode = cleanCode;
      _discountAmount = (subtotal * 0.10).clamp(0.0, subtotal);
      notifyListeners();
      return true;
    } else if (cleanCode == "ARTISAN20" || cleanCode == "DEVART20" || cleanCode == "FESTIVE20") {
      _appliedOffer = null;
      _appliedPromoCode = cleanCode;
      _discountAmount = (subtotal * 0.20).clamp(0.0, subtotal);
      notifyListeners();
      return true;
    } else if (cleanCode == "FLAT500") {
      if (subtotal < 2000) return false;
      _appliedOffer = null;
      _appliedPromoCode = cleanCode;
      _discountAmount = 500.0.clamp(0.0, subtotal);
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    _appliedOffer = null;
    _appliedPromoCode = null;
    _discountAmount = 0.0;
    notifyListeners();
  }

  void _computeDiscount() {
    if (_appliedOffer != null) {
      if (_appliedOffer!.minSpend != null && subtotal < _appliedOffer!.minSpend!) {
        _discountAmount = 0.0;
      } else if (_appliedOffer!.discountType.toLowerCase() == "fixed") {
        _discountAmount = _appliedOffer!.discount.clamp(0.0, subtotal);
      } else {
        _discountAmount = (subtotal * (_appliedOffer!.discount / 100.0)).clamp(0.0, subtotal);
      }
    }
  }

  void _recalculateDiscount() {
    if (_items.isEmpty) {
      _discountAmount = 0.0;
    } else if (_appliedOffer != null) {
      _computeDiscount();
    } else if (_appliedPromoCode != null) {
      applyPromo(_appliedPromoCode!);
    }
  }

  void clearCart() {
    _items.clear();
    _appliedOffer = null;
    _appliedPromoCode = null;
    _discountAmount = 0.0;
    notifyListeners();
  }
}
