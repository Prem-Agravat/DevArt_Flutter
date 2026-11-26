import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devart/data/local_data.dart';
import 'package:devart/models/order_model.dart';

class OrderService {
  static final OrderService instance = OrderService._internal();
  factory OrderService() => instance;
  OrderService._internal();

  final CollectionReference<Map<String, dynamic>> _ordersRef =
      FirebaseFirestore.instance.collection('orders');

  bool _seeded = false;

  Stream<List<OrderModel>> getOrdersStream({
    String? status,
    String? searchQuery,
    String? userId,
    String? userEmail,
  }) {
    return _ordersRef.snapshots().map((snapshot) {
      List<OrderModel> filtered = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), id: doc.id))
          .toList()
        ..sort((a, b) => (b.createdAt ?? DateTime(2000))
            .compareTo(a.createdAt ?? DateTime(2000)));

      if (userId != null && userId.trim().isNotEmpty) {
        final cleanEmail = userEmail?.trim().toLowerCase() ?? '';
        filtered = filtered.where((o) {
          if (o.userId != null && o.userId!.isNotEmpty) {
            return o.userId == userId;
          }
          return cleanEmail.isNotEmpty &&
              o.email.trim().toLowerCase() == cleanEmail;
        }).toList();
      }

      if (status != null && status != "All" && status.trim().isNotEmpty) {
        final st = status.trim().toLowerCase();
        filtered = filtered
            .where((o) => o.status.trim().toLowerCase() == st)
            .toList();
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        filtered = filtered.where((o) {
          return o.orderId.toLowerCase().contains(q) ||
              o.customer.toLowerCase().contains(q) ||
              o.phone.toLowerCase().contains(q);
        }).toList();
      }

      return filtered;
    });
  }

  Future<void> updateOrderStatus(String docId, String newStatus) async {
    String paymentStatus = "Pending (COD)";
    if (newStatus == "Delivered") {
      paymentStatus = "Paid";
    } else if (newStatus == "Cancelled") {
      paymentStatus = "Refunded / Cancelled";
    }

    await _ordersRef.doc(docId).set({
      'status': newStatus,
      'paymentStatus': paymentStatus,
    }, SetOptions(merge: true));
  }

  Future<String> createOrder(OrderModel order) async {
    final docRef =
        order.id.isNotEmpty ? _ordersRef.doc(order.id) : _ordersRef.doc();

    final newOrder = order.copyWith(
      id: docRef.id,
      createdAt: order.createdAt ?? DateTime.now(),
    );

    final db = FirebaseFirestore.instance;
    await docRef.set(newOrder.toMap());

    // Update customer's order count and total spent if linked to an authenticated user.
    if (newOrder.userId != null && newOrder.userId!.isNotEmpty) {
      final userRef = db.collection('users').doc(newOrder.userId);
      try {
        await db.runTransaction((tx) async {
          final userSnap = await tx.get(userRef);
          final data = userSnap.data() ?? {};
          final currentOrders = (data['orders'] is num)
              ? (data['orders'] as num).toInt()
              : int.tryParse(data['orders']?.toString() ?? '0') ?? 0;
          final currentSpentRaw = data['spent']?.toString() ?? '0';
          final currentSpent = double.tryParse(
                currentSpentRaw.replaceAll(RegExp(r'[^0-9.]'), ''),
              ) ??
              0.0;
          final updatedSpent = currentSpent + newOrder.totalAmount;
          final formattedSpent =
              "₹${updatedSpent.toStringAsFixed(updatedSpent % 1 == 0 ? 0 : 2)}";

          final existingName = data['name']?.toString().trim() ?? '';
          final existingEmail = data['email']?.toString().trim() ?? '';
          final emailPrefix = existingEmail.contains('@')
              ? existingEmail.split('@').first
              : '';
          final existingPhone = data['phone']?.toString().trim() ?? '';

          final updates = <String, dynamic>{
            'orders': currentOrders + 1,
            'spent': formattedSpent,
          };
          if ((existingName.isEmpty ||
                  existingName.toLowerCase() == emailPrefix.toLowerCase()) &&
              newOrder.customer.trim().isNotEmpty &&
              newOrder.customer.trim() != 'Customer' &&
              !newOrder.customer.contains('@')) {
            updates['name'] = newOrder.customer.trim();
          }
          if (existingPhone.isEmpty && newOrder.phone.trim().isNotEmpty) {
            updates['phone'] = newOrder.phone.trim();
          }

          tx.set(
            userRef,
            updates,
            SetOptions(merge: true),
          );
        });
      } catch (_) {}
    }

    // Best-effort stock decrement for ordered items that carry productId.
    for (final item in newOrder.items) {
      if (item.productId != null && item.productId!.isNotEmpty) {
        final prodRef = db.collection('products').doc(item.productId);
        try {
          await db.runTransaction((tx) async {
            final snap = await tx.get(prodRef);
            if (!snap.exists) return;
            final currentStock = (snap.data()?['stock'] as num?)?.toInt() ?? 0;
            final updatedStock =
                (currentStock - item.quantity).clamp(0, currentStock);
            tx.update(prodRef, {'stock': updatedStock});
          });
        } catch (_) {}
      }
    }

    return docRef.id;
  }

  Future<void> deleteOrder(String docId) async {
    await _ordersRef.doc(docId).delete();
  }

  Future<void> seedInitialOrdersIfEmpty() async {
    if (_seeded) return;
    _seeded = true;

    try {
      final existing = await _ordersRef.limit(1).get();
      if (existing.docs.isEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        for (final order in LocalData.getInitialOrders()) {
          final docRef = _ordersRef.doc(order.id);
          batch.set(docRef, order.toMap());
        }
        await batch.commit();
      }
    } catch (_) {
      _seeded = false;
    }
  }
}
