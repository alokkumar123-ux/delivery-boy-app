import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  final VoidCallback? onViewRoute;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onViewRoute,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: AppDimensions.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Order Number and Status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.orderNumber,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textCaption,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingMedium),

              // Customer Name
              Text(order.customerName, style: AppTextStyles.header3),

              const SizedBox(height: AppDimensions.paddingSmall),

              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.textCaption,
                    size: 16,
                  ),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Expanded(
                    child: Text(
                      order.customerAddress,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingMedium),

              // Order Details Row
              Row(
                children: [
                  // // Phone Number
                  // Expanded(
                  //   child: _buildContactChip(
                  //     icon: Icons.phone,
                  //     text: order.customerPhone,
                  //     onTap: () => _makePhoneCall(order.customerPhone),
                  //   ),
                  // ),

                  // const SizedBox(width: AppDimensions.paddingMedium),

                  // Distance
                  _buildDistanceChip(order.distance),

                  const SizedBox(width: AppDimensions.paddingMedium),

                  // Order Time
                  _buildTimeChip(order.orderTime),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingMedium),
              Container(
                child: _buildContactChip(
                  icon: Icons.phone,
                  text: order.customerPhone,
                  onTap: () => _makePhoneCall(order.customerPhone),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              // Items Preview
              if (order.items.isNotEmpty) ...[
                _buildItemsPreview(),
                const SizedBox(height: AppDimensions.paddingMedium),
              ],

              // Payment Method
              Row(
                children: [
                  const Icon(
                    Icons.payment,
                    color: AppColors.textCaption,
                    size: 16,
                  ),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Text(order.paymentMethod, style: AppTextStyles.bodySmall),
                  const Spacer(),
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.header3.copyWith(
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingMedium),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.visibility,
                      text: 'View Details',
                      onTap: onTap,
                      isPrimary: false,
                    ),
                  ),

                  const SizedBox(width: AppDimensions.paddingMedium),

                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.map,
                      text: 'View Route',
                      onTap: onViewRoute ?? () {},
                      isPrimary: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final statusInfo = {
      'assigned': {'color': AppColors.statusAssigned, 'icon': Icons.assignment},
      'picked_up': {'color': AppColors.statusPickedUp, 'icon': Icons.inventory},
      'on_the_way': {
        'color': AppColors.statusOnTheWay,
        'icon': Icons.delivery_dining,
      },
      'delivered': {
        'color': AppColors.statusDelivered,
        'icon': Icons.check_circle,
      },
    };

    final info =
        statusInfo[status] ??
        {'color': AppColors.textCaption, 'icon': Icons.help};

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: info['color'] as Color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(info['icon'] as IconData, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            AppHelpers.getStatusText(status),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactChip({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: AppColors.chipBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 16),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceChip(double? distance) {
    if (distance == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.straighten, color: AppColors.textCaption, size: 16),
          const SizedBox(width: 4),
          Text(
            '${distance.toStringAsFixed(1)} km',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textCaption,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(DateTime orderTime) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, color: AppColors.textCaption, size: 16),
          const SizedBox(width: 4),
          Text(
            AppHelpers.formatTime(orderTime),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textCaption,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsPreview() {
    final itemsToShow = order.items.take(3).toList();
    final remainingCount = order.items.length - itemsToShow.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items:',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textCaption,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: AppDimensions.paddingSmall,
          runSpacing: AppDimensions.paddingSmall,
          children: [
            ...itemsToShow.map(
              (item) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                ),
                child: Text(
                  '${item.quantity}x ${item.name}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            if (remainingCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                ),
                child: Text(
                  '+$remainingCount more',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.buttonHeightSmall,
        decoration: BoxDecoration(
          gradient: isPrimary ? AppGradients.primaryGradient : null,
          color: isPrimary ? null : AppColors.chipBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: isPrimary ? null : Border.all(color: AppColors.borderColor),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.white : AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isPrimary ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
