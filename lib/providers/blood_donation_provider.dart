import 'package:flutter/material.dart';

class BloodDonationProvider with ChangeNotifier {
  int _selectedSegment = 0; // 0 for Find Donors, 1 for Active Requests
  String? _selectedBloodType; // Track selected blood type filter

  int get selectedSegment => _selectedSegment;
  String? get selectedBloodType => _selectedBloodType;

  set selectedSegment(int value) {
    _selectedSegment = value;
    notifyListeners();
  }

  void selectFindDonors() {
    _selectedSegment = 0;
    notifyListeners();
  }

  void selectActiveRequests() {
    _selectedSegment = 1;
    notifyListeners();
  }

  void selectBloodType(String bloodType) {
    if (_selectedBloodType == bloodType) {
      // Deselect if same blood type is clicked again
      _selectedBloodType = null;
    } else {
      _selectedBloodType = bloodType;
    }
    notifyListeners();
  }

  void clearBloodTypeFilter() {
    _selectedBloodType = null;
    notifyListeners();
  }
}
