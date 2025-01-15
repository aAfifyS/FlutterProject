import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get the current user
  User? get currentUser => _auth.currentUser;

  /// Login user with email and password
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  /// Register user with email and password, and save additional info in Firestore
  Future<User?> registerWithEmailPassword({
    required String name,
    required String email,
    required String phone,
    required String ic,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'ic': ic,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  /// Reset password by email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Password reset failed: $e");
    }
  }
}
