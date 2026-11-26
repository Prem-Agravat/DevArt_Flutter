import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devart/data/local_data.dart';
import 'package:devart/models/customer_model.dart';

class CustomerService {
  static final CustomerService instance = CustomerService._internal();
  factory CustomerService() => instance;
  CustomerService._internal();

  final CollectionReference<Map<String, dynamic>> _usersRef =
      FirebaseFirestore.instance.collection('users');

  bool _seeded = false;

  Stream<List<CustomerModel>> getCustomersStream({String? searchQuery}) {
    return _usersRef.snapshots().map((snapshot) {
      List<CustomerModel> filtered = snapshot.docs
          .map((doc) => CustomerModel.fromMap(doc.data(), id: doc.id))
          .toList()
        ..sort((a, b) => (b.createdAt ?? DateTime(2000))
            .compareTo(a.createdAt ?? DateTime(2000)));

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        filtered = filtered.where((c) {
          return c.name.toLowerCase().contains(q) ||
              c.email.toLowerCase().contains(q) ||
              c.phone.toLowerCase().contains(q);
        }).toList();
      }

      return filtered;
    });
  }

  Future<void> updateCustomerRole(String customerId, String newRole) async {
    await _usersRef
        .doc(customerId)
        .set({'role': newRole}, SetOptions(merge: true));
  }

  Future<void> seedInitialCustomersIfEmpty() async {
    if (_seeded) return;
    _seeded = true;

    try {
      final existing = await _usersRef.limit(1).get();
      if (existing.docs.isEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        for (final customer in LocalData.getInitialCustomers()) {
          final docRef = _usersRef.doc(customer.id);
          batch.set(docRef, customer.toMap());
        }
        await batch.commit();
      }
    } catch (_) {
      _seeded = false;
    }
  }
}
