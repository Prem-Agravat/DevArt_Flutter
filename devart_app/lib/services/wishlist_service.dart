import 'package:flutter/foundation.dart';
import 'package:devart/models/product_model.dart';

class WishlistService extends ChangeNotifier {
  // Singleton pattern for simple global access across the app
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  final List<ProductModel> _items = [
    ProductModel(
      id: 'p1',
      name: 'IndigoGeometry Cushion',
      category: 'Handwoven-cotton',
      price: 899.0,
      oldPrice: 1099.0,
      stock: 15,
      description: 'Hand-dyed indigo fabric with unique geometric patterns.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
    ProductModel(
      id: 'p2',
      name: 'Handcrafted Toran',
      category: 'Toran',
      price: 1299.0,
      oldPrice: 1599.0,
      stock: 8,
      description: 'Traditional doorway hanging crafted with vibrant patches.',
      image: 'lib/assets/images/devart_product_1.webp',
    ),
  ];

  List<ProductModel> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool isWishlisted(String productId) {
    if (productId.isEmpty) return false;
    return _items.any((item) => item.id == productId || item.name == productId);
  }

  void toggleWishlist(ProductModel product) {
    final index = _items.indexWhere(
      (item) => item.id == product.id || item.name == product.name,
    );

    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void addToWishlist(ProductModel product) {
    if (!isWishlisted(product.id)) {
      _items.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(String productId) {
    _items.removeWhere((item) => item.id == productId || item.name == productId);
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }
}
