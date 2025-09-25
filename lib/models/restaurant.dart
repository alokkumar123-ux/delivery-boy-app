class Restaurant {
  final int restaurantId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String? email;
  final String? logo;
  final String? description;
  final bool isActive;
  final DateTime createdAt;

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.email,
    this.logo,
    this.description,
    this.isActive = true,
    required this.createdAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantId: json['restaurantId'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      phone: json['phone'] ?? '',
      email: json['email'],
      logo: json['logo'],
      description: json['description'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'logo': logo,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Restaurant copyWith({
    int? restaurantId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    String? logo,
    String? description,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Restaurant(
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      logo: logo ?? this.logo,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Restaurant(restaurantId: $restaurantId, name: $name, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Restaurant && other.restaurantId == restaurantId;
  }

  @override
  int get hashCode => restaurantId.hashCode;
}
