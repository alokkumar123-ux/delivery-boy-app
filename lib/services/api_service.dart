import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/restaurant.dart';

// Login response model
class LoginResponse {
  final String status;
  final String message;
  final User user;
  final Restaurant restaurant;

  LoginResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.restaurant,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      user: User(
        userId: json['userId'] ?? '',
        userName: json['userName'] ?? '',
        userEmail: json['userEmail'] ?? '',
        userPhone: json['userPhone'] ?? '',
        profileImage: json['profileImage'] ?? '',
        vehicleNumber: json['vehicleNumber'] ?? '',
        vehicleType: json['vehicleType'] ?? '',
        createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
      ),
      restaurant: Restaurant.fromJson(json['restaurant'] ?? {}),
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://resto.swaadpos.in/api';

  // Delivery login
  static Future<LoginResponse> deliveryLogin({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delivery-login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          return LoginResponse.fromJson(responseData);
        } else {
          throw Exception(responseData['message'] ?? 'Login failed');
        }
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> markAsDelivered(
    String orderId,
    String deliveryBoyId,
  ) async {
    final url = Uri.parse("$baseUrl/delivery-executives/markAsDelivered");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "order_id": orderId.replaceAll("ord_", ""),
          "delivery_boy_id": deliveryBoyId.replaceAll("user_", ""),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
          "Failed to mark as delivered. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  // Added: Mark as out for delivery method
  static Future<Map<String, dynamic>> markOutForDelivery(
    String orderId,
    String deliveryBoyId,
  ) async {
    final url = Uri.parse(
      "$baseUrl/delivery-executives/markOutForDelivery"
      "?order_id=${orderId.replaceAll("ord_", "")}"
      "&delivery_boy_id=${deliveryBoyId.replaceAll("user_", "")}",
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
          "Failed to mark as out for delivery. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }
}
