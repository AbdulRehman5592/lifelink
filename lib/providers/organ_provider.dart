import 'package:flutter/material.dart';

class OrganProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _organTypes = [
    {'name': 'Kidney', 'icon': '🫘', 'available': 234, 'waitlist': 1250},
    {'name': 'Liver', 'icon': '👁️‍🗨️', 'available': 87, 'waitlist': 890},
    {'name': 'Heart', 'icon': '❤️', 'available': 23, 'waitlist': 456},
    {'name': 'Lungs', 'icon': '🫁', 'available': 45, 'waitlist': 567},
    {'name': 'Cornea', 'icon': '👁️', 'available': 156, 'waitlist': 2340},
  ];

  final List<Map<String, dynamic>> _pledgeSteps = [
    {
      'step': 1,
      'title': 'Register',
      'description': 'Create your donor profile',
      'completed': true,
    },
    {
      'step': 2,
      'title': 'Verify',
      'description': 'Submit identity documents',
      'completed': true,
    },
    {
      'step': 3,
      'title': 'Consent',
      'description': 'Complete consent form',
      'completed': false,
    },
    {
      'step': 4,
      'title': 'Card',
      'description': 'Receive donor card',
      'completed': false,
    },
  ];

  final List<Map<String, dynamic>> _infoCards = [
    {
      'title': 'Learn About Organ Donation',
      'description': 'Facts, myths, and how to talk to your family',
      'icon': Icons.info,
      'iconColor': Colors.blue,
      'backgroundColor': Colors.blue.shade50,
    },
    {
      'title': 'HOTA Guidelines',
      'description': 'Legal framework for organ transplant in Pakistan',
      'icon': Icons.shield,
      'iconColor': Color(0xFF00A89D),
      'backgroundColor': Color(0xFFE0F2F1),
    },
    {
      'title': 'Partner Hospitals',
      'description': '12 accredited transplant centers',
      'icon': Icons.people,
      'iconColor': Colors.green,
      'backgroundColor': Color(0xFFE8F5E9),
    },
  ];

  // Stats
  final int _registeredDonors = 2345;
  final int _transplantsDone = 156;
  final int _onWaitlist = 4500;

  // Getters
  List<Map<String, dynamic>> get organTypes => _organTypes;
  List<Map<String, dynamic>> get pledgeSteps => _pledgeSteps;
  List<Map<String, dynamic>> get infoCards => _infoCards;
  int get registeredDonors => _registeredDonors;
  int get transplantsDone => _transplantsDone;
  int get onWaitlist => _onWaitlist;

  // Actions
  void togglePledgeStep(int step) {
    final index = _pledgeSteps.indexWhere((s) => s['step'] == step);
    if (index != -1) {
      _pledgeSteps[index]['completed'] = !_pledgeSteps[index]['completed'];
      notifyListeners();
    }
  }

  void completeConsentForm() {
    final index = _pledgeSteps.indexWhere((s) => s['step'] == 3);
    if (index != -1) {
      _pledgeSteps[index]['completed'] = true;
      notifyListeners();
    }
  }

  void resetPledgeStatus() {
    for (var step in _pledgeSteps) {
      step['completed'] = step['step'] <= 2;
    }
    notifyListeners();
  }
}
