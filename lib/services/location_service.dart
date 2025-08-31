import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static const String _googleMapsApiKey = 'AIzaSyCh0-Sb30pVZ7d1Tz39s_zn-QBDFddxnCk';
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();
  
  LocationService._();

  StreamController<Position>? _positionController;
  StreamSubscription<Position>? _positionSubscription;
  Position? _currentPosition;

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      _currentPosition = position;
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Start real-time location tracking
  Stream<Position> startLocationTracking() {
    _positionController ??= StreamController<Position>.broadcast();
    
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _currentPosition = position;
      _positionController?.add(position);
    });

    return _positionController!.stream;
  }

  /// Stop location tracking
  void stopLocationTracking() {
    _positionSubscription?.cancel();
    _positionController?.close();
    _positionSubscription = null;
    _positionController = null;
  }

  /// Format distance from meters to readable string
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  /// Get distance matrix for multiple destinations using Google Distance Matrix API
  Future<DistanceMatrixResult?> getDistanceMatrix({
    required List<LatLng> origins,
    required List<LatLng> destinations,
    String units = 'metric',
    String mode = 'driving',
  }) async {
    try {
      // Convert coordinates to string format
      String originsStr = origins.map((point) => '${point.latitude},${point.longitude}').join('|');
      String destinationsStr = destinations.map((point) => '${point.latitude},${point.longitude}').join('|');
      
      final String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?'
          'origins=$originsStr'
          '&destinations=$destinationsStr'
          '&units=$units'
          '&mode=$mode'
          '&key=$_googleMapsApiKey';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          return DistanceMatrixResult.fromJson(data);
        }
      }
    } catch (e) {
      print('Error getting distance matrix: $e');
    }
    return null;
  }

  /// Get route between two points using Google Directions API
  Future<RouteInfo?> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=$startLat,$startLng'
          '&destination=$endLat,$endLng'
          '&key=$_googleMapsApiKey';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];
          
          // Decode polyline points
          final String encodedPolyline = route['overview_polyline']['points'];
          final List<LatLng> polylinePoints = _decodePolyline(encodedPolyline);
          
          return RouteInfo(
            polylinePoints: polylinePoints,
            distance: leg['distance']['text'],
            duration: leg['duration']['text'],
            distanceValue: leg['distance']['value'].toDouble(),
            durationValue: leg['duration']['value'].toDouble(),
          );
        }
      }
    } catch (e) {
      print('Error getting route: $e');
    }
    return null;
  }

  /// Get distances from current location to multiple destinations efficiently
  Future<List<DistanceInfo>?> getDistancesToMultipleDestinations({
    required LatLng origin,
    required List<LatLng> destinations,
  }) async {
    final result = await getDistanceMatrix(
      origins: [origin],
      destinations: destinations,
    );
    
    if (result != null && result.rows.isNotEmpty) {
      final row = result.rows[0];
      List<DistanceInfo> distances = [];
      
      for (int i = 0; i < row.elements.length; i++) {
        final element = row.elements[i];
        if (element.status == 'OK') {
          distances.add(DistanceInfo(
            destinationIndex: i,
            distance: element.distance.text,
            duration: element.duration.text,
            distanceValue: element.distance.value.toDouble(),
            durationValue: element.duration.value.toDouble(),
          ));
        }
      }
      return distances;
    }
    return null;
  }

  /// Decode polyline string to list of LatLng points
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylinePoints = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polylinePoints.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polylinePoints;
  }

  /// Get estimated time of arrival
  String getEstimatedArrival(double durationInSeconds) {
    final now = DateTime.now();
    final eta = now.add(Duration(seconds: durationInSeconds.round()));
    return '${eta.hour.toString().padLeft(2, '0')}:${eta.minute.toString().padLeft(2, '0')}';
  }

  /// Calculate bearing between two points
  double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    final double dLon = (lon2 - lon1) * pi / 180;
    final double lat1Rad = lat1 * pi / 180;
    final double lat2Rad = lat2 * pi / 180;
    
    final double y = sin(dLon) * cos(lat2Rad);
    final double x = cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(dLon);
    
    final double bearing = atan2(y, x) * 180 / pi;
    return (bearing + 360) % 360;
  }

  /// Get current position (cached)
  Position? get currentPosition => _currentPosition;

  /// Dispose resources
  void dispose() {
    stopLocationTracking();
  }
}

class RouteInfo {
  final List<LatLng> polylinePoints;
  final String distance;
  final String duration;
  final double distanceValue;
  final double durationValue;

  RouteInfo({
    required this.polylinePoints,
    required this.distance,
    required this.duration,
    required this.distanceValue,
    required this.durationValue,
  });
}

class LocationData {
  final double latitude;
  final double longitude;
  final String address;
  final DateTime timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
  });
}

class DistanceMatrixResult {
  final List<DistanceMatrixRow> rows;
  final String status;

  DistanceMatrixResult({
    required this.rows,
    required this.status,
  });

  factory DistanceMatrixResult.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixResult(
      rows: (json['rows'] as List<dynamic>)
          .map((row) => DistanceMatrixRow.fromJson(row))
          .toList(),
      status: json['status'] ?? '',
    );
  }
}

class DistanceMatrixRow {
  final List<DistanceMatrixElement> elements;

  DistanceMatrixRow({required this.elements});

  factory DistanceMatrixRow.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixRow(
      elements: (json['elements'] as List<dynamic>)
          .map((element) => DistanceMatrixElement.fromJson(element))
          .toList(),
    );
  }
}

class DistanceMatrixElement {
  final DistanceValue distance;
  final DurationValue duration;
  final String status;

  DistanceMatrixElement({
    required this.distance,
    required this.duration,
    required this.status,
  });

  factory DistanceMatrixElement.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixElement(
      distance: DistanceValue.fromJson(json['distance'] ?? {}),
      duration: DurationValue.fromJson(json['duration'] ?? {}),
      status: json['status'] ?? '',
    );
  }
}

class DistanceValue {
  final String text;
  final int value;

  DistanceValue({required this.text, required this.value});

  factory DistanceValue.fromJson(Map<String, dynamic> json) {
    return DistanceValue(
      text: json['text'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

class DurationValue {
  final String text;
  final int value;

  DurationValue({required this.text, required this.value});

  factory DurationValue.fromJson(Map<String, dynamic> json) {
    return DurationValue(
      text: json['text'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

class DistanceInfo {
  final int destinationIndex;
  final String distance;
  final String duration;
  final double distanceValue;
  final double durationValue;

  DistanceInfo({
    required this.destinationIndex,
    required this.distance,
    required this.duration,
    required this.distanceValue,
    required this.durationValue,
  });
}
