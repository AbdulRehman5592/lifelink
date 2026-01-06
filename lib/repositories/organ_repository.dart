import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/organ_donation_model.dart';

class OrganRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get organ pledge
  Future<OrganDonationModel?> getOrganPledge(String userId) async {
    final doc = await _firestore.collection('organ_pledges').doc(userId).get();
    return doc.exists ? OrganDonationModel.fromMap(doc.data()!, doc.id) : null;
  }

  // Stream organ pledge
  Stream<OrganDonationModel?> streamOrganPledge(String userId) {
    return _firestore
        .collection('organ_pledges')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.exists
            ? OrganDonationModel.fromMap(snapshot.data()!, snapshot.id)
            : null);
  }

  // Save organ pledge
  Future<void> saveOrganPledge(OrganDonationModel pledge) async {
    await _firestore
        .collection('organ_pledges')
        .doc(pledge.userId)
        .set(pledge.toMap(), SetOptions(merge: true));
  }

  // Get organ statistics
  Future<Map<String, dynamic>> getOrganStats() async {
    final pledges = await _firestore
        .collection('organ_pledges')
        .where('pledgeStatus', whereIn: ['registered', 'verified', 'consented', 'active_donor'])
        .get();

    final organCounts = <String, int>{};
    int totalPledges = pledges.docs.length;

    for (var doc in pledges.docs) {
      final pledge = OrganDonationModel.fromMap(doc.data(), doc.id);
      for (var organ in pledge.pledgedOrgans) {
        final organName = organ.toString().split('.').last;
        organCounts[organName] = (organCounts[organName] ?? 0) + 1;
      }
    }

    return {
      'totalPledges': totalPledges,
      'organCounts': organCounts,
    };
  }
}