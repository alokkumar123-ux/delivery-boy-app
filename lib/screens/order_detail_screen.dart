import 'package:flutter/material.dart';
import '../models/order.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

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
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMedium),
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
                  margin: const EdgeInsets.all(AppDimensions.paddingLarge),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusLarge,
                    ),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Header
                        _buildOrderHeader(),

                        const SizedBox(height: AppDimensions.paddingLarge),

                        // Customer Information
                        _buildSection(
                          title: 'Customer Information',
                          children: [
                            _buildInfoRow('Name', order.customerName),
                            _buildInfoRow('Phone', order.customerPhone),
                            _buildInfoRow('Address', order.customerAddress),
                          ],
                        ),

                        const SizedBox(height: AppDimensions.paddingLarge),

                        // Order Items
                        _buildSection(
                          title: 'Order Items',
                          children: order.items
                              .map((item) => _buildItemRow(item))
                              .toList(),
                        ),

                        const SizedBox(height: AppDimensions.paddingLarge),

                        // Payment Information
                        _buildSection(
                          title: 'Payment Information',
                          children: [
                            _buildInfoRow('Method', order.paymentMethod),
                            _buildInfoRow(
                              'Total Amount',
                              '\₹${order.totalAmount.toStringAsFixed(2)}',
                            ),
                          ],
                        ),

                        const SizedBox(height: AppDimensions.paddingLarge),

                        // Status Update Buttons
                        _buildStatusUpdateButtons(),

                        const SizedBox(height: AppDimensions.paddingLarge),

                        // Notes
                        if (order.notes != null && order.notes!.isNotEmpty)
                          _buildSection(
                            title: 'Notes',
                            children: [
                              _buildInfoRow(
                                'Special Instructions',
                                order.notes!,
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
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Text(
            order.orderNumber,
            style: AppTextStyles.header2.copyWith(
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppHelpers.getStatusColor(order.status),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Text(
              AppHelpers.getStatusText(order.status),
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

  Widget _buildItemRow(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
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

        if (order.status == 'assigned')
          _buildStatusButton('Picked Up', Icons.inventory, () {
            // Update status to picked up
          }),

        if (order.status == 'picked_up')
          _buildStatusButton('On the Way', Icons.delivery_dining, () {
            // Update status to on the way
          }),

        if (order.status == 'on_the_way')
          _buildStatusButton('Delivered', Icons.check_circle, () {
            // Update status to delivered
          }),

        if (order.status == 'delivered')
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

  Widget _buildStatusButton(String text, IconData icon, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.buttonShadow,
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
      ),
    );
  }
}
