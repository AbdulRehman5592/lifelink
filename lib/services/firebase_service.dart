import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    WidgetsFlutterBinding.ensureInitialized();

    try {
      await Firebase.initializeApp();

      // Configure Firestore for offline support (important for LifeLink!)
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      _initialized = true;
      print('✅ LifeLink Firebase initialized successfully');
    } catch (e) {
      print('❌ LifeLink Firebase initialization failed: $e');
      rethrow;
    }
  }

  // Direct access to Firebase services
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  // LifeLink specific helpers
  static String? get currentUserId => auth.currentUser?.uid;
  static bool get isUserLoggedIn => auth.currentUser != null;
  static bool get isInitialized => _initialized;

  // Get user document reference
  static DocumentReference<Map<String, dynamic>> get currentUserDoc {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('No user logged in');
    }
    return firestore.collection('users').doc(userId);
  }

  // Get user data stream
  static Stream<DocumentSnapshot<Map<String, dynamic>>> get currentUserStream {
    return currentUserDoc.snapshots();
  }
}
