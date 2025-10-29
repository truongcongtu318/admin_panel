import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Get all users as stream (realtime updates)
  Stream<List<UserModel>> getUsersStream() {
    return _firestore
        .collection(_usersCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    });
  }

  // Get all users as Future (one-time fetch)
  Future<List<UserModel>> getUsers() async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .get();
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String id) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(id).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Get user by email (for login)
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user by email: $e');
    }
  }

  // Check if email already exists
  Future<bool> emailExists(String email, {String? excludeUserId}) async {
    try {
      var query = _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: email);

      final snapshot = await query.get();
      
      if (excludeUserId != null) {
        // Exclude current user when editing
        return snapshot.docs.any((doc) => doc.id != excludeUserId);
      }
      
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Check if username already exists
  Future<bool> usernameExists(String username, {String? excludeUserId}) async {
    try {
      var query = _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username);

      final snapshot = await query.get();
      
      if (excludeUserId != null) {
        // Exclude current user when editing
        return snapshot.docs.any((doc) => doc.id != excludeUserId);
      }
      
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Create new user
  Future<String> createUser(UserModel user) async {
    try {
      // Check if email already exists
      final emailAlreadyExists = await emailExists(user.email);
      if (emailAlreadyExists) {
        throw Exception('Email đã tồn tại');
      }

      // Check if username already exists
      final usernameAlreadyExists = await usernameExists(user.username);
      if (usernameAlreadyExists) {
        throw Exception('Username đã tồn tại');
      }

      final docRef = await _firestore.collection(_usersCollection).add(user.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Update user
  Future<void> updateUser(String id, UserModel user) async {
    try {
      // Check if email already exists (excluding current user)
      final emailAlreadyExists = await emailExists(user.email, excludeUserId: id);
      if (emailAlreadyExists) {
        throw Exception('Email đã tồn tại');
      }

      // Check if username already exists (excluding current user)
      final usernameAlreadyExists = await usernameExists(user.username, excludeUserId: id);
      if (usernameAlreadyExists) {
        throw Exception('Username đã tồn tại');
      }

      await _firestore.collection(_usersCollection).doc(id).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection(_usersCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Search users by username or email
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      if (query.isEmpty) {
        return await getUsers();
      }

      final snapshot = await _firestore.collection(_usersCollection).get();
      final allUsers = snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();

      // Filter locally (Firestore doesn't support complex text search)
      final filteredUsers = allUsers.where((user) {
        final searchLower = query.toLowerCase();
        return user.username.toLowerCase().contains(searchLower) ||
            user.email.toLowerCase().contains(searchLower);
      }).toList();

      return filteredUsers;
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }
}

