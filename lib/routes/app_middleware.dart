// filepath: c:\Users\tu\StudioProjects\admin_panel\admin_panel\lib\routes\app_middleware.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// Middleware to check authentication before accessing protected routes
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // If not logged in and trying to access protected route, redirect to login
    if (!authController.isLoggedIn && route != '/login') {
      return const RouteSettings(name: '/login');
    }

    return null; // Continue to requested route
  }
}
