import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream untuk mendengarkan perubahan status autentikasi
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Mendapatkan user yang sedang login
  User? get currentUser => _firebaseAuth.currentUser;

  // Login
  Future<String?> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null; // Tidak ada error
    } on FirebaseAuthException catch (e) {
      return e.message; // Pesan error
    }
  }

  // Registrasi
  Future<String?> register(String nama, String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null; // Tidak ada error
    } on FirebaseAuthException catch (e) {
      return e.message; // Pesan error
    }
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
