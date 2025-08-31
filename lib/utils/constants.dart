import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color secondaryOrange = Color(0xFFFF9500);

  // Background Colors
  static const Color backgroundGradientStart = Color(0xFFFF6B35);
  static const Color backgroundGradientEnd = Color(0xFFFF9500);

  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textCaption = Color(0xFF050505);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color statusAssigned = Color(0xFFFFA726);
  static const Color statusPickedUp = Color(0xFF2196F3);
  static const Color statusOnTheWay = Color(0xFFFF9800);
  static const Color statusDelivered = Color(0xFF4CAF50);
  static const Color statusError = Color(0xFFF44336);

  // Other Colors
  static const Color chipBackground = Color(0xFFF5F5F5);
  static const Color borderColor = Color(0xFFE0E0E0);
}

class AppTextStyles {
  // Headers
  static const TextStyle header1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle header2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle header3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textCaption,
  );

  // Button Text
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  // Caption Text
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textCaption,
  );
}

class AppDimensions {
  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 20.0;
  static const double paddingXLarge = 24.0;
  static const double paddingXXLarge = 32.0;

  // Margins
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 20.0;
  static const double marginXLarge = 24.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 24.0;
  static const double radiusXXLarge = 28.0;

  // Button Heights
  static const double buttonHeight = 56.0;
  static const double buttonHeightSmall = 48.0;

  // Card Elevation
  static const double cardElevation = 5.0;
  static const double cardElevationLarge = 8.0;
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      AppColors.backgroundGradientStart,
      AppColors.backgroundGradientEnd,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppShadows {
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.cardShadow,
      blurRadius: 15,
      offset: Offset(0, 5),
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: AppColors.primaryOrange,
      blurRadius: 10,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
}
