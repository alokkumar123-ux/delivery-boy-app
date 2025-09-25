import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/ui_state_provider.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingLarge.w),
                child: Row(
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              // Profile Content
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(AppDimensions.paddingLarge.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusLarge.r,
                    ),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: Consumer<UIStateProvider>(
                    builder: (context, provider, child) {
                      final user = provider.currentUser;
                      final restaurant = provider.currentRestaurant;

                      if (provider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryOrange,
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        padding: EdgeInsets.all(AppDimensions.paddingLarge.w),
                        child: Column(
                          children: [
                            // Profile Picture
                            Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                color: AppColors.primaryOrange,
                                borderRadius: BorderRadius.circular(60.r),
                                boxShadow: AppShadows.cardShadow,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60.r),
                                child:
                                    user?.profileImage != null &&
                                        user!.profileImage!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: user.profileImage!,
                                        width: 120.w,
                                        height: 120.w,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                              color: AppColors.primaryOrange,
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 60,
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              color: AppColors.primaryOrange,
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 60,
                                              ),
                                            ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                              ),
                            ),

                            SizedBox(height: AppDimensions.paddingLarge.h),

                            // User Name
                            Text(
                              user?.userName ?? 'Delivery Boy',
                              style: AppTextStyles.header1,
                            ),

                            SizedBox(height: AppDimensions.paddingSmall.h),

                            // User Email
                            Text(
                              user?.userEmail ?? 'email@example.com',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textCaption,
                              ),
                            ),

                            SizedBox(height: AppDimensions.paddingXXLarge.h),

                            // User Details Section
                            _buildSection(
                              title: 'Personal Information',
                              children: [
                                _buildInfoRow(
                                  'Phone',
                                  user?.userPhone ?? 'N/A',
                                ),
                                _buildInfoRow(
                                  'Vehicle',
                                  '${user?.vehicleType ?? 'N/A'} - ${user?.vehicleNumber ?? 'N/A'}',
                                ),
                                _buildInfoRow(
                                  'Member Since',
                                  '${user?.createdAt.day}/${user?.createdAt.month}/${user?.createdAt.year}',
                                ),
                              ],
                            ),

                            SizedBox(height: AppDimensions.paddingLarge.h),

                            // Restaurant Details Section
                            _buildSection(
                              title: 'Restaurant Information',
                              children: [
                                _buildInfoRow(
                                  'Restaurant',
                                  restaurant?.name ?? 'N/A',
                                ),
                                _buildInfoRow(
                                  'Address',
                                  restaurant?.address ?? 'N/A',
                                ),
                                _buildInfoRow(
                                  'Phone',
                                  restaurant?.phone ?? 'N/A',
                                ),
                              ],
                            ),

                            // SizedBox(height: AppDimensions.paddingLarge.h),

                            // // Action Buttons
                            // _buildActionButton(
                            //   icon: Icons.settings,
                            //   text: 'Settings',
                            //   onTap: () {
                            //     // Navigate to settings
                            //   },
                            // ),

                            // SizedBox(height: AppDimensions.paddingMedium.h),

                            // _buildActionButton(
                            //   icon: Icons.help,
                            //   text: 'Help & Support',
                            //   onTap: () {
                            //     // Navigate to help
                            //   },
                            // ),

                            // SizedBox(height: AppDimensions.paddingMedium.h),

                            // _buildActionButton(
                            //   icon: Icons.info,
                            //   text: 'About App',
                            //   onTap: () {
                            //     // Show app info
                            //   },
                            // ),
                            SizedBox(height: AppDimensions.paddingLarge.h),

                            // Logout Button
                            Container(
                              width: double.infinity,
                              height: AppDimensions.buttonHeight,
                              decoration: BoxDecoration(
                                color: AppColors.statusError,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium.r,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  _showLogoutDialog(context);
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: AppDimensions.paddingMedium.h),

                            // App Version
                            Text(
                              'App Version 1.0.0',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textCaption,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.header3.copyWith(color: AppColors.primaryOrange),
        ),
        SizedBox(height: AppDimensions.paddingMedium.h),
        Container(
          padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
          decoration: BoxDecoration(
            color: AppColors.chipBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium.r),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textCaption,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: AppDimensions.buttonHeightSmall,
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.textSecondary, size: 20),
        label: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Get the provider and logout
              final provider = Provider.of<UIStateProvider>(
                context,
                listen: false,
              );
              provider.clearData();
              // Clear persisted session
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('userId');
              // Notify parent to handle navigation
              onLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
