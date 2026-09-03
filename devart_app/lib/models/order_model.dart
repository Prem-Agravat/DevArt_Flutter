import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String orderId;
  final String customer;
  final String email;
  final String phone;
  final String address;
  final String date;
  final String items;
  final String amount;
  final double rawAmount;
  final String status; // Pending, Shipped, Delivered, Cancelled
  final String paymentMethod; // Cash on Delivery (COD)
  final String paymentStatus; // Pending, Paid, Refunded
  final DateTime? createdAt;

  OrderModel({
    required this.id,
    required this.orderId,
    required this.customer,
    required this.email,
    required this.phone,
    required this.address,
    required this.date,
    required this.items,
    required this.amount,
    required this.rawAmount,
    required this.status,
    this.paymentMethod = "Cash on Delivery",
    this.paymentStatus = "Pending (COD)",
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customer': customer,
      'email': email,
      'phone': phone,
      'address': address,
      'date': date,
      'items': items,
      'amount': amount,
      'rawAmount': rawAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime? createdTime;
    if (data['createdAt'] is Timestamp) {
      createdTime = (data['createdAt'] as Timestamp).toDate();
    }

    return OrderModel(
      id: doc.id,
      orderId: data['orderId']?.toString() ?? '#DV${doc.id.substring(0, 4).toUpperCase()}',
      customer: data['customer']?.toString() ?? 'Customer',
      email: data['email']?.toString() ?? 'customer@example.com',
      phone: data['phone']?.toString() ?? '+91 98765 43210',
      address: data['address']?.toString() ?? 'Rajkot, Gujarat, India',
      date: data['date']?.toString() ?? '23 Aug 2026',
      items: data['items']?.toString() ?? '1 Item',
      amount: data['amount']?.toString() ?? '₹0',
      rawAmount: (data['rawAmount'] is num)
          ? (data['rawAmount'] as num).toDouble()
          : double.tryParse(data['rawAmount']?.toString() ?? '0') ?? 0.0,
      status: data['status']?.toString() ?? 'Pending',
      paymentMethod: data['paymentMethod']?.toString() ?? 'Cash on Delivery',
      paymentStatus: data['paymentStatus']?.toString() ??
          (data['status'] == 'Delivered' ? 'Paid' : 'Pending (COD)'),
      createdAt: createdTime,
    );
  }

  OrderModel copyWith({
    String? id,
    String? orderId,
    String? customer,
    String? email,
    String? phone,
    String? address,
    String? date,
    String? items,
    String? amount,
    double? rawAmount,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      customer: customer ?? this.customer,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      date: date ?? this.date,
      items: items ?? this.items,
      amount: amount ?? this.amount,
      rawAmount: rawAmount ?? this.rawAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
