import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image to Firebase Storage
  Future<String> uploadImage(File imageFile, String userId) async {
    try {
      // Tạo tên file unique với timestamp để tránh trùng lặp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String fileName = 'profile_${userId}_$timestamp.jpg';
      final String filePath = '$userId/$fileName';

      // Reference to Firebase Storage path
      final Reference ref = _storage.ref().child(filePath);

      // Upload file to Firebase Storage
      final UploadTask uploadTask = ref.putFile(imageFile);

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Delete image from Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty) return;

      // Extract file path from Firebase Storage URL
      // Firebase Storage URL format: https://firebasestorage.googleapis.com/v0/b/{bucket}/o/{path}?alt=media
      final uri = Uri.parse(imageUrl);
      final pathSegment = uri.pathSegments;

      // Find 'o' segment which contains the encoded path
      final indexOfO = pathSegment.indexOf('o');
      if (indexOfO == -1 || indexOfO >= pathSegment.length - 1) {
        return;
      }

      // Decode the path (URL encoded)
      final encodedPath = pathSegment[indexOfO + 1];
      final decodedPath = Uri.decodeComponent(encodedPath);

      // Get reference and delete
      final Reference ref = _storage.ref().child(decodedPath);
      await ref.delete();
    } catch (e) {
      // Ignore error if file doesn't exist
    }
  }

  // Update image (delete old, upload new)
  Future<String> updateImage(
    File newImageFile,
    String userId,
    String? oldImageUrl,
  ) async {
    try {
      // Delete old image if exists
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        await deleteImage(oldImageUrl);
      }

      // Upload new image with unique timestamp
      return await uploadImage(newImageFile, userId);
    } catch (e) {
      throw Exception('Failed to update image: $e');
    }
  }

  // Check if Firebase Storage is accessible
  Future<bool> checkStorageAccessible() async {
    try {
      // Try to list root directory to check if storage is accessible
      await _storage.ref().listAll();
      return true;
    } catch (e) {
      return false;
    }
  }
}
