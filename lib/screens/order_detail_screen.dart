//

import 'package:boy_boy/services/api_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order currentOrder;

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
  }

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
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingMedium.w),
                    const Text(
                      'Order Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Order Details Content
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppDimensions.paddingLarge.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Header
                        _buildOrderHeader(),

                        SizedBox(height: AppDimensions.paddingLarge.h),

                        // Customer Information
                        _buildSection(
                          title: 'Customer Information',
                          children: [
                            _buildInfoRow('Name', currentOrder.customerName),
                            _buildInfoRow('Phone', currentOrder.customerPhone),
                            _buildInfoRow(
                              'Address',
                              currentOrder.customerAddress,
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.paddingLarge.h),

                        // Order Items
                        _buildSection(
                          title: 'Order Items',
                          children: currentOrder.items
                              .map((item) => _buildItemRow(item))
                              .toList(),
                        ),

                        SizedBox(height: AppDimensions.paddingLarge.h),

                        // Payment Information
                        _buildSection(
                          title: 'Payment Information',
                          children: [
                            _buildInfoRow('Method', currentOrder.paymentMethod),
                            _buildInfoRow(
                              'Total Amount',
                              '\₹${currentOrder.totalAmount.toStringAsFixed(2)}',
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.paddingLarge.h),

                        // Status Update Buttons
                        _buildStatusUpdateButtons(),

                        const SizedBox(height: AppDimensions.paddingLarge),

                        // Notes
                        if (currentOrder.notes != null &&
                            currentOrder.notes!.isNotEmpty)
                          _buildSection(
                            title: 'Notes',
                            children: [
                              _buildInfoRow(
                                'Special Instructions',
                                currentOrder.notes!,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingLarge.w),
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium.r),
      ),
      child: Column(
        children: [
          Text(
            currentOrder.orderNumber,
            style: AppTextStyles.header2.copyWith(
              color: AppColors.primaryOrange,
            ),
          ),
          SizedBox(height: AppDimensions.paddingSmall.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium.w,
              vertical: AppDimensions.paddingSmall.h,
            ),
            decoration: BoxDecoration(
              color: AppHelpers.getStatusColor(currentOrder.status),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium.r),
            ),
            child: Text(
              AppHelpers.getStatusText(currentOrder.status),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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

  Widget _buildItemRow(OrderItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(item.name, style: AppTextStyles.bodyMedium),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'x${item.quantity}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textCaption,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${item.totalPrice.toStringAsFixed(2)}',
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

  Widget _buildStatusUpdateButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update Status',
          style: AppTextStyles.header3.copyWith(color: AppColors.primaryOrange),
        ),
        const SizedBox(height: AppDimensions.paddingMedium),

        // Button for "confirmed" status -> "Order is Preparing"
        if (currentOrder.status == 'confirmed')
          _buildStatusButton(
            'Order is Preparing',
            Icons.inventory,
            () async {},
          ),

        // Button for "picked_up" status -> "Out for Delivery"
        if (currentOrder.status == 'pickedup')
          _buildStatusButton(
            'Out for Delivery',
            Icons.delivery_dining,
            () async {
              await _handleStatusUpdate(
                () => ApiService.markOutForDelivery(
                  currentOrder.id,
                  currentOrder.deliveryBoyId,
                ),
                'out_for_delivery',
                'Order marked as Out for Delivery!',
              );
            },
          ),

        // Button for "out_for_delivery" status -> "Delivered"
        if (currentOrder.status == 'out_for_delivery')
          _buildStatusButton('Mark as Delivered', Icons.check_circle, () async {
            await _handleStatusUpdate(
              () => ApiService.markAsDelivered(
                currentOrder.id,
                currentOrder.deliveryBoyId,
              ),
              'delivered',
              'Order marked as Delivered!',
            );
          }),

        // Display completed status
        if (currentOrder.status == 'delivered')
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.statusDelivered,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: AppDimensions.paddingSmall),
                Text(
                  'Order Completed',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Optimized helper method to handle status updates
  Future<void> _handleStatusUpdate(
    Future<Map<String, dynamic>> Function() apiCall,
    String newStatus,
    String successMessage,
  ) async {
    try {
      final response = await apiCall();

      if (mounted && response['status'] == 'success') {
        // Update local order status
        setState(() {
          currentOrder = Order(
            id: currentOrder.id,
            orderNumber: currentOrder.orderNumber,
            customerName: currentOrder.customerName,
            customerPhone: currentOrder.customerPhone,
            customerAddress: currentOrder.customerAddress,
            customerLatitude: currentOrder.customerLatitude,
            customerLongitude: currentOrder.customerLongitude,
            items: currentOrder.items,
            totalAmount: currentOrder.totalAmount,
            paymentMethod: currentOrder.paymentMethod,
            status: newStatus, // ✅ Fixed: Use the newStatus parameter
            orderTime: currentOrder.orderTime,
            deliveryBoyId: currentOrder.deliveryBoyId,
            notes: currentOrder.notes,
          );
        });

        // Show success message
        _showSnackBar(successMessage);

        // Optional: Pop and signal parent to refresh
        if (newStatus == 'delivered' || newStatus == 'out_for_delivery') {
          Navigator.pop(context, true);
        }
      } else if (mounted) {
        _showSnackBar(response['message'] ?? 'Failed to update status');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error: $e');
      }
    }
  }

  // Helper method for safe SnackBar display
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }

  Widget _buildStatusButton(
    String text,
    IconData icon,
    VoidCallback onTap, {
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium.h),
      decoration: BoxDecoration(
        gradient: isLoading ? null : AppGradients.primaryGradient,
        color: isLoading ? Colors.grey.shade400 : null,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium.r),
        boxShadow: isLoading ? null : AppShadows.buttonShadow,
      ),
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onTap,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(icon, color: Colors.white),
        label: Text(
          isLoading ? 'Updating...' : text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium.r),
          ),
        ),
      ),
    );
  }
}
