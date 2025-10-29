import 'dart:io';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../widgets/confirm_dialog.dart';
import 'auth_controller.dart';

class UserController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  final AuthController _authController = Get.find<AuthController>();

  // Reactive state
  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't auto load here, let the screen decide when to load
  }

  @override
  void onReady() {
    super.onReady();
    // Gọi sau khi widget đã render xong
    ever(allUsers, (_) {
      // Tự động update filteredUsers khi allUsers thay đổi
      if (searchQuery.value.isEmpty) {
        filteredUsers.value = allUsers;
      }
    });
  }

  // Load users from Firestore
  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      final users = await _firestoreService.getUsers();
      allUsers.value = users;
      filteredUsers.value = users;
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách users: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search users
  void searchUsers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value = allUsers.where((user) {
        final searchLower = query.toLowerCase();
        return user.username.toLowerCase().contains(searchLower) ||
            user.email.toLowerCase().contains(searchLower);
      }).toList();
    }
  }

  // Create user
  Future<bool> createUser({
    required String username,
    required String email,
    required String password,
    File? image,
  }) async {
    try {
      isLoading.value = true;

      String? imageUrl;

      // Upload image if provided
      if (image != null) {
        final tempId = DateTime.now().millisecondsSinceEpoch.toString();
        imageUrl = await _storageService.uploadImage(image, tempId);
      }

      // Create user
      final user = UserModel(
        username: username,
        email: email,
        password: _authController.hashPassword(password),
        imageUrl: imageUrl,
      );

      final userId = await _firestoreService.createUser(user);

      // Update image URL with real user ID if image was uploaded
      if (image != null && imageUrl != null) {
        final newImageUrl = await _storageService.updateImage(
          image,
          userId,
          imageUrl,
        );
        await _firestoreService.updateUser(
          userId,
          user.copyWith(imageUrl: newImageUrl),
        );
      }

      // Reload để update UI
      await loadUsers();

      // Không show snackbar ở đây nữa, sẽ show ở screen
      return true;
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update user
  Future<bool> updateUser({
    required String userId,
    required String username,
    required String email,
    String? password,
    File? newImage,
    String? currentImageUrl,
  }) async {
    try {
      isLoading.value = true;

      // Get current user first to get old image URL
      final currentUser = await _firestoreService.getUserById(userId);
      if (currentUser == null) {
        throw Exception('User không tồn tại');
      }

      String? imageUrl = currentImageUrl;

      // Handle image update
      if (newImage != null) {
        // User selected a new image
        imageUrl = await _storageService.updateImage(
          newImage,
          userId,
          currentUser.imageUrl, // Use old image from DB
        );
      } else if (currentImageUrl == null && currentUser.imageUrl != null) {
        // User removed the image
        await _storageService.deleteImage(currentUser.imageUrl!);
        imageUrl = null;
      }

      final user = UserModel(
        id: userId,
        username: username,
        email: email,
        password: password != null && password.isNotEmpty
            ? _authController.hashPassword(password)
            : currentUser.password,
        imageUrl: imageUrl,
      );

      await _firestoreService.updateUser(userId, user);

      // Reload để update UI
      await loadUsers();

      // Không show snackbar ở đây nữa, sẽ show ở screen
      return true;
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete user
  Future<bool> deleteUser(UserModel user) async {
    // Show custom confirmation dialog
    final confirmed = await ConfirmDialog.showDelete(
      context: Get.context!,
      itemName: user.username,
      customMessage: 'Hành động này không thể hoàn tác!',
    );

    if (!confirmed) return false;

    try {
      isLoading.value = true;

      // Delete image from Firebase Storage if exists
      if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
        await _storageService.deleteImage(user.imageUrl!);
      }

      // Delete user from Firestore
      await _firestoreService.deleteUser(user.id!);

      // Reload ngay sau khi xóa thành công
      await loadUsers();

      return true;
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xóa user: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
