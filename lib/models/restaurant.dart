class Restaurant {
  final String id;
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
    required this.id,
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      phone: json['phone'] ?? '',
      email: json['email'],
      logo: json['logo'],
      description: json['description'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'logo': logo,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Restaurant copyWith({
    String? id,
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
      id: id ?? this.id,
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
    return 'Restaurant(id: $id, name: $name, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Restaurant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
