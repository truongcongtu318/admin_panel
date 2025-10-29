import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../screens/user_list_screen.dart';
import '../screens/login_screen.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Reactive state
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxBool isLoading = false.obs;

  // Getters
  bool get isLoggedIn => currentUser.value != null;
  bool get isAdmin => _authService.isAdmin();
  AuthService get authService => _authService;

  // Login
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _authService.login(email, password);
      currentUser.value = user;

      // Navigate to user list
      Get.offAll(() => const UserListScreen());

      Get.snackbar(
        'Thành công',
        'Đăng nhập thành công!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withValues(alpha: 0.1),
        colorText: Get.theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  void logout() {
    _authService.logout();
    currentUser.value = null;
    Get.offAll(() => const LoginScreen());

    Get.snackbar(
      'Đã đăng xuất',
      'Hẹn gặp lại!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Hash password helper
  String hashPassword(String password) {
    return _authService.hashPassword(password);
  }
}
