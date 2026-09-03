import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devart/models/order_model.dart';

class OrderService {
  final CollectionReference _ordersRef =
      FirebaseFirestore.instance.collection('orders');

  // ============================================================
  // STREAM REAL-TIME ORDERS
  // ============================================================
  Stream<List<OrderModel>> getOrdersStream({
    String? status,
    String? searchQuery,
  }) {
    return _ordersRef.snapshots().map((snapshot) {
      List<OrderModel> orders =
          snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();

      // Sort by newest created first
      orders.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      // Filter by Status (Pending, Shipped, Delivered, Cancelled)
      if (status != null && status != "All" && status.trim().isNotEmpty) {
        final st = status.trim().toLowerCase();
        orders = orders.where((o) => o.status.trim().toLowerCase() == st).toList();
      }

      // Filter by Search Query (ID or Customer)
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        orders = orders.where((o) {
          return o.orderId.toLowerCase().contains(q) ||
              o.customer.toLowerCase().contains(q) ||
              o.phone.toLowerCase().contains(q);
        }).toList();
      }

      return orders;
    });
  }

  // ============================================================
  // UPDATE ORDER STATUS IN FIRESTORE
  // ============================================================
  Future<void> updateOrderStatus(String docId, String newStatus) async {
    String paymentStatus = "Pending (COD)";
    if (newStatus == "Delivered") {
      paymentStatus = "Paid";
    } else if (newStatus == "Cancelled") {
      paymentStatus = "Refunded / Cancelled";
    }

    await _ordersRef.doc(docId).update({
      'status': newStatus,
      'paymentStatus': paymentStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // CREATE ORDER (COD)
  // ============================================================
  Future<String> createOrder(OrderModel order) async {
    final docRef = await _ordersRef.add(order.toMap());
    return docRef.id;
  }

  // ============================================================
  // DELETE ORDER
  // ============================================================
  Future<void> deleteOrder(String docId) async {
    await _ordersRef.doc(docId).delete();
  }

  // ============================================================
  // SEED INITIAL ORDERS (Runs only if Firestore is empty)
  // ============================================================
  Future<void> seedInitialOrdersIfEmpty() async {
    try {
      final snapshot = await _ordersRef.limit(1).get();
      if (snapshot.docs.isEmpty) {
        final initialOrders = [
          OrderModel(
            id: '',
            orderId: '#DV1001',
            customer: 'Rahul Patel',
            email: 'rahulpatel@gmail.com',
            phone: '+91 98765 12345',
            address: '402, Shivam Heights, Kalawad Road, Rajkot - 360005',
            date: '23 Aug 2026',
            items: '3 Items',
            amount: '₹2,499',
            rawAmount: 2499.0,
            status: 'Pending',
            paymentMethod: 'Cash on Delivery (COD)',
            paymentStatus: 'Pending (COD)',
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          OrderModel(
            id: '',
            orderId: '#DV1002',
            customer: 'Priya Shah',
            email: 'priyashah@gmail.com',
            phone: '+91 98765 67890',
            address: '12, Shanti Niketan Society, University Road, Rajkot - 360005',
            date: '22 Aug 2026',
            items: '2 Items',
            amount: '₹1,899',
            rawAmount: 1899.0,
            status: 'Pending',
            paymentMethod: 'Cash on Delivery (COD)',
            paymentStatus: 'Pending (COD)',
            createdAt: DateTime.now().subtract(const Duration(hours: 8)),
          ),
          OrderModel(
            id: '',
            orderId: '#DV1003',
            customer: 'Amit Joshi',
            email: 'amitjoshi@gmail.com',
            phone: '+91 98765 24680',
            address: 'B-304, Royal Palms, 150 Feet Ring Road, Rajkot - 360004',
            date: '22 Aug 2026',
            items: '4 Items',
            amount: '₹3,799',
            rawAmount: 3799.0,
            status: 'Shipped',
            paymentMethod: 'Cash on Delivery (COD)',
            paymentStatus: 'Pending (COD)',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          OrderModel(
            id: '',
            orderId: '#DV1004',
            customer: 'Neha Mehta',
            email: 'nehamehta@gmail.com',
            phone: '+91 98765 13579',
            address: '78, Golden Park, Amin Marg, Rajkot - 360001',
            date: '21 Aug 2026',
            items: '1 Item',
            amount: '₹899',
            rawAmount: 899.0,
            status: 'Delivered',
            paymentMethod: 'Cash on Delivery (COD)',
            paymentStatus: 'Paid',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          OrderModel(
            id: '',
            orderId: '#DV1005',
            customer: 'Dev Chauhan',
            email: 'devchauhan@gmail.com',
            phone: '+91 98765 43210',
            address: '501, Silver Crest, Nana Mava Road, Rajkot - 360005',
            date: '20 Aug 2026',
            items: '5 Items',
            amount: '₹4,299',
            rawAmount: 4299.0,
            status: 'Cancelled',
            paymentMethod: 'Cash on Delivery (COD)',
            paymentStatus: 'Refunded / Cancelled',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ];

        for (final o in initialOrders) {
          await _ordersRef.add(o.toMap());
        }
      }
    } catch (_) {
      // Ignored for offline / permission fallback
    }
  }
}
