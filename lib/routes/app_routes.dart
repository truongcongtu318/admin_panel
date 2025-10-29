// filepath: c:\Users\tu\StudioProjects\admin_panel\admin_panel\lib\routes\app_routes.dart

/// App Routes for navigation management
/// Sử dụng GetX navigation
class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String userList = '/user-list';
  static const String userDetail = '/user-detail';
  static const String userForm = '/user-form';

  // Navigation helpers
  static String getInitialRoute() => login;
}
