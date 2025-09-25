import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/ui_state_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/user.dart';
import 'models/restaurant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DeliveryBoyApp());
}

class DeliveryBoyApp extends StatelessWidget {
  const DeliveryBoyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UIStateProvider())],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Delivery Boy App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryOrange,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: child,
          );
        },
        child: const AppWrapper(),
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isLoggedIn = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if this is the first app launch after installation
    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

    if (isFirstLaunch) {
      await prefs.clear();
      await prefs.setBool('is_first_launch', false);

      setState(() {
        _isLoggedIn = false;
        _isInitialized = true;
      });
      return;
    }

    final storedUserId = prefs.getString('userId');
    final userJson = prefs.getString('user_json');
    final restaurantJson = prefs.getString('restaurant_json');

    // More strict validation - all data must exist and be valid
    bool hasValidSession = false;

    if (storedUserId != null &&
        storedUserId.isNotEmpty &&
        userJson != null &&
        userJson.isNotEmpty &&
        restaurantJson != null &&
        restaurantJson.isNotEmpty) {
      try {
        // Try to parse the JSON to ensure it's valid
        final user = User.fromJson(jsonDecode(userJson));
        final restaurant = Restaurant.fromJson(jsonDecode(restaurantJson));

        // If parsing succeeds, update the provider
        final provider = Provider.of<UIStateProvider>(context, listen: false);
        provider.setUserData(user, restaurant);

        hasValidSession = true;
      } catch (e) {
        // Clear invalid data
        await prefs.remove('userId');
        await prefs.remove('user_json');
        await prefs.remove('restaurant_json');
        hasValidSession = false;
      }
    } else {
      hasValidSession = false;
    }

    setState(() {
      _isLoggedIn = hasValidSession;
      _isInitialized = true;
    });
  }

  void _onLogout() async {
    setState(() {
      _isLoggedIn = false;
    });

    // Clear data on logout
    final provider = Provider.of<UIStateProvider>(context, listen: false);
    provider.clearData();

    // Clear ALL stored session data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('user_json');
    await prefs.remove('restaurant_json');
    // Note: Don't clear 'is_first_launch' flag on logout, only on fresh install
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
      );
    }

    if (_isLoggedIn) {
      return MainNavigationScreen(onLogout: _onLogout);
    } else {
      return const LoginScreen();
    }
  }
}
