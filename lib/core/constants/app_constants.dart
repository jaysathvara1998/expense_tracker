import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppConstants {
  // Default Categories
  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'name': 'Food',
      'color': 0xFFF44336, // Red
      'icon': Icons.restaurant,
      'isDefault': true,
    },
    {
      'name': 'Transport',
      'color': 0xFF2196F3, // Blue
      'icon': Icons.directions_car,
      'isDefault': true,
    },
    {
      'name': 'Entertainment',
      'color': 0xFF9C27B0, // Purple
      'icon': Icons.movie,
      'isDefault': true,
    },
    {
      'name': 'Shopping',
      'color': 0xFF4CAF50, // Green
      'icon': Icons.shopping_bag,
      'isDefault': true,
    },
    {
      'name': 'Utilities',
      'color': 0xFFFF9800, // Orange
      'icon': Icons.lightbulb,
      'isDefault': true,
    },
    {
      'name': 'Health',
      'color': 0xFF00BCD4, // Cyan
      'icon': Icons.medical_services,
      'isDefault': true,
    },
    {
      'name': 'Education',
      'color': 0xFF795548, // Brown
      'icon': Icons.school,
      'isDefault': true,
    },
  ];

  // Payment Modes
  static const List<String> paymentModes = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'UPI',
    'Net Banking',
    'Wallet',
    'Other',
  ];

  // Category Icons for selection
  static const List<IconData> categoryIcons = [
    Icons.restaurant,
    Icons.directions_car,
    Icons.movie,
    Icons.shopping_bag,
    Icons.lightbulb,
    Icons.medical_services,
    Icons.school,
    Icons.home,
    Icons.fitness_center,
    Icons.phone_android,
    Icons.card_giftcard,
    Icons.flight_takeoff,
    Icons.hotel,
    Icons.pets,
    Icons.sports_esports,
    Icons.book,
    Icons.coffee,
    Icons.child_care,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.car,
    FontAwesomeIcons.film,
    FontAwesomeIcons.bagShopping,
    FontAwesomeIcons.lightbulb,
    FontAwesomeIcons.hospital,
    FontAwesomeIcons.graduationCap,
    FontAwesomeIcons.house,
    FontAwesomeIcons.dumbbell,
    FontAwesomeIcons.mobileScreenButton,
    FontAwesomeIcons.gift,
    FontAwesomeIcons.plane,
    FontAwesomeIcons.hotel,
    FontAwesomeIcons.paw,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.book,
    FontAwesomeIcons.mugSaucer,
    FontAwesomeIcons.baby,
  ];

  // Category Colors for selection
  static const List<Color> categoryColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];
}
