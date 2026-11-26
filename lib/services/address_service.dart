import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AddressModel {
  final String id;
  final String type;
  final String name;
  final String phone;
  final String address;

  AddressModel({
    required this.id,
    required this.type,
    required this.name,
    required this.phone,
    required this.address,
  });

  Map<String, String> toMap() {
    return {
      "id": id,
      "type": type,
      "name": name,
      "phone": phone,
      "address": address,
    };
  }

  static AddressModel fromMap(Map<String, dynamic> map, {String? id}) {
    return AddressModel(
      id: id ?? map['id']?.toString() ?? '',
      type: map['type']?.toString() ?? 'Home',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
    );
  }

  String? operator [](String key) {
    switch (key) {
      case "id":
        return id;
      case "type":
        return type;
      case "name":
        return name;
      case "phone":
        return phone;
      case "address":
        return address;
      default:
        return null;
    }
  }
}

class AddressService extends ChangeNotifier {
  static final AddressService instance = AddressService._internal();
  factory AddressService() => instance;
  AddressService._internal();

  String? _uid;
  List<AddressModel> addresses = [];
  int selectedIndex = 0;

  String? get _effectiveUid {
    if (_uid != null && _uid!.isNotEmpty) return _uid;
    final authUid = FirebaseAuth.instance.currentUser?.uid;
    return (authUid != null && authUid.isNotEmpty) ? authUid : null;
  }

  CollectionReference<Map<String, dynamic>>? get _addressesRef {
    final uid = _effectiveUid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses');
  }

  Future<void> loadForUser(String? uid) async {
    _uid = uid;
    addresses.clear();
    selectedIndex = 0;

    if (uid == null || uid.isEmpty) {
      notifyListeners();
      return;
    }

    try {
      final snap = await _addressesRef!.get();
      addresses = snap.docs
          .map((doc) => AddressModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (_) {}

    notifyListeners();
  }

  void selectAddress(int index) {
    if (index >= 0 && index < addresses.length) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  Future<void> addAddress(
    dynamic data, {
    String? type,
    String? name,
    String? phone,
    String? address,
  }) async {
    final docId = 'addr_${DateTime.now().millisecondsSinceEpoch}';
    final AddressModel newAddress;

    if (data is Map) {
      newAddress = AddressModel(
        id: docId,
        type: data['type']?.toString() ?? type ?? 'Home',
        name: data['name']?.toString() ?? name ?? '',
        phone: data['phone']?.toString() ?? phone ?? '',
        address: data['address']?.toString() ?? address ?? '',
      );
    } else {
      newAddress = AddressModel(
        id: docId,
        type: type ?? 'Home',
        name: name ?? '',
        phone: phone ?? '',
        address: address ?? (data is String ? data : ''),
      );
    }

    addresses.add(newAddress);
    selectedIndex = addresses.length - 1;
    notifyListeners();

    final ref = _addressesRef;
    if (ref != null) {
      await ref.doc(newAddress.id).set(newAddress.toMap());
    }
  }

  Future<void> removeAddress(int index) async {
    if (index >= 0 && index < addresses.length) {
      final removed = addresses.removeAt(index);
      if (selectedIndex >= addresses.length) {
        selectedIndex = addresses.isEmpty ? 0 : addresses.length - 1;
      }
      notifyListeners();

      final ref = _addressesRef;
      if (ref != null) {
        await ref.doc(removed.id).delete();
      }
    }
  }
}
