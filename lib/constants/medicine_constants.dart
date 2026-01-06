// lib/constants/medicine_constants.dart
import 'package:flutter/material.dart';

class MedicineConstants {
  // Static categories list - won't change at runtime
  static final List<Map<String, dynamic>> categories = [
    {'id': 'all', 'label': 'All'},
    {'id': 'painkillers', 'label': 'Painkillers'},
    {'id': 'antibiotics', 'label': 'Antibiotics'},
    {'id': 'vitamins', 'label': 'Vitamins'},
    {'id': 'chronic', 'label': 'Chronic'},
    {'id': 'other', 'label': 'Other'},
  ];

  // Categories for donation form (excluding 'all')
  static final List<Map<String, dynamic>> donationCategories = [
    {'id': 'painkillers', 'label': 'Painkillers'},
    {'id': 'antibiotics', 'label': 'Antibiotics'},
    {'id': 'vitamins', 'label': 'Vitamins'},
    {'id': 'chronic', 'label': 'Chronic'},
    {'id': 'other', 'label': 'Other'},
  ];

  // Medicine-themed colors
  static const Color medicineColor = Color(0xFF8E44AD);
  static const Color medicineLightColor = Color(0xFFF3E5F5);
  static const Color medicineForegroundColor = Colors.white;

  // Form field labels
  static const Map<String, String> donationFormLabels = {
    'medicineName': 'Medicine Name',
    'genericName': 'Generic Name',
    'category': 'Category',
    'quantity': 'Quantity',
    'expiryDate': 'Expiry Date',
    'description': 'Description',
    'pickupAddress': 'Pickup Address',
  };

  // Guidelines for donation
  static final List<String> donationGuidelines = [
    'Medicine must have at least 3 months before expiry',
    'Original packaging required',
    'Prescription medicines need pharmacist approval',
    'No controlled substances',
  ];

  // Get category label by ID
  static String getCategoryLabel(String categoryId) {
    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'id': 'other', 'label': 'Other'},
    );
    return category['label'];
  }
}
