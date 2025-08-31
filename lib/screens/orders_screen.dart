import 'package:boy_boy/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ui_state_provider.dart';
import '../utils/constants.dart';
import '../models/order.dart';
import '../widgets/order_card.dart';
import 'order_detail_screen.dart';
import 'map_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
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
              _buildHeader(),

              // Search and Filter Section
              _buildSearchAndFilter(),

              // Orders List
              Expanded(child: _buildOrdersList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: AppShadows.cardShadow,
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.primaryOrange,
              size: 30,
            ),
          ),

          const SizedBox(width: AppDimensions.paddingMedium),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<UIStateProvider>(
                  builder: (context, provider, child) {
                    final user = provider.currentUser;
                    return Text(
                      user?.name ?? 'Delivery Boy',
                      style: AppTextStyles.header3.copyWith(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Consumer<UIStateProvider>(
                  builder: (context, provider, child) {
                    final restaurant = provider.currentRestaurant;
                    return Text(
                      restaurant?.name ?? 'Restaurant',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // // Notification Icon
          // Container(
          //   padding: const EdgeInsets.all(AppDimensions.paddingSmall),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.2),
          //     borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          //   ),
          //   child: const Icon(
          //     Icons.notifications,
          //     color: Colors.white,
          //     size: 24,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
      ),
      child: Column(
        children: [
          // Search Bar - Commented out for now
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          //     boxShadow: AppShadows.cardShadow,
          //   ),
          //   child: TextField(
          //     controller: _searchController,
          //     onChanged: (value) {
          //       final provider = Provider.of<UIStateProvider>(
          //         context,
          //         listen: false,
          //       );
          //       provider.setSearchQuery(value);
          //     },
          //     decoration: InputDecoration(
          //       hintText: 'Search orders...',
          //       hintStyle: TextStyle(color: AppColors.textCaption),
          //       prefixIcon: const Icon(
          //         Icons.search,
          //         color: AppColors.textCaption,
          //       ),
          //       border: InputBorder.none,
          //       contentPadding: const EdgeInsets.symmetric(
          //         horizontal: AppDimensions.paddingMedium,
          //         vertical: AppDimensions.paddingMedium,
          //       ),
          //     ),
          //   ),
          // ),

          // const SizedBox(height: AppDimensions.paddingMedium),

          // Status Filter Chips
          _buildStatusFilterChips(),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    final statuses = [
      {'key': 'all', 'label': 'All', 'color': AppColors.textPrimary},
      {
        'key': 'assigned',
        'label': 'Assigned',
        'color': AppColors.statusAssigned,
      },
      {
        'key': 'picked_up',
        'label': 'Picked Up',
        'color': AppColors.statusPickedUp,
      },
      {
        'key': 'on_the_way',
        'label': 'On the Way',
        'color': AppColors.statusOnTheWay,
      },
      {
        'key': 'delivered',
        'label': 'Delivered',
        'color': AppColors.statusDelivered,
      },
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _selectedStatus == status['key'];

          return Container(
            margin: const EdgeInsets.only(right: AppDimensions.paddingSmall),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStatus = status['key'] as String;
                });
                final provider = Provider.of<UIStateProvider>(
                  context,
                  listen: false,
                );
                provider.setSelectedStatus(_selectedStatus);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? status['color'] as Color : Colors.white,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : status['color'] as Color,
                  ),
                ),
                child: Center(
                  child: Text(
                    status['label'] as String,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : status['color'] as Color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrdersList() {
    return Consumer<UIStateProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingState();
        }

        final orders = provider.filteredOrders;

        if (orders.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: provider.refreshOrders,
          color: AppColors.primaryOrange,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                margin: const EdgeInsets.only(
                  bottom: AppDimensions.paddingMedium,
                ),
                child: OrderCard(
                  order: order,
                  onTap: () => _navigateToOrderDetail(order),
                  onViewRoute: () =>
                      _navigateToMapScreen(order, provider.currentRestaurant!),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: AppDimensions.paddingLarge),
          Text(
            'Loading orders...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(Icons.inbox, size: 60, color: Colors.white70),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          const Text(
            'No orders found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          const Text(
            'Orders will appear here when assigned',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToOrderDetail(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order)),
    );
  }

  void _navigateToMapScreen(Order order, Restaurant restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(order: order, restaurant: restaurant),
      ),
    );
  }
}
