import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../models/restaurant.dart';
import '../services/mock_data_service.dart';

class UIStateProvider extends ChangeNotifier {
  // Mock data
  List<Order> _orders = [];
  User? _currentUser;
  Restaurant? _currentRestaurant;
  String _selectedStatus = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  int _currentTabIndex = 0;

  // Getters
  List<Order> get orders => _orders;
  User? get currentUser => _currentUser;
  Restaurant? get currentRestaurant => _currentRestaurant;
  String get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  int get currentTabIndex => _currentTabIndex;

  // Filtered orders based on status only (search commented out)
  List<Order> get filteredOrders {
    List<Order> filtered = _orders;

    // Filter by status
    if (_selectedStatus != 'all') {
      filtered = filtered
          .where((order) => order.status == _selectedStatus)
          .toList();
    }

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
    return _orders.where((order) => order.status == status).toList();
  }

  // Get today's orders
  List<Order> getTodayOrders() {
    final today = DateTime.now();
    return _orders.where((order) {
      return order.orderTime.year == today.year &&
          order.orderTime.month == today.month &&
          order.orderTime.day == today.day;
    }).toList();
  }

  // Get order statistics
  Map<String, dynamic> getOrderStatistics() {
    final totalOrders = _orders.length;
    final assignedOrders = _orders.where((o) => o.status == 'assigned').length;
    final pickedUpOrders = _orders.where((o) => o.status == 'picked_up').length;
    final onTheWayOrders = _orders
        .where((o) => o.status == 'on_the_way')
        .length;
    final deliveredOrders = _orders
        .where((o) => o.status == 'delivered')
        .length;

    return {
      'total_orders': totalOrders,
      'assigned': assignedOrders,
      'picked_up': pickedUpOrders,
      'on_the_way': onTheWayOrders,
      'delivered': deliveredOrders,
      'total_earnings': _orders.fold(
        0.0,
        (sum, order) => sum + order.totalAmount,
      ),
    };
  }

  // Initialize mock data
  void initializeMockData() {
    _setLoading(true);

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _orders = MockDataService.getMockOrders();
      _currentUser = MockDataService.getMockUser();
      _currentRestaurant = MockDataService.getMockRestaurant();
      _setLoading(false);
    });
  }

  // Update order status
  void updateOrderStatus(String orderId, String newStatus) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      Order updatedOrder;

      switch (newStatus) {
        case 'picked_up':
          updatedOrder = order.copyWith(
            status: newStatus,
            pickedUpTime: DateTime.now(),
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

      _orders[orderIndex] = updatedOrder;
      notifyListeners();
    }
  }

  // Set selected status filter
  void setSelectedStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear search query
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Set current tab index
  void setCurrentTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // Refresh orders (simulate API call)
  Future<void> refreshOrders() async {
    _setLoading(true);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Refresh mock data
    _orders = MockDataService.getMockOrders();
    _setLoading(false);
  }

  // Search orders
  List<Order> searchOrders(String query) {
    if (query.isEmpty) return _orders;

    return _orders.where((order) {
      return order.customerName.toLowerCase().contains(query.toLowerCase()) ||
          order.orderNumber.toLowerCase().contains(query.toLowerCase()) ||
          order.customerAddress.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Get next order to deliver
  Order? getNextOrderToDeliver() {
    final activeOrders = _orders
        .where(
          (order) =>
              order.status == 'assigned' ||
              order.status == 'picked_up' ||
              order.status == 'on_the_way',
        )
        .toList();

    if (activeOrders.isEmpty) return null;

    // Sort by priority: assigned > picked_up > on_the_way, then by order time
    activeOrders.sort((a, b) {
      final statusPriority = {'assigned': 1, 'picked_up': 2, 'on_the_way': 3};

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
    counts['all'] = _orders.length;
    counts['assigned'] = _orders.where((o) => o.status == 'assigned').length;
    counts['picked_up'] = _orders.where((o) => o.status == 'picked_up').length;
    counts['on_the_way'] = _orders
        .where((o) => o.status == 'on_the_way')
        .length;
    counts['delivered'] = _orders.where((o) => o.status == 'delivered').length;
    return counts;
  }

  // Get recent orders (last 5)
  List<Order> getRecentOrders() {
    final sortedOrders = List<Order>.from(_orders);
    sortedOrders.sort((a, b) => b.orderTime.compareTo(a.orderTime));
    return sortedOrders.take(5).toList();
  }

  // Get urgent orders (assigned orders older than 30 minutes)
  List<Order> getUrgentOrders() {
    final thirtyMinutesAgo = DateTime.now().subtract(
      const Duration(minutes: 30),
    );
    return _orders
        .where(
          (order) =>
              order.status == 'assigned' &&
              order.orderTime.isBefore(thirtyMinutesAgo),
        )
        .toList();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Simulate new order notification
  void simulateNewOrder() {
    if (_orders.isNotEmpty) {
      final lastOrder = _orders.last;
      final newOrder = lastOrder.copyWith(
        id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
        orderNumber: 'ORD-2024-${_orders.length + 1}',
        customerName: 'New Customer ${_orders.length + 1}',
        customerPhone: '+1-555-${1000 + _orders.length + 1}',
        customerAddress: 'New Address ${_orders.length + 1}',
        status: 'assigned',
        orderTime: DateTime.now(),
        assignedTime: DateTime.now(),
      );

      _orders.insert(0, newOrder);
      notifyListeners();
    }
  }

  // Clear all data (for logout)
  void clearData() {
    _orders.clear();
    _currentUser = null;
    _currentRestaurant = null;
    _selectedStatus = 'all';
    _searchQuery = '';
    _currentTabIndex = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
