import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devart/data/local_data.dart';
import 'package:devart/models/product_model.dart';

class ProductService {
  static final ProductService instance = ProductService._internal();
  factory ProductService() => instance;
  ProductService._internal();

  final CollectionReference<Map<String, dynamic>> _productsRef =
      FirebaseFirestore.instance.collection('products');

  bool _seeded = false;

  Stream<List<ProductModel>> getProductsStream({
    String? category,
    String? searchQuery,
  }) {
    return _productsRef.snapshots().map((snapshot) {
      List<ProductModel> filtered = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), id: doc.id))
          .toList()
        ..sort((a, b) => (b.createdAt ?? DateTime(2000))
            .compareTo(a.createdAt ?? DateTime(2000)));

      if (category != null &&
          category != "All" &&
          category.trim().isNotEmpty) {
        final cat = category.trim().toLowerCase().replaceAll(" ", "");
        filtered = filtered.where((p) {
          return p.category.trim().toLowerCase().replaceAll(" ", "") == cat;
        }).toList();
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        filtered = filtered.where((p) {
          return p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q);
        }).toList();
      }

      return filtered;
    });
  }

  Future<String> addProduct(ProductModel product) async {
    final docRef = product.id.isNotEmpty
        ? _productsRef.doc(product.id)
        : _productsRef.doc();

    final newProduct = product.copyWith(
      id: docRef.id,
      createdAt: product.createdAt ?? DateTime.now(),
    );

    await docRef.set(newProduct.toMap());
    return docRef.id;
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productsRef
        .doc(product.id)
        .set(product.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).delete();
  }

  Future<ProductModel?> getProductById(String id) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return ProductModel.fromMap(doc.data()!, id: doc.id);
  }

  Future<void> seedInitialProductsIfEmpty() async {
    if (_seeded) return;
    _seeded = true;

    try {
      final existing = await _productsRef.limit(1).get();
      if (existing.docs.isEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        for (final product in LocalData.getInitialProducts()) {
          final docRef = _productsRef.doc(product.id);
          batch.set(docRef, product.toMap());
        }
        await batch.commit();
      }
    } catch (_) {
      _seeded = false;
    }
  }
}
