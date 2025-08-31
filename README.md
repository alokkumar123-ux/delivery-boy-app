# 🚴 Restaurant Delivery Boy Flutter App

A modern, beautiful Flutter mobile application designed for restaurant delivery boys to manage orders, track deliveries, and provide excellent customer service.

## ✨ Features

### 🔐 Authentication System
- **Modern Login Design**: Beautiful orange gradient background with floating white login card
- **Mock Authentication**: Use `delivery123` / `password` for demo login
- **Session Management**: JWT token storage simulation with shared preferences
- **Auto-login**: Remember user session with smooth transition animations

### 📋 Orders Management
- **Beautiful Order Cards**: Modern rounded white cards with subtle shadows
- **Status Tracking**: Real-time order status updates (Assigned → Picked Up → On the Way → Delivered)
- **Search & Filter**: Find orders by customer name, order number, or address
- **Status Filtering**: Filter orders by current status
- **Pull to Refresh**: Refresh orders list with smooth animations

### 📱 Order Details
- **Comprehensive Information**: Customer details, order items, payment method, and notes
- **Status Update Buttons**: Large, rounded gradient buttons for status changes
- **Modern UI**: Floating action cards with proper visual hierarchy
- **Responsive Design**: Works perfectly on all screen sizes

### 🗺️ Map Integration (Placeholder)
- **Google Maps Ready**: Basic structure for Google Maps integration
- **Route Visualization**: Placeholder for delivery route display
- **Location Tracking**: Ready for GPS integration

### 👤 Profile & Settings
- **User Information**: Display delivery boy details and vehicle information
- **Restaurant Details**: Show linked restaurant information
- **Statistics**: Order counts, earnings, and delivery metrics
- **Logout Functionality**: Secure logout with confirmation dialog

## 🎨 Design System

### Color Scheme
- **Primary**: #FF6B35 (Vibrant Orange)
- **Secondary**: #FF9500 (Golden Orange)
- **Background**: Gradient from #FF6B35 to #FF9500
- **Cards**: Pure White (#FFFFFF) with subtle shadows
- **Text**: Dark Gray (#2C2C2C) for headers, Medium Gray (#666666) for body

### Typography
- **Font Family**: Poppins (Regular, Medium, SemiBold, Bold)
- **Headers**: 18-24px, Bold
- **Body Text**: 14-16px, Regular
- **Captions**: 12px, Medium

### Components
- **Rounded Corners**: 20px border radius for cards, 16px for inputs
- **Shadows**: Subtle shadows with 15px blur and 0.1 opacity
- **Buttons**: Gradient backgrounds with rounded corners and shadows
- **Chips**: Rounded pill design for status and information display

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── user.dart                     # User/Delivery boy model
│   ├── restaurant.dart               # Restaurant model
│   └── order.dart                    # Order and OrderItem models
├── services/                          # Business logic
│   └── mock_data_service.dart        # Mock data for UI testing
├── providers/                         # State management
│   └── ui_state_provider.dart        # UI state provider using Provider
├── screens/                           # App screens
│   ├── login_screen.dart             # Beautiful login screen
│   ├── main_navigation_screen.dart   # Bottom navigation wrapper
│   ├── orders_screen.dart            # Orders list and management
│   ├── order_detail_screen.dart      # Detailed order view
│   ├── map_screen.dart               # Map integration placeholder
│   └── profile_screen.dart           # User profile and settings
├── widgets/                           # Reusable components
│   └── order_card.dart               # Beautiful order display card
└── utils/                             # Utilities and constants
    ├── constants.dart                 # Colors, text styles, dimensions
    └── helpers.dart                   # Helper functions and utilities
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd boy_boy
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Demo Login
Use these credentials to test the app:
- **Username**: `delivery123`
- **Password**: `password`

## 📱 App Screenshots

### Login Screen
- Full gradient background (Orange to Golden)
- Floating white login card with rounded corners
- Modern input fields with subtle borders
- Gradient login button with shadows

### Orders Screen
- Beautiful header with user info and notifications
- Search bar with rounded design
- Status filter chips with color coding
- Order cards with all essential information

### Order Details
- Large status card at top
- Floating action cards for different sections
- Status update buttons with gradients
- Modern confirmation dialogs

### Profile Screen
- User avatar and information
- Restaurant details
- Delivery statistics
- Settings and logout options

## 🔧 Technical Implementation

### State Management
- **Provider Pattern**: Clean state management with Provider package
- **Mock Data**: Realistic dummy data for UI testing
- **Local State**: Status updates work locally (no API calls)

### Navigation
- **Bottom Navigation**: Modern tab-based navigation
- **Page Transitions**: Smooth animations between screens
- **Deep Linking**: Ready for deep link implementation

### UI Components
- **Custom Widgets**: Reusable components with consistent design
- **Responsive Layout**: Works on all screen sizes
- **Accessibility**: Proper labels and contrast ratios

## 🎯 Future Enhancements

### Phase 1: API Integration
- Replace mock data with real API calls
- Implement JWT authentication
- Add real-time order updates

### Phase 2: Maps & Location
- Google Maps SDK integration
- Real-time GPS tracking
- Route optimization
- Distance and ETA calculations

### Phase 3: Advanced Features
- Push notifications
- Offline support
- Multi-language support
- Dark mode theme

## 🧪 Testing

### UI Testing
- All screens load and display properly
- Navigation works smoothly
- Status updates function correctly
- Responsive design on different screen sizes

### Mock Data Testing
- 5 sample orders with different statuses
- Realistic customer information
- Various order items and payment methods
- Different delivery distances and times

## 📋 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.0    # For map integration
  provider: ^6.1.1               # State management
  url_launcher: ^6.2.1           # Phone calls and links
  flutter_svg: ^2.0.9            # SVG support
  cached_network_image: ^3.3.0   # Image caching
  shimmer: ^3.0.0                # Loading animations
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🎉 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design inspiration
- Food delivery apps for UX reference
- Open source community for packages

---

**Note**: This is a UI-focused implementation using mock data. Real API integration, GPS tracking, and backend services will be implemented in future phases.
