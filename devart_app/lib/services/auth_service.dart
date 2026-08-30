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
  }) async {
    // 1. Create account in Firebase Authentication
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

    // Get the newly created Firebase user
    final User? user = credential.user;

    if (user == null) {
      throw Exception("User creation failed.");
    }

    // 2. Store user's name in Firebase Authentication
    await user.updateDisplayName(name.trim());

    // 3. Store user's additional information in Firestore
    await _firestore.collection("users").doc(user.uid).set({
      "name": name.trim(),
      "email": email.trim(),
      "phone": phone.trim(),
      "role": "user",
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
  // GET CURRENT USER
  // ============================================================

  User? get currentUser {
    return _auth.currentUser;
  }

  // ============================================================
  // GET CURRENT USER UID
  // ============================================================

  String? get currentUserId {
    return _auth.currentUser?.uid;
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
