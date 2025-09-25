class User {
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String profileImage;
  final String vehicleNumber;
  final String vehicleType;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.profileImage,
    required this.vehicleNumber,
    required this.vehicleType,
    this.isActive = true,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userPhone: json['userPhone'] ?? '',
      profileImage: json['profileImage'],
      vehicleNumber: json['vehicleNumber'],
      vehicleType: json['vehicleType'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'profileImage': profileImage,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? profileImage,
    String? vehicleNumber,
    String? vehicleType,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      profileImage: profileImage ?? this.profileImage,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(userId: $userId, userName: $userName, userEmail: $userEmail, userPhone: $userPhone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
