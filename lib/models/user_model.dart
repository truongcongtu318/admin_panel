import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String username;
  final String email;
  final String password; // Hashed password (SHA256)
  final String? imageUrl;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.imageUrl,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
    };
  }

  // Create UserModel from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  // Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  // CopyWith method for updating
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? imageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, email: $email, imageUrl: $imageUrl}';
  }
}
