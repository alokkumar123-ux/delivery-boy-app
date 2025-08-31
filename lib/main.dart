import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ui_state_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const DeliveryBoyApp());
}

class DeliveryBoyApp extends StatelessWidget {
  const DeliveryBoyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UIStateProvider())],
      child: MaterialApp(
        title: 'Delivery Boy App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryOrange,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const AppWrapper(),
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
    // Simulate checking login status
    await Future.delayed(const Duration(milliseconds: 1000));

    // For demo purposes, start with login screen
    // In real app, check shared preferences for stored token
    setState(() {
      _isLoggedIn = false;
      _isInitialized = true;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });

    // Initialize mock data after successful login
    final provider = Provider.of<UIStateProvider>(context, listen: false);
    provider.initializeMockData();
  }

  void _onLogout() {
    setState(() {
      _isLoggedIn = false;
    });

    // Clear data on logout
    final provider = Provider.of<UIStateProvider>(context, listen: false);
    provider.clearData();
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
