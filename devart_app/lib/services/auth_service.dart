import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  // REGISTER USER
  // ============================================================

  Future<UserCredential> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = "user",
  }) async {
    // 1. Create account in Firebase Authentication
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

    final User? user = credential.user;

    if (user == null) {
      throw Exception("User creation failed.");
    }

    // 2. Store user's name in Firebase Authentication profile
    await user.updateDisplayName(name.trim());

    // 3. Store user's profile and role in Firestore
    await _firestore.collection("users").doc(user.uid).set({
      "name": name.trim(),
      "email": email.trim(),
      "phone": phone.trim(),
      "role": role,
      "createdAt": FieldValue.serverTimestamp(),
    });

    return credential;
  }

  // ============================================================
  // LOGIN USER
  // ============================================================

  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    return credential;
  }

  // ============================================================
  // LOGOUT USER
  // ============================================================

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ============================================================
  // GET CURRENT USER & UID
  // ============================================================

  User? get currentUser {
    return _auth.currentUser;
  }

  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  // ============================================================
  // ROLE & ADMIN CHECKS (Pure Firestore Database)
  // ============================================================

  /// Returns true if the currently logged-in user has role == 'admin' in Firestore
  Future<bool> isCurrentUserAdmin() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final doc = await _firestore.collection("users").doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        final role = data?['role']?.toString().toLowerCase().trim();
        return role == "admin";
      }
    } catch (e) {
      // In case of network/permission issues
    }

    return false;
  }

  /// Gets the role of the currently logged-in user ('admin', 'user', etc.)
  Future<String> getCurrentUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return "guest";

    try {
      final doc = await _firestore.collection("users").doc(user.uid).get();
      if (doc.exists) {
        return doc.data()?['role']?.toString() ?? "user";
      }
    } catch (e) {
      // Fallback
    }

    return "user";
  }

  /// Promotes a user to admin in Firestore
  Future<void> promoteUserToAdmin(String uid) async {
    await _firestore.collection("users").doc(uid).update({
      "role": "admin",
    });
  }

  /// Demotes an admin back to regular user in Firestore
  Future<void> demoteAdminToUser(String uid) async {
    await _firestore.collection("users").doc(uid).update({
      "role": "user",
    });
  }

  // ============================================================
  // GET USER PROFILE FROM FIRESTORE
  // ============================================================

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("No logged-in user.");
    }

    return await _firestore.collection("users").doc(user.uid).get();
  }

  // ============================================================
  // UPDATE USER PROFILE
  // ============================================================

  Future<void> updateUserProfile({
    required String name,
    required String phone,
  }) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("No logged-in user.");
    }

    // Update name in Firebase Authentication
    await user.updateDisplayName(name.trim());

    // Update profile in Firestore
    await _firestore.collection("users").doc(user.uid).update({
      "name": name.trim(),
      "phone": phone.trim(),
    });
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ============================================================
  // CHECK IF USER IS LOGGED IN
  // ============================================================

  bool get isLoggedIn {
    return _auth.currentUser != null;
  }
}
