import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get user profile
  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists ? UserModel.fromMap(doc.data()!, doc.id) : null;
  }

  // Stream user profile
  Stream<UserModel?> streamUser(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.exists
            ? UserModel.fromMap(snapshot.data()!, snapshot.id)
            : null);
  }

  // Update user profile
  Future<void> updateUser(String userId, UserModel user) async {
    await _firestore.collection('users').doc(userId).update(user.toMap());
  }

  // Upload profile image
  Future<String> uploadProfileImage(File image, String userId) async {
    final ref = _storage.ref().child('profiles/$userId/profile.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  // Get user stats
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final bloodDonations = await _firestore
        .collection('blood_requests')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'fulfilled')
        .count()
        .get();

    final medicineDonations = await _firestore
        .collection('medicines')
        .where('donorId', isEqualTo: userId)
        .where('status', isEqualTo: 'donated')
        .count()
        .get();

    final organPledge = await _firestore
        .collection('organ_pledges')
        .doc(userId)
        .get();

    return {
      'bloodDonations': bloodDonations.count,
      'medicineDonations': medicineDonations.count,
      'isOrganDonor': organPledge.exists &&
          organPledge.data()?['pledgeStatus'] != 'not_registered',
    };
  }
}