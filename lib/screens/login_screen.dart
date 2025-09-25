import 'package:boy_boy/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/ui_state_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../screens/main_navigation_screen.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the real API
      final loginResponse = await ApiService.deliveryLogin(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (loginResponse.status == 'success') {
        // Set user and restaurant data in provider
        final provider = Provider.of<UIStateProvider>(context, listen: false);
        provider.setUserData(loginResponse.user, loginResponse.restaurant);

        // Persist session: save full user and restaurant JSON for auto-login
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', loginResponse.user.userId);
        await prefs.setString(
          'user_json',
          jsonEncode(loginResponse.user.toJson()),
        );
        await prefs.setString(
          'restaurant_json',
          jsonEncode(loginResponse.restaurant.toJson()),
        );

        // Navigate to main app
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainNavigationScreen(
                onLogout: () {
                  // Handle logout - navigate back to login
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.remove('userId');
                    prefs.remove('user_json');
                    prefs.remove('restaurant_json');
                  });
                  provider.clearData();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          AppHelpers.showSnackBar(
            context,
            loginResponse.message,
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppHelpers.showSnackBar(
          context,
          'Login failed: ${e.toString()}',
          isError: true,
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primaryGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and Title Section
                      _buildLogoSection(),
                      SizedBox(height: 40.h),

                      // Login Card
                      _buildLoginCard(),

                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // App Icon
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Image.asset('assets/images/inapplogo.png', fit: BoxFit.fill),
          ),
        ),
        SizedBox(height: 20.h),

        // App Title
        Text('Delivery Boy', style: AppTextStyles.header1),
        SizedBox(height: 8.h),

        // Subtitle
        Text(
          'Manage your deliveries efficiently',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Text('Welcome Back!', style: AppTextStyles.header2),
              SizedBox(height: 8.h),
              Text(
                'Sign in to continue',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 32.h),

              // Username Field
              _buildInputField(
                controller: _usernameController,
                label: 'Username',
                hint: 'Enter your username',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),

              // Password Field
              _buildInputField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Enter your password',
                icon: Icons.lock_outline,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),

              // Login Button
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint, // Fixed: Removed 'deliveryBoyId' syntax error
            hintStyle: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary.withOpacity(0.6),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.borderColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColors.primaryOrange,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColors.statusError,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
            ).copyWith(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.login, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Sign In',
                        style: AppTextStyles.buttonText.copyWith(
                          color: Colors.white,
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
