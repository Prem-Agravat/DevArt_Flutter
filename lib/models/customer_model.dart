import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int orders;
  final String spent;
  final String role;
  final DateTime? createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.orders,
    required this.spent,
    this.role = "user",
    this.createdAt,
  });

  static CustomerModel fromMap(Map<String, dynamic> map, {String id = ''}) {
    DateTime? createdTime;
    final rawCreatedAt = map['createdAt'];
    if (rawCreatedAt is Timestamp) {
      createdTime = rawCreatedAt.toDate();
    } else if (rawCreatedAt is DateTime) {
      createdTime = rawCreatedAt;
    } else if (rawCreatedAt is String) {
      createdTime = DateTime.tryParse(rawCreatedAt);
    }

    final rawName = map['name']?.toString().trim() ?? '';
    final rawEmail = map['email']?.toString().trim() ?? '';
    final rawPhone = map['phone']?.toString().trim() ?? '';
    final rawSpent = map['spent']?.toString().trim() ?? '';

    return CustomerModel(
      id: id.isNotEmpty ? id : (map['id']?.toString() ?? ''),
      name: rawName.isNotEmpty
          ? rawName
          : (rawEmail.isNotEmpty ? rawEmail.split('@').first : 'Customer'),
      email: rawEmail,
      phone: rawPhone.isNotEmpty ? rawPhone : 'N/A',
      orders: (map['orders'] is num)
          ? (map['orders'] as num).toInt()
          : int.tryParse(map['orders']?.toString() ?? '0') ?? 0,
      spent: rawSpent.isNotEmpty ? rawSpent : '₹0',
      role: map['role']?.toString().toLowerCase().trim() ?? 'user',
      createdAt: createdTime ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'orders': orders,
      'spent': spent,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  CustomerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    int? orders,
    String? spent,
    String? role,
    DateTime? createdAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      orders: orders ?? this.orders,
      spent: spent ?? this.spent,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
