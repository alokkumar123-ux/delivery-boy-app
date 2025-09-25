import 'dart:async';
import 'package:boy_boy/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/constants.dart';
import '../models/order.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  final Order order;
  final Restaurant restaurant;

  const MapScreen({super.key, required this.order, required this.restaurant});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final LocationService _locationService = LocationService.instance;

  Position? _currentPosition;
  RouteInfo? _routeInfo;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  StreamSubscription<Position>? _positionSubscription;
  Timer? _updateTimer;

  bool _isLoading = true;
  String _distanceToRestaurant = '';
  String _distanceToCustomer = '';
  String _estimatedArrival = '';

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _updateTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      // Get current location
      _currentPosition = await _locationService.getCurrentLocation();

      if (_currentPosition != null) {
        // Start real-time location tracking
        _positionSubscription = _locationService.startLocationTracking().listen(
          (position) {
            _updateCurrentPosition(position);
          },
        );

        // Get route from restaurant to customer
        await _getRoute();

        // Setup markers
        _setupMarkers();

        // Start periodic updates
        _startPeriodicUpdates();

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getRoute() async {
    if (_currentPosition == null) return;

    _routeInfo = await _locationService.getRoute(
      startLat: widget.restaurant.latitude,
      startLng: widget.restaurant.longitude,
      endLat: widget.order.customerLatitude,
      endLng: widget.order.customerLongitude,
    );

    if (_routeInfo != null) {
      _setupPolyline();
      _calculateDistances();
    }
  }

  void _setupMarkers() {
    _markers = {
      // Restaurant marker
      Marker(
        markerId: const MarkerId('restaurant'),
        position: LatLng(
          widget.restaurant.latitude,
          widget.restaurant.longitude,
        ),
        infoWindow: InfoWindow(
          title: widget.restaurant.name,
          snippet: 'Restaurant Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),

      // Customer marker
      Marker(
        markerId: const MarkerId('customer'),
        position: LatLng(
          widget.order.customerLatitude,
          widget.order.customerLongitude,
        ),
        infoWindow: InfoWindow(
          title: widget.order.customerName,
          snippet: widget.order.customerAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),

      // Current position marker
      if (_currentPosition != null)
        Marker(
          markerId: const MarkerId('current_position'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Delivery Boy Position',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
    };
  }

  void _setupPolyline() {
    if (_routeInfo == null) return;

    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: _routeInfo!.polylinePoints,
        color: AppColors.primaryOrange,
        width: 5,
        patterns: [],
      ),
    };
  }

  void _updateCurrentPosition(Position position) {
    if (mounted) {
      setState(() {
        _currentPosition = position;
        _setupMarkers();
        _calculateDistances();
      });
    }

    // Update camera position to follow current location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );
    }
  }

  void _calculateDistances() async {
    if (_currentPosition == null) return;

    try {
      // Use Distance Matrix API for accurate distances
      final distances = await _locationService
          .getDistancesToMultipleDestinations(
            origin: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            destinations: [
              LatLng(widget.restaurant.latitude, widget.restaurant.longitude),
              LatLng(
                widget.order.customerLatitude,
                widget.order.customerLongitude,
              ),
            ],
          );

      if (distances != null && distances.length >= 2) {
        if (mounted) {
          setState(() {
            _distanceToRestaurant = distances[0].distance;
            _distanceToCustomer = distances[1].distance;

            if (_routeInfo != null) {
              _estimatedArrival = _locationService.getEstimatedArrival(
                _routeInfo!.durationValue,
              );
            }
          });
        }
      }
    } catch (e) {
      print('Error calculating distances: $e');
    }
  }

  void _startPeriodicUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _calculateDistances();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    if (_currentPosition != null) {
      // Fit all markers in view
      _fitMarkersInView();
    }
  }

  void _fitMarkersInView() {
    if (_mapController == null) return;

    List<LatLng> positions = [
      LatLng(widget.restaurant.latitude, widget.restaurant.longitude),
      LatLng(widget.order.customerLatitude, widget.order.customerLongitude),
      if (_currentPosition != null)
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
    ];

    if (positions.length >= 2) {
      double minLat = positions
          .map((p) => p.latitude)
          .reduce((a, b) => a < b ? a : b);
      double maxLat = positions
          .map((p) => p.latitude)
          .reduce((a, b) => a > b ? a : b);
      double minLng = positions
          .map((p) => p.longitude)
          .reduce((a, b) => a < b ? a : b);
      double maxLng = positions
          .map((p) => p.longitude)
          .reduce((a, b) => a > b ? a : b);

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          100.0, // padding
        ),
      );
    }
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
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingLarge.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingMedium.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Route',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Order #${widget.order.orderNumber}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Map Container
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(AppDimensions.paddingLarge.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusLarge.r,
                    ),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusLarge.r,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryOrange,
                            ),
                          )
                        : _currentPosition == null
                        ? Center(
                            child: Text(
                              'Unable to get location.\nPlease enable location services.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium,
                            ),
                          )
                        : GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                              zoom: 14.0,
                            ),
                            markers: _markers,
                            polylines: _polylines,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            mapType: MapType.normal,
                            zoomControlsEnabled: false,
                          ),
                  ),
                ),
              ),

              // Distance Info Panel
              Container(
                margin: EdgeInsets.fromLTRB(
                  AppDimensions.paddingLarge.w,
                  0,
                  AppDimensions.paddingLarge.w,
                  AppDimensions.paddingLarge.h,
                ),
                padding: EdgeInsets.all(AppDimensions.paddingLarge.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusLarge.r,
                  ),
                  boxShadow: AppShadows.cardShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDistanceCard(
                            'To Restaurant',
                            _distanceToRestaurant,
                            Icons.restaurant,
                            AppColors.statusAssigned,
                          ),
                        ),
                        SizedBox(width: AppDimensions.paddingMedium.w),
                        Expanded(
                          child: _buildDistanceCard(
                            'To Customer',
                            _distanceToCustomer,
                            Icons.location_on,
                            AppColors.statusDelivered,
                          ),
                        ),
                      ],
                    ),
                    if (_routeInfo != null) ...[
                      SizedBox(height: AppDimensions.paddingMedium.h),
                      Container(
                        padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMedium.r,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Route Distance',
                                  style: AppTextStyles.caption,
                                ),
                                Text(
                                  _routeInfo!.distance,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Duration', style: AppTextStyles.caption),
                                Text(
                                  _routeInfo!.duration,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text('ETA', style: AppTextStyles.caption),
                                Text(
                                  _estimatedArrival,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceCard(
    String title,
    String distance,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: AppDimensions.paddingSmall.h),
          Text(title, style: AppTextStyles.caption),
          Text(
            distance.isEmpty ? '...' : distance,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
