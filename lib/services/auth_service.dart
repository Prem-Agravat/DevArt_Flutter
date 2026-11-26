import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:devart/services/address_service.dart';
import 'package:devart/services/cart_service.dart';
import 'package:devart/services/wishlist_service.dart';

class LocalUser {
  final String uid;
  String displayName;
  String name;
  String email;
  String phone;
  String role;
  bool isAdmin;

  LocalUser({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.phone,
    this.role = "user",
  })  : name = displayName,
        isAdmin = (role.toLowerCase().trim() == "admin");
}

class LocalUserCredential {
  final LocalUser user;
  LocalUserCredential({required this.user});
}

class LocalUserProfileSnapshot {
  final LocalUser? _user;
  final bool exists;

  LocalUserProfileSnapshot(this._user) : exists = (_user != null);

  Map<String, dynamic>? data() {
    if (_user == null) return null;
    return {
      "name": _user.displayName,
      "email": _user.email,
      "phone": _user.phone,
      "role": _user.role,
    };
  }
}

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  AuthService._internal();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  CollectionReference<Map<String, dynamic>> get _usersRef =>
      FirebaseFirestore.instance.collection('users');

  LocalUser currentUser = LocalUser(
    uid: "",
    displayName: "Guest",
    email: "",
    phone: "",
    role: "user",
  );

  String currentUserId = "";
  bool isLoggedIn = false;
  bool isAdmin = false;
  bool _initialized = false;
  bool _isRegistering = false;

  /// Call once in main() after Firebase.initializeApp().
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final user = _auth.currentUser;
    if (user != null) {
      await _syncUserFromFirebase(user);
    }

    _auth.authStateChanges().listen((user) async {
      if (_isRegistering) return;
      await _syncUserFromFirebase(user);
    });
  }

  Future<void> _syncUserFromFirebase(User? firebaseUser) async {
    if (firebaseUser == null) {
      currentUser = LocalUser(
        uid: "",
        displayName: "Guest",
        email: "",
        phone: "",
        role: "user",
      );
      currentUserId = "";
      isLoggedIn = false;
      isAdmin = false;
      notifyListeners();

      await Future.wait([
        CartService.instance.loadForUser(null),
        WishlistService.instance.loadForUser(null),
        AddressService.instance.loadForUser(null),
      ]);
      return;
    }

    await _loadOrCreateProfile(firebaseUser);
    notifyListeners();

    await Future.wait([
      CartService.instance.loadForUser(firebaseUser.uid),
      WishlistService.instance.loadForUser(firebaseUser.uid),
      AddressService.instance.loadForUser(firebaseUser.uid),
    ]);
  }

  Future<void> _loadOrCreateProfile(
    User firebaseUser, {
    String? fallbackName,
    String? fallbackPhone,
    String? fallbackRole,
  }) async {
    try {
      await firebaseUser.reload();
    } catch (_) {}
    final freshUser = _auth.currentUser ?? firebaseUser;

    final docRef = _usersRef.doc(freshUser.uid);
    final doc = await docRef.get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      final role = (data['role']?.toString().toLowerCase().trim() ?? 'user');
      final email =
          data['email']?.toString().trim() ?? freshUser.email ?? '';
      final emailPrefix = email.contains('@') ? email.split('@').first : '';
      String name = data['name']?.toString().trim() ?? '';
      final authDisplayName = freshUser.displayName?.trim() ?? '';

      if ((name.isEmpty ||
              name == email ||
              name.toLowerCase() == emailPrefix.toLowerCase()) &&
          authDisplayName.isNotEmpty &&
          authDisplayName != email &&
          authDisplayName.toLowerCase() != emailPrefix.toLowerCase()) {
        name = authDisplayName;
        await docRef.set({'name': name}, SetOptions(merge: true));
      } else if (name.isEmpty) {
        name = fallbackName?.trim().isNotEmpty == true
            ? fallbackName!.trim()
            : (authDisplayName.isNotEmpty
                ? authDisplayName
                : (emailPrefix.isNotEmpty ? emailPrefix : 'User'));
      }

      String phone = data['phone']?.toString().trim() ?? '';
      if (phone.isEmpty &&
          fallbackPhone != null &&
          fallbackPhone.trim().isNotEmpty) {
        phone = fallbackPhone.trim();
        await docRef.set({'phone': phone}, SetOptions(merge: true));
      } else if (phone.isEmpty) {
        try {
          final addrSnap = await docRef.collection('addresses').limit(1).get();
          if (addrSnap.docs.isNotEmpty) {
            final addrPhone =
                addrSnap.docs.first.data()['phone']?.toString().trim() ?? '';
            if (addrPhone.isNotEmpty) {
              phone = addrPhone;
              await docRef.set({'phone': phone}, SetOptions(merge: true));
            }
          }
        } catch (_) {}
      }

      currentUser = LocalUser(
        uid: freshUser.uid,
        displayName: name.isNotEmpty ? name : 'User',
        email: email,
        phone: phone,
        role: role,
      );
    } else {
      final email = (freshUser.email ?? '').trim().toLowerCase();
      final effectiveRole = fallbackRole ??
          (email.contains('admin') ? 'admin' : 'user');
      final name = (fallbackName != null && fallbackName.trim().isNotEmpty)
          ? fallbackName.trim()
          : (freshUser.displayName?.trim().isNotEmpty == true
              ? freshUser.displayName!.trim()
              : (email.isNotEmpty ? email.split('@').first : 'User'));
      final phone = fallbackPhone?.trim() ?? '';

      await docRef.set({
        'id': freshUser.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'orders': 0,
        'spent': '₹0',
        'role': effectiveRole,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      currentUser = LocalUser(
        uid: freshUser.uid,
        displayName: name,
        email: email,
        phone: phone,
        role: effectiveRole,
      );
    }

    currentUserId = currentUser.uid;
    isAdmin = currentUser.isAdmin;
    isLoggedIn = true;
  }

  Future<LocalUserCredential> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = "user",
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanName = name.trim().isEmpty ? "User" : name.trim();
    final cleanPhone = phone.trim();
    final effectiveRole =
        (cleanEmail.contains("admin") || role == "admin") ? "admin" : "user";

    _isRegistering = true;
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Failed to create Firebase user.',
        );
      }

      await firebaseUser.updateDisplayName(cleanName);
      await _usersRef.doc(firebaseUser.uid).set({
        'id': firebaseUser.uid,
        'name': cleanName,
        'email': cleanEmail,
        'phone': cleanPhone,
        'orders': 0,
        'spent': '₹0',
        'role': effectiveRole,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _loadOrCreateProfile(
        firebaseUser,
        fallbackName: cleanName,
        fallbackPhone: cleanPhone,
        fallbackRole: effectiveRole,
      );
      notifyListeners();

      await Future.wait([
        CartService.instance.loadForUser(firebaseUser.uid),
        WishlistService.instance.loadForUser(firebaseUser.uid),
        AddressService.instance.loadForUser(firebaseUser.uid),
      ]);

      return LocalUserCredential(user: currentUser);
    } finally {
      _isRegistering = false;
    }
  }

  Future<LocalUserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cred = await _auth.signInWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );

    final firebaseUser = cred.user;
    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User not found.',
      );
    }

    await _loadOrCreateProfile(firebaseUser);
    notifyListeners();

    await Future.wait([
      CartService.instance.loadForUser(firebaseUser.uid),
      WishlistService.instance.loadForUser(firebaseUser.uid),
      AddressService.instance.loadForUser(firebaseUser.uid),
    ]);

    return LocalUserCredential(user: currentUser);
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _syncUserFromFirebase(null);
  }

  Future<void> logoutUser() async {
    await logout();
  }

  Future<bool> isCurrentUserAdmin() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await _loadOrCreateProfile(firebaseUser);
    }
    return isAdmin;
  }

  Future<String> getCurrentUserRole() async {
    return currentUser.role;
  }

  Future<void> promoteUserToAdmin(String uid) async {
    await _usersRef.doc(uid).set({'role': 'admin'}, SetOptions(merge: true));
    if (currentUser.uid == uid) {
      currentUser.role = "admin";
      currentUser.isAdmin = true;
      isAdmin = true;
      notifyListeners();
    }
  }

  Future<void> demoteAdminToUser(String uid) async {
    await _usersRef.doc(uid).set({'role': 'user'}, SetOptions(merge: true));
    if (currentUser.uid == uid) {
      currentUser.role = "user";
      currentUser.isAdmin = false;
      isAdmin = false;
      notifyListeners();
    }
  }

  Future<LocalUserProfileSnapshot> getUserProfile() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await _loadOrCreateProfile(firebaseUser);
    }
    return LocalUserProfileSnapshot(isLoggedIn ? currentUser : null);
  }

  Future<void> updateUserProfile({
    required String name,
    required String phone,
  }) async {
    final cleanName = name.trim();
    final cleanPhone = phone.trim();
    final firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      await firebaseUser.updateDisplayName(cleanName);
      await _usersRef.doc(firebaseUser.uid).set({
        'id': firebaseUser.uid,
        'email': currentUser.email.isNotEmpty
            ? currentUser.email
            : (firebaseUser.email ?? ''),
        'role': currentUser.role,
        'name': cleanName,
        'phone': cleanPhone,
      }, SetOptions(merge: true));

      // Also sync updated name and phone onto this user's orders.
      try {
        final ordersSnap = await FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: firebaseUser.uid)
            .get();
        if (ordersSnap.docs.isNotEmpty) {
          final batch = FirebaseFirestore.instance.batch();
          for (final doc in ordersSnap.docs) {
            batch.update(doc.reference, {
              'customer': cleanName,
              if (cleanPhone.isNotEmpty) 'phone': cleanPhone,
            });
          }
          await batch.commit();
        }
      } catch (_) {}
    }

    currentUser.displayName = cleanName;
    currentUser.name = cleanName;
    currentUser.phone = cleanPhone;
    notifyListeners();
  }

  Future<bool> changePassword(
    String currentPassword, [
    String? newPassword,
  ]) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null || firebaseUser.email == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Please sign in again to change your password.',
      );
    }

    final cred = EmailAuthProvider.credential(
      email: firebaseUser.email!,
      password: currentPassword,
    );
    await firebaseUser.reauthenticateWithCredential(cred);

    if (newPassword != null && newPassword.trim().isNotEmpty) {
      await firebaseUser.updatePassword(newPassword.trim());
    }
    return true;
  }

  Future<void> updatePassword(String newPassword) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await firebaseUser.updatePassword(newPassword);
    }
  }

  Future<void> resetPassword(String email) async {
    await sendPasswordResetEmail(email);
  }

  static const String staticDemoOtp = "123456";

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
  }

  /// Static OTP flow (no email sent). Use [staticDemoOtp] ("123456").
  Future<bool> sendPasswordResetOtp(String email) async {
    return email.trim().isNotEmpty;
  }

  Future<String?> verifyPasswordResetOtp(String email, String otp) async {
    if (otp.trim() == staticDemoOtp) {
      return "static_otp_verified";
    }
    return null;
  }

  Future<bool> resetPasswordWithOtp(
    String email,
    String otp,
    String newPassword,
  ) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null &&
        firebaseUser.email?.toLowerCase() == email.trim().toLowerCase()) {
      await firebaseUser.updatePassword(newPassword.trim());
    }
    return true;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    return otp.trim() == staticDemoOtp;
  }
}
