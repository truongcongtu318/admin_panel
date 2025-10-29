import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../controllers/user_controller.dart';
import '../utils/constants.dart';
import 'user_form_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  void updateUser(UserModel updatedUser) {
    setState(() {
      user = updatedUser;
    });
  }

  Future<void> _refreshDetailData() async {
    final userController = Get.find<UserController>();
    await userController.loadUsers();

    // Tìm user mới nhất từ database
    final updatedUser = userController.allUsers.firstWhereOrNull(
      (u) => u.id == user.id,
    );

    if (updatedUser != null) {
      // Update user trong state để rebuild UI
      updateUser(updatedUser);
    }
  }

  Future<void> handleEdit() async {
    // Navigate to Edit Form
    final result = await Get.to(() => UserFormScreen(user: user));

    // Nếu có thay đổi (đã lưu), reload data và cập nhật user trong state
    if (result == true) {
      await _refreshDetailData();
    }
  }

  Future<void> handleDelete() async {
    final userController = Get.find<UserController>();
    final success = await userController.deleteUser(user);
    if (success) {
      // Quay về UserListScreen với result = true (đã xóa)
      Get.back(result: true);

      // Show snackbar SAU KHI đã về UserListScreen
      Get.snackbar(
        'Thành công',
        'Xóa user thành công!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết User'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: handleEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: handleDelete),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with image
            _buildHeader(),

            // User info
            _buildUserInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar/Image
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: AppShadows.large,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: user.imageUrl != null && user.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: user.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            _buildPlaceholderImage(),
                      )
                    : _buildPlaceholderImage(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Username
            Text(
              user.username,
              style: AppTextStyles.heading1.copyWith(color: AppColors.surface),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.accent.withValues(alpha: 0.2),
      child: const Center(
        child: Icon(Icons.person, size: 80, color: AppColors.primary),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin chi tiết', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.md),

          _buildInfoCard(
            icon: Icons.person,
            label: 'Username',
            value: user.username,
          ),
          const SizedBox(height: AppSpacing.sm),

          _buildInfoCard(icon: Icons.email, label: 'Email', value: user.email),
          const SizedBox(height: AppSpacing.sm),

          _buildInfoCard(
            icon: Icons.lock,
            label: 'Password',
            value: '••••••••',
          ),
          const SizedBox(height: AppSpacing.sm),

          _buildInfoCard(
            icon: Icons.fingerprint,
            label: 'User ID',
            value: user.id ?? 'N/A',
          ),
          const SizedBox(height: AppSpacing.sm),

          _buildInfoCard(
            icon: Icons.image,
            label: 'Hình ảnh',
            value: user.imageUrl != null && user.imageUrl!.isNotEmpty
                ? 'Đã có ảnh'
                : 'Chưa có ảnh',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySmall),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
