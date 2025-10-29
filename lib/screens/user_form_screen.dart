import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../controllers/user_controller.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/image_picker_widget.dart';

class UserFormScreen extends StatelessWidget {
  final UserModel? user; // Null = Add mode, Not null = Edit mode

  const UserFormScreen({super.key, this.user});

  bool get isEditMode => user != null;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController(
      text: user?.username ?? '',
    );
    final emailController = TextEditingController(text: user?.email ?? '');
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final Rx<File?> selectedImage = Rx<File?>(null);
    final Rx<String?> currentImageUrl = Rx<String?>(user?.imageUrl);
    final RxBool hasChanges = false.obs; // Track nếu user đã lưu thay đổi

    Future<void> handleSubmit() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      bool success;
      if (isEditMode) {
        success = await userController.updateUser(
          userId: user!.id!,
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.isNotEmpty
              ? passwordController.text
              : null,
          newImage: selectedImage.value,
          currentImageUrl: currentImageUrl.value,
        );
      } else {
        success = await userController.createUser(
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          image: selectedImage.value,
        );
      }

      if (success) {
        hasChanges.value = true; // Đánh dấu đã lưu thành công

        if (isEditMode) {
          // Edit mode: Show notification and stay on form
          Get.snackbar(
            'Thành công',
            'Cập nhật user thành công!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          // Add mode: Navigate back to list first, then show notification
          Get.back(result: true);

          // Wait a bit for navigation to complete, then show notification
          await Future.delayed(const Duration(milliseconds: 100));

          Get.snackbar(
            'Thành công',
            'Tạo user thành công!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      }
    }

    return PopScope(
      canPop: false, // Prevent default back
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Khi user nhấn Back, trả về result
          Get.back(result: hasChanges.value);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Sửa User' : 'Thêm User'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(result: hasChanges.value),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Picker
                Center(
                  child: Obx(
                    () => ImagePickerWidget(
                      imageUrl: currentImageUrl.value,
                      onImageSelected: (file) {
                        selectedImage.value = file;
                      },
                      onImageRemoved: () {
                        selectedImage.value = null;
                        currentImageUrl.value = null;
                      },
                      size: 140,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Nhấn vào ảnh để thay đổi',
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Username field
                CustomTextField(
                  label: 'Username *',
                  hint: 'Nhập username',
                  controller: usernameController,
                  prefixIcon: Icons.person,
                  validator: Validators.validateUsername,
                ),
                const SizedBox(height: AppSpacing.md),

                // Email field
                CustomTextField(
                  label: 'Email *',
                  hint: 'Nhập email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: AppSpacing.md),

                // Password field
                CustomTextField(
                  label: isEditMode
                      ? 'Password (để trống nếu không đổi)'
                      : 'Password *',
                  hint: 'Nhập password',
                  controller: passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock,
                  validator: isEditMode ? null : Validators.validatePassword,
                ),
                const SizedBox(height: AppSpacing.md),

                // Confirm Password field
                if (!isEditMode || passwordController.text.isNotEmpty)
                  CustomTextField(
                    label: 'Xác nhận Password *',
                    hint: 'Nhập lại password',
                    controller: confirmPasswordController,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      passwordController.text,
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),

                // Submit button
                Obx(
                  () => CustomButton(
                    text: isEditMode ? 'Cập nhật' : 'Tạo User',
                    onPressed: handleSubmit,
                    isLoading: userController.isLoading.value,
                    icon: isEditMode ? Icons.check : Icons.add,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Cancel button
                CustomButton(
                  text: 'Hủy',
                  onPressed: () => Get.back(result: hasChanges.value),
                  isOutlined: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
