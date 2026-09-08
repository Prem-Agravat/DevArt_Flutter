import 'package:flutter/foundation.dart';
import 'package:devart/models/product_model.dart';

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
  double _discountAmount = 0.0;

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  String? get appliedPromoCode => _appliedPromoCode;

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

  bool applyPromo(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) return false;

    if (cleanCode == "DEVART10" || cleanCode == "WELCOME10" || cleanCode == "DISCOUNT") {
      _appliedPromoCode = cleanCode;
      _discountAmount = 50.0;
      notifyListeners();
      return true;
    } else if (cleanCode == "ARTISAN20" || cleanCode == "DEVART20") {
      _appliedPromoCode = cleanCode;
      _discountAmount = 100.0;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    _appliedPromoCode = null;
    _discountAmount = 0.0;
    notifyListeners();
  }

  void _recalculateDiscount() {
    if (_items.isEmpty) {
      _discountAmount = 0.0;
    }
  }

  void clearCart() {
    _items.clear();
    _appliedPromoCode = null;
    _discountAmount = 0.0;
    notifyListeners();
  }
}
