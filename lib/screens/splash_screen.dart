import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/getx_controllers/auth_controller.dart';
import '../utils/colors.dart';
import 'login_screen.dart';
import 'dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Add a small delay for splash effect
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if user has a valid token
    final token = await _authController.getToken();
    
    if (token != null && token.isNotEmpty) {
      // User is logged in, navigate to dashboard
      Get.offAllNamed('/dashboard');
    } else {
      // User is not logged in, navigate to login
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: scaffoldBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/pngs/kkr_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              // App Title
              const Text(
                'KKR Admin Panel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),
              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFc89849)),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}