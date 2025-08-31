import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ui_state_provider.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
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
                    // IconButton(
                    //   onPressed: () {
                    //     // Show profile edit options
                    //   },
                    //   icon: const Icon(
                    //     Icons.edit,
                    //     color: Colors.white,
                    //     size: 24,
                    //   ),
                    // ),
                  ],
                ),
              ),

              // Profile Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(AppDimensions.paddingLarge),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusLarge,
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
                        padding: const EdgeInsets.all(
                          AppDimensions.paddingLarge,
                        ),
                        child: Column(
                          children: [
                            // Profile Picture
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.primaryOrange,
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: AppShadows.cardShadow,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),

                            const SizedBox(height: AppDimensions.paddingLarge),

                            // User Name
                            Text(
                              user?.name ?? 'Delivery Boy',
                              style: AppTextStyles.header1,
                            ),

                            const SizedBox(height: AppDimensions.paddingSmall),

                            // User Email
                            Text(
                              user?.email ?? 'email@example.com',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textCaption,
                              ),
                            ),

                            const SizedBox(
                              height: AppDimensions.paddingXXLarge,
                            ),

                            // User Details Section
                            _buildSection(
                              title: 'Personal Information',
                              children: [
                                _buildInfoRow('Phone', user?.phone ?? 'N/A'),
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

                            const SizedBox(height: AppDimensions.paddingLarge),

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

                            const SizedBox(height: AppDimensions.paddingLarge),

                            // Statistics Section - Commented out for now
                            // _buildSection(
                            //   title: 'Delivery Statistics',
                            //   children: [
                            //     _buildStatRow(
                            //       'Total Orders',
                            //       '${provider.orders.length}',
                            //     ),
                            //     _buildStatRow(
                            //       'Delivered Today',
                            //       '${provider.getTodayOrders().length}',
                            //     ),
                            //     _buildStatRow(
                            //       'Total Earnings',
                            //       '\$${provider.getOrderStatistics()['total_earnings']?.toStringAsFixed(2) ?? '0.00'}',
                            //     ),
                            //   ],
                            // ),

                            // const SizedBox(height: AppDimensions.paddingLarge),

                            // Action Buttons
                            _buildActionButton(
                              icon: Icons.settings,
                              text: 'Settings',
                              onTap: () {
                                // Navigate to settings
                              },
                            ),

                            const SizedBox(height: AppDimensions.paddingMedium),

                            _buildActionButton(
                              icon: Icons.help,
                              text: 'Help & Support',
                              onTap: () {
                                // Navigate to help
                              },
                            ),

                            const SizedBox(height: AppDimensions.paddingMedium),

                            _buildActionButton(
                              icon: Icons.info,
                              text: 'About App',
                              onTap: () {
                                // Show app info
                              },
                            ),

                            const SizedBox(height: AppDimensions.paddingLarge),

                            // Logout Button
                            Container(
                              width: double.infinity,
                              height: AppDimensions.buttonHeight,
                              decoration: BoxDecoration(
                                color: AppColors.statusError,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium,
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

                            const SizedBox(height: AppDimensions.paddingMedium),

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
        const SizedBox(height: AppDimensions.paddingMedium),
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.chipBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
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

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
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
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
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
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
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
            onPressed: () {
              Navigator.of(context).pop();
              // Get the provider and logout
              final provider = Provider.of<UIStateProvider>(
                context,
                listen: false,
              );
              provider.clearData();
              // Navigate back to login (this will be handled by the parent)
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
