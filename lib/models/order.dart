import 'restaurant.dart';

class Order {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final double customerLatitude;
  final double customerLongitude;
  final List<OrderItem> items;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final String? notes;
  final DateTime orderTime;
  final DateTime? assignedTime;
  final DateTime? pickedUpTime;
  final DateTime? onTheWayTime;
  final DateTime? deliveredTime;
  final String deliveryBoyId;
  final double? distance;
  final int? estimatedTime;

  Order({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerLatitude,
    required this.customerLongitude,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    this.notes,
    required this.orderTime,
    this.assignedTime,
    this.pickedUpTime,
    this.onTheWayTime,
    this.deliveredTime,
    required this.deliveryBoyId,
    this.distance,
    this.estimatedTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      orderNumber: json['order_number'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      customerAddress: json['customer_address'] ?? '',
      customerLatitude: (json['customer_latitude'] ?? 0.0).toDouble(),
      customerLongitude: (json['customer_longitude'] ?? 0.0).toDouble(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'],
      orderTime: DateTime.parse(
        json['order_time'] ?? DateTime.now().toIso8601String(),
      ),
      assignedTime: json['assigned_time'] != null
          ? DateTime.parse(json['assigned_time'])
          : null,
      pickedUpTime: json['picked_up_time'] != null
          ? DateTime.parse(json['picked_up_time'])
          : null,
      onTheWayTime: json['on_the_way_time'] != null
          ? DateTime.parse(json['on_the_way_time'])
          : null,
      deliveredTime: json['delivered_time'] != null
          ? DateTime.parse(json['delivered_time'])
          : null,
      deliveryBoyId: json['delivery_boy_id'] ?? '',
      distance: json['distance']?.toDouble(),
      estimatedTime: json['estimated_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
      'customer_latitude': customerLatitude,
      'customer_longitude': customerLongitude,
      'items': items.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'status': status,
      'notes': notes,
      'order_time': orderTime.toIso8601String(),
      'assigned_time': assignedTime?.toIso8601String(),
      'picked_up_time': pickedUpTime?.toIso8601String(),
      'on_the_way_time': onTheWayTime?.toIso8601String(),
      'delivered_time': deliveredTime?.toIso8601String(),
      'delivery_boy_id': deliveryBoyId,
      'distance': distance,
      'estimated_time': estimatedTime,
    };
  }

  Order copyWith({
    String? id,
    String? orderNumber,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    double? customerLatitude,
    double? customerLongitude,
    List<OrderItem>? items,
    double? totalAmount,
    String? paymentMethod,
    String? status,
    String? notes,
    DateTime? orderTime,
    DateTime? assignedTime,
    DateTime? pickedUpTime,
    DateTime? onTheWayTime,
    DateTime? deliveredTime,
    Restaurant? restaurant,
    String? deliveryBoyId,
    double? distance,
    int? estimatedTime,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      customerLatitude: customerLatitude ?? this.customerLatitude,
      customerLongitude: customerLongitude ?? this.customerLongitude,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      orderTime: orderTime ?? this.orderTime,
      assignedTime: assignedTime ?? this.assignedTime,
      pickedUpTime: pickedUpTime ?? this.pickedUpTime,
      onTheWayTime: onTheWayTime ?? this.onTheWayTime,
      deliveredTime: deliveredTime ?? this.deliveredTime,
      deliveryBoyId: deliveryBoyId ?? this.deliveryBoyId,
      distance: distance ?? this.distance,
      estimatedTime: estimatedTime ?? this.estimatedTime,
    );
  }

  bool get isAssigned => status == 'assigned';
  bool get isPickedUp => status == 'picked_up';
  bool get isOnTheWay => status == 'on_the_way';
  bool get isDelivered => status == 'delivered';

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, customerName: $customerName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? notes;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'notes': notes,
    };
  }

  double get totalPrice => price * quantity;

  @override
  String toString() {
    return 'OrderItem(name: $name, quantity: $quantity, price: $price)';
  }
}
