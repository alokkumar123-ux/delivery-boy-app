import '../models/user.dart';
import '../models/restaurant.dart';
import '../models/order.dart';
import 'dart:math' as math;

class MockDataService {
  // Mock user data
  static User getMockUser() {
    return User(
      id: 'user_001',
      name: 'Shubrojoti Dey',
      email: 'alex.johnson@delivery.com',
      phone: '708XXXXXXX',
      profileImage: null,
      vehicleNumber: 'AS-1234',
      vehicleType: 'Motorcycle',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now(),
    );
  }

  // Mock restaurant data
  static Restaurant getMockRestaurant() {
    return Restaurant(
      id: 'rest_001',
      name: 'Burger Palace',
      address: '123 Main Street, Downtown Area, City',
      latitude: 24.864913,
      longitude: 92.359153,
      phone: '+1-555-9876',
      email: 'info@burgerpalace.com',
      logo: null,
      description: 'Delicious burgers and fast food',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    );
  }

  // Mock orders data
  static List<Order> getMockOrders() {
    final restaurant = getMockRestaurant();

    return [
      Order(
        id: 'ord_001',
        orderNumber: 'ORD-2024-001',
        customerName: 'Sarah Johnson',
        customerPhone: '6088521478',
        customerAddress: '456 Oak Street, Downtown Area, City',
        customerLatitude: 24.855364,
        customerLongitude: 92.491331,
        items: [
          OrderItem(
            id: 'item_001',
            name: 'Classic Burger Combo',
            quantity: 2,
            price: 12.99,
            notes: 'Extra cheese on one burger',
          ),
          OrderItem(
            id: 'item_002',
            name: 'French Fries',
            quantity: 1,
            price: 4.99,
            notes: null,
          ),
          OrderItem(
            id: 'item_003',
            name: 'Coca Cola',
            quantity: 2,
            price: 2.99,
            notes: null,
          ),
        ],
        totalAmount: 36.95,
        paymentMethod: 'Cash on Delivery',
        status: 'assigned',
        notes: 'Customer prefers contactless delivery',
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
        assignedTime: DateTime.now().subtract(const Duration(minutes: 10)),
        deliveryBoyId: 'user_001',
        distance: 1.2,
        estimatedTime: 15,
      ),

      Order(
        id: 'ord_002',
        orderNumber: 'ORD-2024-002',
        customerName: 'Mike Chen',
        customerPhone: '+1-555-2222',
        customerAddress: '789 Pine Avenue, West Side, City',
        customerLatitude: 24.855364,
        customerLongitude: 92.491331,
        items: [
          OrderItem(
            id: 'item_004',
            name: 'Chicken Sandwich',
            quantity: 1,
            price: 9.99,
            notes: 'No mayo, extra lettuce',
          ),
          OrderItem(
            id: 'item_005',
            name: 'Onion Rings',
            quantity: 1,
            price: 5.99,
            notes: null,
          ),
        ],
        totalAmount: 15.98,
        paymentMethod: 'Credit Card',
        status: 'picked_up',
        notes: null,
        orderTime: DateTime.now().subtract(const Duration(minutes: 45)),
        assignedTime: DateTime.now().subtract(const Duration(minutes: 40)),
        pickedUpTime: DateTime.now().subtract(const Duration(minutes: 20)),
        deliveryBoyId: 'user_001',
        distance: 2.1,
        estimatedTime: 25,
      ),

      Order(
        id: 'ord_003',
        orderNumber: 'ORD-2024-003',
        customerName: 'Emily Davis',
        customerPhone: '+1-555-3333',
        customerAddress: '321 Elm Street, North District, City',
        customerLatitude: 24.855364,
        customerLongitude: 92.491331,
        items: [
          OrderItem(
            id: 'item_006',
            name: 'Veggie Burger',
            quantity: 1,
            price: 11.99,
            notes: 'Gluten-free bun',
          ),
          OrderItem(
            id: 'item_007',
            name: 'Sweet Potato Fries',
            quantity: 1,
            price: 6.99,
            notes: null,
          ),
          OrderItem(
            id: 'item_008',
            name: 'Iced Tea',
            quantity: 1,
            price: 3.99,
            notes: 'Unsweetened',
          ),
        ],
        totalAmount: 22.97,
        paymentMethod: 'Cash on Delivery',
        status: 'on_the_way',
        notes: 'Customer will meet at gate',
        orderTime: DateTime.now().subtract(const Duration(hours: 1)),
        assignedTime: DateTime.now().subtract(const Duration(minutes: 55)),
        pickedUpTime: DateTime.now().subtract(const Duration(minutes: 30)),
        onTheWayTime: DateTime.now().subtract(const Duration(minutes: 25)),
        deliveryBoyId: 'user_001',
        distance: 3.5,
        estimatedTime: 35,
      ),

      Order(
        id: 'ord_004',
        orderNumber: 'ORD-2024-004',
        customerName: 'David Wilson',
        customerPhone: '+1-555-4444',
        customerAddress: '654 Maple Drive, East End, City',
        customerLatitude: 24.855364,
        customerLongitude: 92.491331,
        items: [
          OrderItem(
            id: 'item_009',
            name: 'Double Cheeseburger',
            quantity: 1,
            price: 15.99,
            notes: 'Extra bacon',
          ),
          OrderItem(
            id: 'item_010',
            name: 'Mozzarella Sticks',
            quantity: 1,
            price: 7.99,
            notes: null,
          ),
          OrderItem(
            id: 'item_011',
            name: 'Milkshake',
            quantity: 1,
            price: 4.99,
            notes: 'Chocolate flavor',
          ),
        ],
        totalAmount: 28.97,
        paymentMethod: 'Credit Card',
        status: 'delivered',
        notes: 'Delivered successfully',
        orderTime: DateTime.now().subtract(const Duration(hours: 2)),
        assignedTime: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 55),
        ),
        pickedUpTime: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 30),
        ),
        onTheWayTime: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 25),
        ),
        deliveredTime: DateTime.now().subtract(const Duration(minutes: 30)),
        deliveryBoyId: 'user_001',
        distance: 1.8,
        estimatedTime: 20,
      ),

      Order(
        id: 'ord_005',
        orderNumber: 'ORD-2024-005',
        customerName: 'Lisa Anderson',
        customerPhone: '+1-555-5555',
        customerAddress: '987 Cedar Lane, South Quarter, City',
        customerLatitude: 24.855364,
        customerLongitude: 92.491331,
        items: [
          OrderItem(
            id: 'item_012',
            name: 'Fish Fillet Sandwich',
            quantity: 1,
            price: 13.99,
            notes: 'Tartar sauce on the side',
          ),
          OrderItem(
            id: 'item_013',
            name: 'Coleslaw',
            quantity: 1,
            price: 3.99,
            notes: null,
          ),
          OrderItem(
            id: 'item_014',
            name: 'Lemonade',
            quantity: 1,
            price: 3.99,
            notes: null,
          ),
        ],
        totalAmount: 21.97,
        paymentMethod: 'Cash on Delivery',
        status: 'assigned',
        notes: 'Customer prefers evening delivery',
        orderTime: DateTime.now().subtract(const Duration(minutes: 5)),
        assignedTime: DateTime.now().subtract(const Duration(minutes: 2)),
        deliveryBoyId: 'user_001',
        distance: 4.2,
        estimatedTime: 45,
      ),
    ];
  }

  // Get orders by status
  static List<Order> getOrdersByStatus(String status) {
    return getMockOrders().where((order) => order.status == status).toList();
  }

  // Get today's orders
  static List<Order> getTodayOrders() {
    final today = DateTime.now();
    return getMockOrders().where((order) {
      return order.orderTime.year == today.year &&
          order.orderTime.month == today.month &&
          order.orderTime.day == today.day;
    }).toList();
  }

  // Get order statistics
  static Map<String, dynamic> getOrderStatistics() {
    final orders = getMockOrders();
    final totalOrders = orders.length;
    final assignedOrders = orders.where((o) => o.status == 'assigned').length;
    final pickedUpOrders = orders.where((o) => o.status == 'picked_up').length;
    final onTheWayOrders = orders.where((o) => o.status == 'on_the_way').length;
    final deliveredOrders = orders.where((o) => o.status == 'delivered').length;

    return {
      'total_orders': totalOrders,
      'assigned': assignedOrders,
      'picked_up': pickedUpOrders,
      'on_the_way': onTheWayOrders,
      'delivered': deliveredOrders,
      'total_earnings': orders.fold(
        0.0,
        (sum, order) => sum + order.totalAmount,
      ),
    };
  }

  // Search orders
  static List<Order> searchOrders(String query) {
    final orders = getMockOrders();
    final lowercaseQuery = query.toLowerCase();

    return orders.where((order) {
      return order.customerName.toLowerCase().contains(lowercaseQuery) ||
          order.orderNumber.toLowerCase().contains(lowercaseQuery) ||
          order.customerAddress.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get route information (mock)
  static Map<String, dynamic> getMockRouteInfo(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    // Calculate mock distance and time
    final distance = _calculateMockDistance(startLat, startLng, endLat, endLng);
    final duration = (distance * 2).round(); // Mock: 2 minutes per km

    return {
      'distance': distance,
      'duration': duration,
      'polyline': [
        {'lat': startLat, 'lng': startLng},
        {'lat': (startLat + endLat) / 2, 'lng': (startLng + endLng) / 2},
        {'lat': endLat, 'lng': endLng},
      ],
    };
  }

  // Mock distance calculation
  static double _calculateMockDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    // Simple distance calculation for demo purposes
    final dLat = (lat2 - lat1) * 111000; // 1 degree = 111km
    final dLng = (lng2 - lng1) * 111000 * math.cos(lat1 * math.pi / 180);
    return math.sqrt(dLat * dLat + dLng * dLng) / 1000; // Convert to km
  }

  // Get mock notifications
  static List<Map<String, dynamic>> getMockNotifications() {
    return [
      {
        'id': 'notif_001',
        'title': 'New Order Assigned',
        'message': 'Order ORD-2024-005 has been assigned to you',
        'type': 'order_assigned',
        'isRead': false,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 2)),
      },
      {
        'id': 'notif_002',
        'title': 'Order Picked Up',
        'message': 'Order ORD-2024-002 has been picked up successfully',
        'type': 'order_picked_up',
        'isRead': true,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
      },
      {
        'id': 'notif_003',
        'title': 'Order Delivered',
        'message': 'Order ORD-2024-004 has been delivered successfully',
        'type': 'order_delivered',
        'isRead': true,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      },
    ];
  }

  // Get mock earnings
  static Map<String, dynamic> getMockEarnings({
    String? period,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final orders = getMockOrders();
    final deliveredOrders = orders
        .where((o) => o.status == 'delivered')
        .toList();

    final totalEarnings = deliveredOrders.fold(
      0.0,
      (sum, order) => sum + order.totalAmount,
    );
    final totalOrders = deliveredOrders.length;
    final averageEarnings = totalOrders > 0 ? totalEarnings / totalOrders : 0.0;

    return {
      'total_earnings': totalEarnings,
      'total_orders': totalOrders,
      'average_per_order': averageEarnings,
      'period': period ?? 'today',
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }
}
