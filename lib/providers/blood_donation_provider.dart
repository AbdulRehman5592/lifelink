import 'package:flutter/material.dart';

/// Optimized: Fine-grained state fields for segment, blood type, loading, and error.
class BloodDonationProvider with ChangeNotifier {
  // --- Donor/Request segment (0 = Find Donors, 1 = Active Requests)
  int _selectedSegment = 0;
  int get selectedSegment => _selectedSegment;
  set selectedSegment(int value) {
    if (_selectedSegment != value) {
      _selectedSegment = value;
      notifyListeners();
    }
  }
  void selectFindDonors() => selectedSegment = 0;
  void selectActiveRequests() => selectedSegment = 1;

  // --- Blood Type Filter
  String? _selectedBloodType;
  String? get selectedBloodType => _selectedBloodType;
  void selectBloodType(String bloodType) {
    if (_selectedBloodType == bloodType) {
      _selectedBloodType = null;
    } else {
      _selectedBloodType = bloodType;
    }
    notifyListeners();
  }
  void clearBloodTypeFilter() {
    if (_selectedBloodType != null) {
      _selectedBloodType = null;
      notifyListeners();
    }
  }

  // --- Loading (placeholder for future loading state)
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    if (_isLoading != val) {
      _isLoading = val;
      notifyListeners();
    }
  }

  // --- Error (placeholder)
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  set errorMessage(String? val) {
    if (_errorMessage != val) {
      _errorMessage = val;
      notifyListeners();
    }
  }
}

