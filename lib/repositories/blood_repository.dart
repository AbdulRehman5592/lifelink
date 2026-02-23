import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blood_request_model.dart';
import '../models/donor_model.dart';

class BloodRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get active blood requests
  Stream<List<BloodRequestModel>> getBloodRequests() {
    return _firestore
        .collection('blood_requests')
        .where('status', isEqualTo: 'active')
        .orderBy('requestDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BloodRequestModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get available donors
  Stream<List<DonorModel>> getDonors({String? bloodType}) {
    Query<Map<String, dynamic>> query = _firestore
        .collection('donors')
        .where('isAvailable', isEqualTo: true)
        .where('status', isEqualTo: 'active');

    // Filter by blood type if specified
    if (bloodType != null && bloodType.isNotEmpty) {
      query = query.where('bloodType', isEqualTo: bloodType);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => DonorModel.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  // Create blood request
  Future<void> createBloodRequest(BloodRequestModel request) async {
    await _firestore.collection('blood_requests').add(request.toMap());
  }

  // Register as donor
  Future<void> registerDonor(DonorModel donor) async {
    await _firestore
        .collection('donors')
        .doc(donor.userId)
        .set(donor.toMap(), SetOptions(merge: true));
  }

  // Update donor availability
  Future<void> updateDonorAvailability(String userId, bool isAvailable) async {
    await _firestore.collection('donors').doc(userId).update({
      'isAvailable': isAvailable,
      'lastDonationDate': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
