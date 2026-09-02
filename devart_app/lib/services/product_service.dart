import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devart/models/product_model.dart';

class ProductService {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  // ============================================================
  // STREAM REAL-TIME PRODUCTS
  // ============================================================

  Stream<List<ProductModel>> getProductsStream({
    String? category,
    String? searchQuery,
  }) {
    Query query = _productsRef.orderBy('createdAt', descending: true);

    if (category != null && category != "All" && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      List<ProductModel> products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        products = products.where((p) {
          return p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q);
        }).toList();
      }

      return products;
    });
  }

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  Future<String> addProduct(ProductModel product) async {
    final docRef = await _productsRef.add(product.toMap());
    return docRef.id;
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<void> updateProduct(ProductModel product) async {
    await _productsRef.doc(product.id).update(product.toMap());
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).delete();
  }

  // ============================================================
  // SEED INITIAL PRODUCTS (Runs only if database is empty)
  // ============================================================

  Future<void> seedInitialProductsIfEmpty() async {
    try {
      final snapshot = await _productsRef.limit(1).get();
      if (snapshot.docs.isEmpty) {
        final initialProducts = [
          ProductModel(
            id: '',
            name: 'IndigoGeometry Cushion',
            category: 'Cushion Covers',
            price: 899.0,
            oldPrice: 1099.0,
            stock: 15,
            description:
                'Hand-dyed indigo fabric with unique geometric patterns. Made by master artisans using traditional vat-dyeing techniques.',
            image: 'lib/assets/images/devart_product_1.webp',
          ),
          ProductModel(
            id: '',
            name: 'Handcrafted Toran',
            category: 'Toran',
            price: 1299.0,
            oldPrice: 1599.0,
            stock: 8,
            description:
                'Traditional doorway hanging crafted with vibrant embroidered patches and mirror work.',
            image: 'lib/assets/images/devart_product_1.webp',
          ),
          ProductModel(
            id: '',
            name: 'Terracotta Ceramic Vase',
            category: 'Pottery',
            price: 749.0,
            oldPrice: 899.0,
            stock: 12,
            description:
                'Earthy clay pottery vase fired with natural glazes, perfect for living spaces.',
            image: 'lib/assets/images/devart_product_1.webp',
          ),
        ];

        for (final product in initialProducts) {
          await _productsRef.add(product.toMap());
        }
      }
    } catch (_) {
      // Ignored if offline or rules restrict
    }
  }
}
