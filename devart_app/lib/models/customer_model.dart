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

  factory CustomerModel.fromMap(Map<String, dynamic> map, {String id = ''}) {
    return CustomerModel(
      id: id.isNotEmpty ? id : (map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? 'Customer',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? 'N/A',
      orders: (map['orders'] is num)
          ? (map['orders'] as num).toInt()
          : int.tryParse(map['orders']?.toString() ?? '0') ?? 0,
      spent: map['spent']?.toString() ?? '₹0',
      role: map['role']?.toString().toLowerCase().trim() ?? 'user',
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'orders': orders,
      'spent': spent,
      'role': role,
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
