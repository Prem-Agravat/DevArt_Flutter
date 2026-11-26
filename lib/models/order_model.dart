import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItemModel {
  final String? productId;
  final String name;
  final int quantity;
  final double price;
  final String image;
  final double total;
  final String formattedPrice;
  final String formattedTotal;

  OrderItemModel({
    this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    this.image = "lib/assets/images/devart_product_1.webp",
  })  : total = price * quantity,
        formattedPrice =
            "₹${price.toStringAsFixed(price % 1 == 0 ? 0 : 2)}",
        formattedTotal =
            "₹${(price * quantity).toStringAsFixed((price * quantity) % 1 == 0 ? 0 : 2)}";

  Map<String, dynamic> toMap() {
    return {
      if (productId != null) 'productId': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }

  static OrderItemModel fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId']?.toString(),
      name: map['name']?.toString() ?? 'Artisan Craft Item',
      quantity: (map['quantity'] is num)
          ? (map['quantity'] as num).toInt()
          : int.tryParse(map['quantity']?.toString() ?? '1') ?? 1,
      price: (map['price'] is num)
          ? (map['price'] as num).toDouble()
          : double.tryParse(map['price']
                  ?.toString()
                  .replaceAll(RegExp(r'[^0-9.]'), '') ??
              '0') ??
          0.0,
      image:
          map['image']?.toString() ?? 'lib/assets/images/devart_product_1.webp',
    );
  }
}

class OrderModel {
  final String id;
  final String orderId;
  final String? userId;
  final String customer;
  final String email;
  final String phone;
  final String address;
  final String date;
  final List<OrderItemModel> items;
  final double deliveryFee;
  final double discount;
  final String status; // Pending, Shipped, Delivered, Cancelled
  final String paymentMethod; // Cash on Delivery (COD)
  final String paymentStatus; // Pending (COD), Paid, Refunded / Cancelled
  final DateTime? createdAt;
  final double subtotal;
  final double totalAmount;
  final int totalItemCount;
  final String formattedItemsCount;
  final String formattedSubtotal;
  final String formattedTotal;
  final String formattedDeliveryFee;
  final String formattedDiscount;

  OrderModel({
    required this.id,
    required this.orderId,
    this.userId,
    required this.customer,
    required this.email,
    required this.phone,
    required this.address,
    required this.date,
    required this.items,
    this.deliveryFee = 0.0,
    this.discount = 0.0,
    required this.status,
    this.paymentMethod = "Cash on Delivery",
    this.paymentStatus = "Pending (COD)",
    this.createdAt,
  })  : subtotal = _calcSubtotal(items),
        totalAmount = _calcTotal(items, deliveryFee, discount),
        totalItemCount = _calcItemCount(items),
        formattedItemsCount =
            "${_calcItemCount(items)} ${_calcItemCount(items) == 1 ? 'Item' : 'Items'}",
        formattedSubtotal =
            "₹${_calcSubtotal(items).toStringAsFixed(_calcSubtotal(items) % 1 == 0 ? 0 : 2)}",
        formattedTotal =
            "₹${_calcTotal(items, deliveryFee, discount).toStringAsFixed(_calcTotal(items, deliveryFee, discount) % 1 == 0 ? 0 : 2)}",
        formattedDeliveryFee = deliveryFee == 0
            ? "₹0 (Free)"
            : "₹${deliveryFee.toStringAsFixed(deliveryFee % 1 == 0 ? 0 : 2)}",
        formattedDiscount = discount == 0
            ? "-₹0"
            : "-₹${discount.toStringAsFixed(discount % 1 == 0 ? 0 : 2)}";

  static double _calcSubtotal(List<OrderItemModel> list) {
    double sum = 0.0;
    for (var i in list) {
      sum += i.total;
    }
    return sum;
  }

  static double _calcTotal(List<OrderItemModel> list, double fee, double disc) {
    final t = _calcSubtotal(list) + fee - disc;
    return t > 0 ? t : 0.0;
  }

  static int _calcItemCount(List<OrderItemModel> list) {
    int count = 0;
    for (var i in list) {
      count += i.quantity;
    }
    return count;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      if (userId != null) 'userId': userId,
      'customer': customer,
      'email': email,
      'phone': phone,
      'address': address,
      'date': date,
      'items': items.map((i) => i.toMap()).toList(),
      'deliveryFee': deliveryFee,
      'discount': discount,
      'subtotal': subtotal,
      'amount': formattedTotal,
      'rawAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  static OrderModel fromMap(Map<String, dynamic> data, {String? id}) {
    DateTime? createdTime;
    final rawCreatedAt = data['createdAt'];
    if (rawCreatedAt is Timestamp) {
      createdTime = rawCreatedAt.toDate();
    } else if (rawCreatedAt is DateTime) {
      createdTime = rawCreatedAt;
    } else if (rawCreatedAt is String) {
      createdTime = DateTime.tryParse(rawCreatedAt);
    }

    final docId = id ?? data['id']?.toString() ?? '';
    final orderId = data['orderId']?.toString() ??
        '#DV${docId.length >= 4 ? docId.substring(0, 4).toUpperCase() : '1001'}';

    List<OrderItemModel> parsedItems = [];
    if (data['items'] is List) {
      parsedItems = (data['items'] as List)
          .map((i) => OrderItemModel.fromMap(Map<String, dynamic>.from(i as Map)))
          .toList();
    }

    final delivery = (data['deliveryFee'] is num)
        ? (data['deliveryFee'] as num).toDouble()
        : 0.0;
    final disc = (data['discount'] is num)
        ? (data['discount'] as num).toDouble()
        : 0.0;

    return OrderModel(
      id: docId,
      orderId: orderId,
      userId: data['userId']?.toString(),
      customer: data['customer']?.toString() ?? 'Customer',
      email: data['email']?.toString() ?? 'customer@example.com',
      phone: data['phone']?.toString() ?? '+91 98765 43210',
      address: data['address']?.toString() ?? 'Rajkot, Gujarat, India',
      date: data['date']?.toString() ?? '23 Aug 2026',
      items: parsedItems,
      deliveryFee: delivery,
      discount: disc,
      status: data['status']?.toString() ?? 'Pending',
      paymentMethod: data['paymentMethod']?.toString() ?? 'Cash on Delivery',
      paymentStatus: data['paymentStatus']?.toString() ??
          (data['status'] == 'Delivered' ? 'Paid' : 'Pending (COD)'),
      createdAt: createdTime ?? DateTime.now(),
    );
  }

  OrderModel copyWith({
    String? id,
    String? orderId,
    String? userId,
    String? customer,
    String? email,
    String? phone,
    String? address,
    String? date,
    List<OrderItemModel>? items,
    double? deliveryFee,
    double? discount,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      customer: customer ?? this.customer,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      date: date ?? this.date,
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
