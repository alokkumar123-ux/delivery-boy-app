import 'package:flutter/material.dart';
import 'dart:async';
import '../models/order.dart';
import '../models/user.dart';
import '../models/restaurant.dart';
// import '../services/mock_data_service.dart';

class UIStateProvider extends ChangeNotifier {
  Timer? _ordersTimer;
  // Mock data
  List<Order> orders = [];
  User? currentUser;
  Restaurant? currentRestaurant;
  String selectedStatus = 'all';
  String searchQuery = '';
  bool isLoading = false;
  int currentTabIndex = 0;
  List<Order> get filteredOrders {
    List<Order> filtered = orders;
    // Search functionality commented out for now
    // if (_searchQuery.isNotEmpty) {
    //   filtered = filtered.where((order) {
    //     return order.customerName.toLowerCase().contains(
    //           _searchQuery.toLowerCase(),
    //         ) ||
    //         order.orderNumber.toLowerCase().contains(
    //           _searchQuery.toLowerCase(),
    //         ) ||
    //         order.customerAddress.toLowerCase().contains(
    //           _searchQuery.toLowerCase(),
    //         );
    //   }).toList();
    // }

    return filtered;
  }

  // Get orders by status
  List<Order> getOrdersByStatus(String status) {
    return orders.where((order) => order.status == status).toList();
  }

  // Get today's orders
  List<Order> getTodayOrders() {
    final today = DateTime.now();
    return orders.where((order) {
      return order.orderTime.year == today.year &&
          order.orderTime.month == today.month &&
          order.orderTime.day == today.day;
    }).toList();
  }

  // Get order statistics
  Map<String, dynamic> getOrderStatistics() {
    final totalOrders = orders.length;
    final assignedOrders = orders.where((o) => o.status == 'assigned').length;
    final outForDeliveryOrders = orders
        .where((o) => o.status == 'out_for_delivery')
        .length;
    final onTheWayOrders = orders.where((o) => o.status == 'on_the_way').length;
    final deliveredOrders = orders.where((o) => o.status == 'delivered').length;

    return {
      'total_orders': totalOrders,
      'assigned': assignedOrders,
      'out_for_delivery': outForDeliveryOrders,
      'on_the_way': onTheWayOrders,
      'delivered': deliveredOrders,
      'total_earnings': orders.fold(
        0.0,
        (sum, order) => sum + order.totalAmount,
      ),
    };
  }

  // Set user data from API login
  void setUserData(User user, Restaurant restaurant) {
    currentUser = user;
    currentRestaurant = restaurant;
    // fetchOrdersFromApi();
    // _ordersTimer?.cancel();
    // _ordersTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
    //   fetchOrdersFromApi();
    // });
    notifyListeners();
  }

  // Update order status
  void updateOrderStatus(String orderId, String newStatus) {
    final orderIndex = orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final order = orders[orderIndex];
      Order updatedOrder;

      switch (newStatus) {
        case 'out_for_delivery':
          updatedOrder = order.copyWith(
            status: newStatus,
            outForDeliveryTime:
                DateTime.now(), // You may need to update your model
          );
          break;
        case 'on_the_way':
          updatedOrder = order.copyWith(
            status: newStatus,
            onTheWayTime: DateTime.now(),
          );
          break;
        case 'delivered':
          updatedOrder = order.copyWith(
            status: newStatus,
            deliveredTime: DateTime.now(),
          );
          break;
        default:
          updatedOrder = order.copyWith(status: newStatus);
      }

      orders[orderIndex] = updatedOrder;
      notifyListeners();
    }
  }

  // Set selected status filter
  void setSelectedStatus(String status) {
    selectedStatus = status;
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  // Clear search query
  void clearSearch() {
    searchQuery = '';
    notifyListeners();
  }

  // Set current tab index
  void setCurrentTabIndex(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  // // Refresh orders (simulate API call)
  // Future<void> refreshOrders() async {
  //   await fetchOrdersFromApi();
  // }

  // Search orders
  List<Order> searchOrders(String query) {
    if (query.isEmpty) return orders;

    return orders.where((order) {
      return order.customerName.toLowerCase().contains(query.toLowerCase()) ||
          order.orderNumber.toLowerCase().contains(query.toLowerCase()) ||
          order.customerAddress.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Get next order to deliver
  Order? getNextOrderToDeliver() {
    final activeOrders = orders
        .where(
          (order) =>
              order.status == 'assigned' ||
              order.status == 'out_for_delivery' ||
              order.status == 'on_the_way',
        )
        .toList();

    if (activeOrders.isEmpty) return null;

    // Sort by priority: assigned > out_for_delivery > on_the_way, then by order time
    activeOrders.sort((a, b) {
      final statusPriority = {
        'assigned': 1,
        'out_for_delivery': 2,
        'on_the_way': 3,
      };

      final aPriority = statusPriority[a.status] ?? 4;
      final bPriority = statusPriority[b.status] ?? 4;

      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }

      return a.orderTime.compareTo(b.orderTime);
    });

    return activeOrders.first;
  }

  // Get orders count by status
  Map<String, int> getOrdersCountByStatus() {
    final counts = <String, int>{};
    counts['all'] = orders.length;
    counts['assigned'] = orders.where((o) => o.status == 'assigned').length;
    counts['out_for_delivery'] = orders
        .where((o) => o.status == 'out_for_delivery')
        .length;
    counts['on_the_way'] = orders.where((o) => o.status == 'on_the_way').length;
    counts['delivered'] = orders.where((o) => o.status == 'delivered').length;
    return counts;
  }

  // Get recent orders (last 5)
  List<Order> getRecentOrders() {
    final sortedOrders = List<Order>.from(orders);
    sortedOrders.sort((a, b) => b.orderTime.compareTo(a.orderTime));
    return sortedOrders.take(5).toList();
  }

  // Get urgent orders (assigned orders older than 30 minutes)
  List<Order> getUrgentOrders() {
    final thirtyMinutesAgo = DateTime.now().subtract(
      const Duration(minutes: 30),
    );
    return orders
        .where(
          (order) =>
              order.status == 'assigned' &&
              order.orderTime.isBefore(thirtyMinutesAgo),
        )
        .toList();
  }  // Clear all data (for logout)
  void clearData() {
    orders.clear();
    currentUser = null;
    currentRestaurant = null;
    selectedStatus = 'all';
    searchQuery = '';
    currentTabIndex = 0;
    _ordersTimer?.cancel();
    notifyListeners();
  }

  @override
  @override
  void dispose() {
    _ordersTimer?.cancel();
    super.dispose();
  }
}
