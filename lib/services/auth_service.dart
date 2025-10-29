import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _currentUser;

  // HARDCODED ADMIN ACCOUNT (Riêng biệt, không lưu trong database)
  static const String adminEmail = 'admin@gmail.com';
  static const String adminPassword = 'admin123';
  static const String adminUsername = 'Administrator';

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Hash password using SHA256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Login with email and password
  Future<UserModel?> login(String email, String password) async {
    try {
      // CHECK ADMIN ACCOUNT FIRST (Hardcoded)
      if (email.toLowerCase() == adminEmail.toLowerCase() &&
          password == adminPassword) {
        // Create admin user object (không lưu trong DB)
        _currentUser = UserModel(
          id: 'admin',
          username: adminUsername,
          email: adminEmail,
          password: hashPassword(adminPassword),
          imageUrl: null,
        );
        return _currentUser;
      }

      // If not admin, check database users (for future use)
      final user = await _firestoreService.getUserByEmail(email);

      if (user == null) {
        throw Exception('Email hoặc password không đúng');
      }

      // Hash the input password and compare
      final hashedPassword = hashPassword(password);
      if (user.password != hashedPassword) {
        throw Exception('Email hoặc password không đúng');
      }

      // Save current user
      _currentUser = user;
      return user;
    } catch (e) {
      if (e.toString().contains('Email hoặc password không đúng')) {
        rethrow;
      }
      throw Exception('Email hoặc password không đúng');
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
  }

  // Check if user is logged in
  bool checkAuth() {
    return _currentUser != null;
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _currentUser?.id;
  }

  // Check if current user is admin
  bool isAdmin() {
    return _currentUser?.id == 'admin';
  }
}
