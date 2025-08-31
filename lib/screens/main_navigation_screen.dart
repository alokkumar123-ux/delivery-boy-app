import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ui_state_provider.dart';
import '../utils/constants.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainNavigationScreen({super.key, required this.onLogout});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const OrdersScreen(),
    // const _MapPlaceholderScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize mock data when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UIStateProvider>(context, listen: false);
      provider.initializeMockData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Update provider
    final provider = Provider.of<UIStateProvider>(context, listen: false);
    provider.setCurrentTabIndex(index);

    // Animate to page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGradientEnd,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          final provider = Provider.of<UIStateProvider>(context, listen: false);
          provider.setCurrentTabIndex(index);
        },
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingSmall,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.assignment,
                label: 'Orders',
                isSelected: _currentIndex == 0,
              ),
              // _buildNavItem(
              //   index: 1,
              //   icon: Icons.map,
              //   label: 'Map',
              //   isSelected: _currentIndex == 1,
              // ),
              _buildNavItem(
                index: 1,
                icon: Icons.person,
                label: 'Profile',
                isSelected: _currentIndex == 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrange.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryOrange
                  : AppColors.textCaption,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primaryOrange
                    : AppColors.textCaption,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Removed _MapPlaceholderScreen as Map tab is no longer needed
