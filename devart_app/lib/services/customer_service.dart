import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devart/models/customer_model.dart';

class CustomerService {
  final CollectionReference _customersRef =
      FirebaseFirestore.instance.collection('customers');
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  // ============================================================
  // STREAM REAL-TIME CUSTOMERS (Unified for Dashboard & Management)
  // ============================================================
  Stream<List<CustomerModel>> getCustomersStream({String? searchQuery}) {
    return _customersRef.snapshots().map((snapshot) {
      List<CustomerModel> customers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return CustomerModel.fromMap(data, id: doc.id);
      }).toList();

      // Sort by newest or name
      customers.sort((a, b) => a.name.compareTo(b.name));

      // Filter by search query
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        customers = customers.where((c) {
          return c.name.toLowerCase().contains(q) ||
              c.email.toLowerCase().contains(q) ||
              c.phone.toLowerCase().contains(q);
        }).toList();
      }

      return customers;
    });
  }

  // ============================================================
  // SEED INITIAL CUSTOMERS (If collection is empty)
  // ============================================================
  Future<void> seedInitialCustomersIfEmpty() async {
    try {
      final snapshot = await _customersRef.limit(1).get();
      if (snapshot.docs.isEmpty) {
        final initialCustomers = [
          CustomerModel(
            id: '',
            name: 'Dev Chauhan',
            email: 'devchauhan@gmail.com',
            phone: '+91 98765 43210',
            orders: 12,
            spent: '₹18,499',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          CustomerModel(
            id: '',
            name: 'Rahul Patel',
            email: 'rahulpatel@gmail.com',
            phone: '+91 98765 12345',
            orders: 8,
            spent: '₹12,799',
            createdAt: DateTime.now().subtract(const Duration(days: 25)),
          ),
          CustomerModel(
            id: '',
            name: 'Priya Shah',
            email: 'priyashah@gmail.com',
            phone: '+91 98765 67890',
            orders: 15,
            spent: '₹24,899',
            createdAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
          CustomerModel(
            id: '',
            name: 'Amit Joshi',
            email: 'amitjoshi@gmail.com',
            phone: '+91 98765 24680',
            orders: 3,
            spent: '₹4,299',
            createdAt: DateTime.now().subtract(const Duration(days: 15)),
          ),
          CustomerModel(
            id: '',
            name: 'Neha Mehta',
            email: 'nehamehta@gmail.com',
            phone: '+91 98765 13579',
            orders: 21,
            spent: '₹31,599',
            createdAt: DateTime.now().subtract(const Duration(days: 10)),
          ),
        ];

        for (final c in initialCustomers) {
          await _customersRef.add(c.toMap());
        }
      }

      // Also sync registered non-admin users from 'users' collection
      final userSnapshot = await _usersRef.get();
      for (final userDoc in userSnapshot.docs) {
        final data = userDoc.data() as Map<String, dynamic>? ?? {};
        final role = data['role']?.toString().toLowerCase().trim() ?? 'user';
        if (role == 'admin') continue;

        final email = data['email']?.toString().trim() ?? '';
        if (email.isEmpty) continue;

        // Check if customer with this email already exists in customers
        final existing = await _customersRef
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (existing.docs.isEmpty) {
          await _customersRef.doc(userDoc.id).set({
            'name': data['name']?.toString() ?? 'Customer',
            'email': email,
            'phone': data['phone']?.toString() ?? 'N/A',
            'orders': 1,
            'spent': '₹899',
            'createdAt': data['createdAt'] ?? FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (_) {
      // Ignored for offline/permission fallback
    }
  }
}
