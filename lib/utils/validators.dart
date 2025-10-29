class Validators {
  // Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được để trống';
    }

    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }

    return null;
  }

  // Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password không được để trống';
    }

    if (value.length < 6) {
      return 'Password phải có ít nhất 6 ký tự';
    }

    return null;
  }

  // Validate username
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username không được để trống';
    }

    if (value.length < 3) {
      return 'Username phải có ít nhất 3 ký tự';
    }

    if (value.length > 20) {
      return 'Username không được quá 20 ký tự';
    }

    // Chỉ chấp nhận chữ, số và underscore
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username chỉ chứa chữ, số và dấu gạch dưới';
    }

    return null;
  }

  // Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }

  // Validate confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận password';
    }

    if (value != password) {
      return 'Password không khớp';
    }

    return null;
  }
}
