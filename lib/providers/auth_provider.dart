import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Check if user is logged in
  Future<bool> checkLoginStatus() async {
    User? firebaseUser = FirebaseService.auth.currentUser;

    if (firebaseUser != null) {
      await _fetchUserData(firebaseUser.uid);
      return true;
    }
    return false;
  }

  // Sign up with email/password
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String bloodType,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Create user in Firebase Auth
      UserCredential credential = await FirebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create user document in Firestore
      UserModel newUser = UserModel(
        id: credential.user!.uid,
        email: email,
        fullName: fullName,
        phoneNumber: phone,
        bloodType: bloodType,
        createdAt: DateTime.now(),
        badges: [],
        totalDonations: 0,
        nextDonationDate: DateTime.now().add(const Duration(days: 90)),
        isOrganDonor: false,
      );

      await FirebaseService.firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(newUser.toJson());

      _currentUser = newUser;

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in with email/password
  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserCredential credential = await FirebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);

      await _fetchUserData(credential.user!.uid);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await FirebaseService.auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        _currentUser = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (_currentUser == null) return;

    try {
      await FirebaseService.firestore
          .collection('users')
          .doc(_currentUser!.id)
          .update(updates);

      // Update local user model
      _currentUser = _currentUser!.copyWith(
        fullName: updates['fullName'] ?? _currentUser!.fullName,
        phoneNumber: updates['phoneNumber'] ?? _currentUser!.phoneNumber,
        bloodType: updates['bloodType'] ?? _currentUser!.bloodType,
        location: updates['location'] ?? _currentUser!.location,
      );

      notifyListeners();
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  // Error message helper
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
