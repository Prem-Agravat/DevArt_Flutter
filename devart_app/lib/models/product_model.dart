import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final int stock;
  final String description;
  final String image;
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.stock,
    required this.description,
    required this.image,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'oldPrice': oldPrice,
      'stock': stock,
      'description': description,
      'image': image,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime? createdTime;
    if (data['createdAt'] is Timestamp) {
      createdTime = (data['createdAt'] as Timestamp).toDate();
    }

    return ProductModel(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      category: data['category']?.toString() ?? 'Pottery',
      price: (data['price'] is num)
          ? (data['price'] as num).toDouble()
          : double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
      oldPrice: (data['oldPrice'] is num)
          ? (data['oldPrice'] as num).toDouble()
          : (data['oldPrice'] != null
              ? double.tryParse(data['oldPrice'].toString())
              : null),
      stock: (data['stock'] is num)
          ? (data['stock'] as num).toInt()
          : int.tryParse(data['stock']?.toString() ?? '1') ?? 1,
      description: data['description']?.toString() ?? '',
      image: data['image']?.toString() ??
          'lib/assets/images/devart_product_1.webp',
      createdAt: createdTime,
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    double? oldPrice,
    int? stock,
    String? description,
    String? image,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
