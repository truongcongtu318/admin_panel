import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void handleLogin() {
      if (!formKey.currentState!.validate()) {
        return;
      }

      authController.login(
        emailController.text.trim(),
        passwordController.text,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    size: 60,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Title
                Text(
                  'Admin Panel',
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Đăng nhập để quản lý người dùng',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Email field
                CustomTextField(
                  label: 'Email',
                  hint: 'Nhập email của bạn',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: AppSpacing.md),

                // Password field
                CustomTextField(
                  label: 'Password',
                  hint: 'Nhập password của bạn',
                  controller: passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Login button with Obx for reactive loading state
                Obx(
                  () => CustomButton(
                    text: 'Đăng nhập',
                    onPressed: handleLogin,
                    isLoading: authController.isLoading.value,
                    icon: Icons.login,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
