import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  // User information
  Map<String, dynamic> _userInfo = {
    'name': 'Muhammad Abdal',
    'email': 'abdal@example.com',
    'phone': '+92 300 1234567',
    'city': 'Lahore',
    'bloodType': 'A+',
    'isVerified': true,
    'memberSince': 'January 2024',
    'initials': 'MA',
  };

  // Edit dialog state
  bool _editDialogOpen = false;

  // User stats
  final List<Map<String, dynamic>> _userStats = [
    {
      'label': 'Blood Donations',
      'value': 8,
      'icon': Icons.water_drop,
      'color': Color(0xFFE53935),
    },
    {
      'label': 'Medicines Shared',
      'value': 12,
      'icon': Icons.medication,
      'color': Color(0xFF8E44AD),
    },
    {
      'label': 'Lives Impacted',
      'value': 24,
      'icon': Icons.favorite,
      'color': Color(0xFF00A89D),
    },
  ];

  // Badges
  final List<Map<String, dynamic>> _badges = [
    {'name': 'First Donation', 'icon': '🩸', 'earned': true},
    {'name': 'Life Saver', 'icon': '💝', 'earned': true},
    {'name': 'Medicine Hero', 'icon': '💊', 'earned': true},
    {'name': 'Platinum Donor', 'icon': '🏆', 'earned': false},
  ];

  // Menu items
  final List<Map<String, dynamic>> _menuItems = [
    {
      'label': 'Edit Profile',
      'icon': Icons.person_outline,
      'route': '/edit-profile',
    },
    {
      'label': 'Notification Settings',
      'icon': Icons.notifications_none,
      'route': '/notifications',
    },
    {
      'label': 'Privacy & Security',
      'icon': Icons.shield_outlined,
      'route': '/privacy',
    },
    {
      'label': 'Donation History',
      'icon': Icons.description_outlined,
      'route': '/donation-history',
    },
    {'label': 'Help & Support', 'icon': Icons.help_outline, 'route': '/help'},
  ];

  // Next donation eligibility
  final String _nextDonationDate = 'January 15, 2025';

  // App version
  final String _appVersion = 'LifeLink Pakistan v1.0.0';

  // Getters
  Map<String, dynamic> get userInfo => _userInfo;
  bool get editDialogOpen => _editDialogOpen;
  List<Map<String, dynamic>> get userStats => _userStats;
  List<Map<String, dynamic>> get badges => _badges;
  List<Map<String, dynamic>> get menuItems => _menuItems;
  String get nextDonationDate => _nextDonationDate;
  String get appVersion => _appVersion;

  // Dialog actions
  void openEditDialog() {
    _editDialogOpen = true;
    notifyListeners();
  }

  void closeEditDialog() {
    _editDialogOpen = false;
    notifyListeners();
  }

  void updateProfile(Map<String, dynamic> newInfo) {
    _userInfo = {..._userInfo, ...newInfo};
    notifyListeners();
  }

  void logout() {
    // Clear any user data here
    notifyListeners();
  }
}
