import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'utils/constants.dart';
import 'screens/login_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (includes Firestore và Storage)
  await Firebase.initializeApp();

  // Initialize GetX Controllers (Global)
  Get.put(AuthController());
  // UserController will be initialized when first accessed
  Get.lazyPut(() => UserController(), fenix: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Changed to GetMaterialApp
      title: 'Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      // GetX default transitions
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
