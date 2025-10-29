import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../utils/constants.dart';
import '../widgets/user_card.dart';
import 'user_form_screen.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late final UserController userController;
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    userController = Get.find<UserController>();
    authController = Get.find<AuthController>();

    // Load users when screen is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.loadUsers();
    });
  }

  // Refresh when returning to this screen
  void _refreshOnResume() {
    userController.loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.admin_panel_settings_rounded),
        ),
        title: Obx(
          () => userController.searchQuery.value.isEmpty
              ? Row(
                  children: [
                    const Text('QUẢN LÝ USERS'),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${userController.filteredUsers.length} USER',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
              : TextField(
                  autofocus: true,
                  style: const TextStyle(color: AppColors.primary),
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm...',
                    hintStyle: TextStyle(color: AppColors.primary),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: userController.searchUsers,
                ),
        ),
        titleSpacing: 8,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                userController.searchQuery.value.isEmpty
                    ? Icons.search
                    : Icons.close,
              ),
              onPressed: () {
                if (userController.searchQuery.value.isEmpty) {
                  userController.searchQuery.value = ' '; // Trigger search mode
                } else {
                  userController.searchQuery.value = '';
                  userController.searchUsers('');
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: userController.loadUsers,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                authController.logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'user',
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Obx(
                      () => Text(
                        authController.currentUser.value?.username ?? 'Admin',
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: AppColors.error),
                    SizedBox(width: AppSpacing.sm),
                    Text('Đăng xuất'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildUserList(userController);
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigate to Add User Form and wait for result
          final result = await Get.to(() => const UserFormScreen());
          // If user was created, refresh the list
          if (result == true) {
            _refreshOnResume();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm User'),
      ),
    );
  }

  Widget _buildUserList(UserController userController) {
    if (userController.filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              userController.searchQuery.value.isNotEmpty
                  ? Icons.search_off
                  : Icons.people_outline,
              size: 80,
              color: AppColors.accent,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              userController.searchQuery.value.isNotEmpty
                  ? 'Không tìm thấy user'
                  : 'Chưa có user nào',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              userController.searchQuery.value.isNotEmpty
                  ? 'Thử tìm kiếm với từ khóa khác'
                  : 'Nhấn nút + để thêm user mới',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: userController.loadUsers,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 80),
        itemCount: userController.filteredUsers.length,
        itemBuilder: (context, index) {
          final user = userController.filteredUsers[index];
          return UserCard(
            user: user,
            onTap: () async {
              // Navigate to Detail and wait for result
              final result = await Get.to(() => UserDetailScreen(user: user));
              // If user was deleted or edited, refresh the list
              if (result == true) {
                _refreshOnResume();
              }
            },
            onEdit: () async {
              // Navigate to Edit Form and wait for result
              final result = await Get.to(() => UserFormScreen(user: user));
              // If user was updated, refresh the list
              if (result == true) {
                _refreshOnResume();
              }
            },
            onDelete: () async {
              // Delete user and refresh automatically (controller already handles this)
              final success = await userController.deleteUser(user);
              if (success) {
                Get.snackbar(
                  'Thành công',
                  'Xóa user thành công!',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              }
            },
          );
        },
      ),
    );
  }
}
