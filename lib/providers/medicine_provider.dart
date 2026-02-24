import 'dart:async';

import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import '../repositories/medicine_repository.dart';
import 'auth_provider.dart';

class MedicineProvider with ChangeNotifier {
  final MedicineRepository _repository = MedicineRepository();

  // UI State
  String _selectedCategory = 'all';
  String _activeTab = 'find';
  bool _donateDialogOpen = false;
  bool _isLoading = false;

  // Donation form data
  Map<String, dynamic> _donationFormData = {
    'medicineName': '',
    'genericName': '',
    'category': 'other',
    'quantity': '',
    'expiryDate': '',
    'description': '',
    'pickupAddress': '',
  };

  // User info - now reactive to AuthProvider
  String? _currentUserId;
  String? _currentUserName;

  // Getters for user info
  String? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;
  bool get isUserLoggedIn => _currentUserId != null;

  // Medicine list
  List<MedicineModel> _medicines = [];

  // Stream subscription
  StreamSubscription<List<MedicineModel>>? _medicinesSubscription;

  // Auth listener for cleanup
  VoidCallback? _authListener;

  // Getters
  String get selectedCategory => _selectedCategory;
  String get activeTab => _activeTab;
  bool get donateDialogOpen => _donateDialogOpen;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get donationFormData => _donationFormData;

  // Get medicines in UI format
  List<Map<String, dynamic>> get medicines {
    return _medicines.map((medicine) => medicine.toUIData()).toList();
  }

  // Get filtered medicines
  List<Map<String, dynamic>> get filteredMedicines {
    if (_selectedCategory == 'all') {
      return medicines;
    }
    return medicines
        .where((medicine) => medicine['category'] == _selectedCategory)
        .toList();
  }

  // Initialize method
  void initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Listen to Firestore stream
      _medicinesSubscription = _repository.getMedicines().listen(
        (medicines) {
          if (medicines.isNotEmpty) {
            _medicines = medicines;
          } else {
            _medicines = _repository.getSampleMedicines();
          }
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Firestore error: $error');
          _medicines = _repository.getSampleMedicines();
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('Error initializing: $e');
      _medicines = _repository.getSampleMedicines();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user info from AuthProvider
  void updateUserInfo(String? userId, String? userName) {
    final hasChanged = _currentUserId != userId || _currentUserName != userName;
    if (hasChanged) {
      _currentUserId = userId;
      _currentUserName = userName;
      debugPrint('MedicineProvider: User info updated - $userName ($userId)');
      notifyListeners();
    }
  }

  // Set auth listener for cleanup
  void setAuthListener(VoidCallback listener) {
    _authListener = listener;
  }

  // Clear user info (called on logout)
  void clearUserInfo() {
    if (_currentUserId != null || _currentUserName != null) {
      _currentUserId = null;
      _currentUserName = null;
      debugPrint('MedicineProvider: User info cleared');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _medicinesSubscription?.cancel();
    // Clean up auth listener to prevent memory leak
    _authListener = null;
    super.dispose();
  }

  // Actions
  void selectCategory(String categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void selectFindTab() {
    _activeTab = 'find';
    notifyListeners();
  }

  void selectDonateTab() {
    _activeTab = 'donate';
    notifyListeners();
  }

  void openDonateDialog() {
    _donateDialogOpen = true;
    notifyListeners();
  }

  void closeDonateDialog() {
    _donateDialogOpen = false;
    _clearFormData();
    notifyListeners();
  }

  void updateDonationFormField(String field, dynamic value) {
    // Change to dynamic
    _donationFormData[field] = value;
    notifyListeners();
  }

  /// Validate form data before submission
  /// Returns error message if validation fails, null otherwise
  String? validateFormData() {
    // Check required fields
    final medicineName = _donationFormData['medicineName'] as String?;
    if (medicineName == null || medicineName.trim().isEmpty) {
      return 'Medicine name is required';
    }

    final quantityStr = _donationFormData['quantity'] as String?;
    if (quantityStr == null || quantityStr.trim().isEmpty) {
      return 'Quantity is required';
    }

    final quantity = int.tryParse(quantityStr);
    if (quantity == null || quantity <= 0) {
      return 'Quantity must be a positive number';
    }

    final expiryDate = _donationFormData['expiryDate'] as String?;
    if (expiryDate == null || expiryDate.trim().isEmpty) {
      return 'Expiry date is required';
    }

    // Validate expiry date format (MM/YYYY)
    final expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/\d{4}$');
    if (!expiryRegex.hasMatch(expiryDate.trim())) {
      return 'Invalid expiry date format. Use MM/YYYY (e.g., 12/2025)';
    }

    // Check if medicine is expired
    final parts = expiryDate.split('/');
    if (parts.length == 2) {
      final month = int.tryParse(parts[0]);
      final year = int.tryParse(parts[1]);
      if (month != null && year != null) {
        final expiryDateTime = DateTime(year, month);
        final now = DateTime.now();
        if (expiryDateTime.isBefore(DateTime(now.year, now.month))) {
          return 'Medicine cannot be donated if already expired';
        }
      }
    }

    return null;
  }

  Future<void> submitDonation() async {
    // Validate user is logged in
    if (_currentUserId == null || _currentUserName == null) {
      debugPrint('MedicineProvider: Cannot submit donation - user not logged in');
      throw Exception('You must be logged in to donate medicine');
    }

    // Validate form data
    final validationError = validateFormData();
    if (validationError != null) {
      debugPrint('MedicineProvider: Form validation failed - $validationError');
      throw Exception(validationError);
    }

    // Create new medicine from form data with user info
    final newMedicine = MedicineModel.fromFormData(
      _donationFormData,
      _currentUserName!,
      _currentUserId!,
    );

    try {
      // Save to Firebase
      final medicineId = await _repository.addMedicine(newMedicine);

      // Add to local list with the ID from Firebase
      _medicines.insert(0, newMedicine.copyWith(id: medicineId));

      // Close dialog and reset
      _donateDialogOpen = false;
      _clearFormData();
      notifyListeners();

      debugPrint('MedicineProvider: Donation submitted successfully - $medicineId');
      return;
    } catch (e) {
      debugPrint('Error saving to Firebase: $e');
      // Don't add medicine on error - inconsistent state
      // Close dialog and reset
      _donateDialogOpen = false;
      _clearFormData();
      notifyListeners();
      rethrow;
    }
  }

  void _clearFormData() {
    _donationFormData = {
      'medicineName': '',
      'genericName': '',
      'category': 'other', // Reset to default
      'quantity': '',
      'expiryDate': '',
      'description': '',
      'pickupAddress': '',
    };
  }

  void resetState() {
    _selectedCategory = 'all';
    _activeTab = 'find';
    _donateDialogOpen = false;
    _clearFormData();
    notifyListeners();
  }
}
