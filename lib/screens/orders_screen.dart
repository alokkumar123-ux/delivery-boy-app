import 'package:boy_boy/models/restaurant.dart';
import 'package:boy_boy/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/ui_state_provider.dart';
import '../utils/constants.dart';
import '../models/order.dart';
import '../widgets/order_card.dart';
import 'order_detail_screen.dart';
import 'map_screen.dart';
import 'dart:async';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // final TextEditingController _searchController = TextEditingController();
  NotificationServices notificationServices = NotificationServices();
  String _selectedStatus = 'preparing';
  List<Order> _orders = [];
  bool _isLoading = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    notificationServices.requestNotificationPermission();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
    });
    final provider = Provider.of<UIStateProvider>(context, listen: false);
    final userId = provider.currentUser?.userId.replaceAll("user_", "") ?? '';
    String endpoint;
    if (_selectedStatus == 'preparing') {
      final url = Uri.parse(
        'https://resto.swaadpos.in/api/delivery-executives/$userId/orders',
      );
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'success' && data['orders'] is List) {
            setState(() {
              _orders = (data['orders'] as List)
                  .map((o) => Order.fromJson(_normalizeOrderJson(o)))
                  .toList();
            });
          } else {
            setState(() {
              _orders = [];
            });
          }
        } else {
          setState(() {
            _orders = [];
          });
        }
      } catch (e) {
        setState(() {
          _orders = [];
        });
      }
      setState(() {
        _isLoading = false;
      });
    } else if (_selectedStatus == 'out_for_delivery') {
      final url = Uri.parse(
        'https://resto.swaadpos.in/api/delivery-executives/out-for-delivery/$userId',
      );
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'success' && data['orders'] is List) {
            setState(() {
              _orders = (data['orders'] as List)
                  .map((o) => Order.fromJson(_normalizeOrderJson(o)))
                  .toList();
            });
          } else {
            setState(() {
              _orders = [];
            });
          }
        } else {
          setState(() {
            _orders = [];
          });
        }
      } catch (e) {
        setState(() {
          _orders = [];
        });
      }
      setState(() {
        _isLoading = false;
      });
    } else if (_selectedStatus == 'delivered') {
      final url = Uri.parse(
        'https://resto.swaadpos.in/api/delivery-executives/todays-delivered-orders',
      );
      try {
        final response = await http.post(
          url,
          body: {'delivery_boy_id': '$userId'},
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'success' && data['orders'] is List) {
            setState(() {
              _orders = (data['orders'] as List)
                  .map((o) => Order.fromJson(_normalizeOrderJson(o)))
                  .toList();
            });
          } else {
            setState(() {
              _orders = [];
            });
          }
        } else {
          setState(() {
            _orders = [];
          });
        }
      } catch (e) {
        setState(() {
          _orders = [];
        });
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      endpoint = 'orders';
    }
  }

  Map<String, dynamic> _normalizeOrderJson(Map<String, dynamic> json) {
    return {
      'id': json['id'] ?? '',
      'order_number': json['orderNumber'] ?? '',
      'customer_name': json['customerName'] ?? '',
      'customer_phone': json['customerPhone'] ?? '',
      'customer_address': json['customerAddress'] ?? '',
      'customer_latitude':
          double.tryParse(json['customerLatitude']?.toString() ?? '0') ?? 0.0,
      'customer_longitude':
          double.tryParse(json['customerLongitude']?.toString() ?? '0') ?? 0.0,
      'items': json['items'] ?? [],
      'total_amount':
          double.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0.0,
      'payment_method': json['paymentMethod'] ?? '',
      'status': json['status'] ?? '',
      'notes': json['notes'],
      'order_time': json['orderTime'],
      'assigned_time': json['assignedTime'],
      'out_for_delivery_time': json['outForDeliveryTime'],
      'on_the_way_time': json['onTheWayTime'],
      'delivered_time': json['deliveredTime'],
      'delivery_boy_id': json['deliveryBoyId'] ?? '',
      'distance': null,
      'estimated_time': null,
    };
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
          Consumer<UIStateProvider>(
            builder: (context, provider, child) {
              final user = provider.currentUser;
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: AppShadows.cardShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child:
                      user?.profileImage != null &&
                          user!.profileImage!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: user.profileImage!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                            child: const Icon(
                              Icons.person,
                              color: AppColors.primaryOrange,
                              size: 30,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.white,
                            child: const Icon(
                              Icons.person,
                              color: AppColors.primaryOrange,
                              size: 30,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: AppColors.primaryOrange,
                          size: 30,
                        ),
                ),
              );
            },
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
                      user?.userName ?? 'Delivery Boy',
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
          // Status Filter Chips
          _buildStatusFilterChips(),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    final statuses = [
      {
        'key': 'preparing',
        'label': 'Preparing',
        'color': AppColors.statusAssigned,
      },
      {
        'key': 'out_for_delivery',
        'label': 'Out for Delivery',
        'color': AppColors.statusPickedUp,
      },
      {
        'key': 'delivered',
        'label': 'Delivered',
        'color': AppColors.statusDelivered,
      },
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _selectedStatus == status['key'];
          return Container(
            margin: EdgeInsets.only(right: AppDimensions.paddingSmall.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStatus = status['key'] as String;
                });
                // Reset polling when status changes
                _pollTimer?.cancel();
                if (_selectedStatus == 'preparing') {
                  _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
                    _fetchOrders();
                  });
                }
                _fetchOrders();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium.w,
                  vertical: AppDimensions.paddingSmall.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? status['color'] as Color : Colors.white,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium.r,
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
                      fontSize: 12.sp,
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
    if (_isLoading) {
      return _buildLoadingState();
    }
    if (_orders.isEmpty) {
      return _buildEmptyState();
    }
    return RefreshIndicator(
      onRefresh: _fetchOrders,
      color: AppColors.primaryOrange,
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimensions.paddingLarge.w),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return Container(
            margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium.h),
            child: OrderCard(
              order: order,
              onTap: () => _navigateToOrderDetail(order),
              onViewRoute: () {
                final provider = Provider.of<UIStateProvider>(
                  context,
                  listen: false,
                );
                _navigateToMapScreen(order, provider.currentRestaurant!);
              },
            ),
          );
        },
      ),
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
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60.r),
            ),
            child: const Icon(Icons.inbox, size: 60, color: Colors.white70),
          ),
          SizedBox(height: AppDimensions.paddingLarge.h),
          const Text(
            'No orders found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimensions.paddingSmall.h),
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
    ).then((shouldRefresh) {
      if (shouldRefresh == true) {
        _fetchOrders();
      }
    });
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
