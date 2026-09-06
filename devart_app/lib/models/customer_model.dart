class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int orders;
  final String spent;
  final DateTime? createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.orders,
    required this.spent,
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
    };
  }
}
