import 'dart:async';

import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import '../repositories/medicine_repository.dart';

class MedicineProvider with ChangeNotifier {
  final MedicineRepository _repository = MedicineRepository();

  // UI State
  String _selectedCategory = 'all';
  String _activeTab = 'find';
  bool _donateDialogOpen = false;
  bool _isLoading = false;

  // Donation form data - ADD 'category' FIELD
  Map<String, dynamic> _donationFormData = {
    'medicineName': '',
    'genericName': '',
    'category': 'other', // Default category
    'quantity': '',
    'expiryDate': '',
    'description': '',
    'pickupAddress': '',
  };

  // User info
  String _currentUser = 'You';

  // Medicine list
  List<MedicineModel> _medicines = [];

  // Stream subscription
  StreamSubscription<List<MedicineModel>>? _medicinesSubscription;

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
          print('Firestore error: $error');
          _medicines = _repository.getSampleMedicines();
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      print('Error initializing: $e');
      _medicines = _repository.getSampleMedicines();
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _medicinesSubscription?.cancel();
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

  Future<void> submitDonation() async {
    // Create new medicine from form data
    final newMedicine = MedicineModel.fromFormData(
      _donationFormData,
      _currentUser,
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

      return;
    } catch (e) {
      print('Error saving to Firebase: $e');
      // Fallback: add locally without Firebase ID
      _medicines.insert(0, newMedicine);
      _donateDialogOpen = false;
      _clearFormData();
      notifyListeners();
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
