import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/medicine_model.dart';

class MedicineRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get all available medicines
  Stream<List<MedicineModel>> getMedicines({String? category}) {
    Query<Map<String, dynamic>> query = _firestore
        .collection('medicines')
        .where('status', isEqualTo: 'available');

    // Filter by category if specified
    if (category != null && category.isNotEmpty && category != 'all') {
      query = query.where('category', isEqualTo: category);
    }

    return query.orderBy('expiry').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => MedicineModel.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  // Get medicines by category
  Stream<List<MedicineModel>> getMedicinesByCategory(String category) {
    if (category == 'all') {
      return getMedicines();
    }

    return _firestore
        .collection('medicines')
        .where('status', isEqualTo: 'available')
        .where('category', isEqualTo: category)
        .orderBy('expiry')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MedicineModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get medicines by donor
  Stream<List<MedicineModel>> getMedicinesByDonor(String donorId) {
    return _firestore
        .collection('medicines')
        .where('donorId', isEqualTo: donorId)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MedicineModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Add medicine
  Future<String> addMedicine(MedicineModel medicine) async {
    final docRef = await _firestore
        .collection('medicines')
        .add(medicine.toMap());
    return docRef.id;
  }

  // Update medicine
  Future<void> updateMedicine(String medicineId, MedicineModel medicine) async {
    await _firestore
        .collection('medicines')
        .doc(medicineId)
        .update(medicine.toMap());
  }

  // Delete medicine
  Future<void> deleteMedicine(String medicineId) async {
    await _firestore.collection('medicines').doc(medicineId).delete();
  }

  // Upload image
  Future<String> uploadImage(File image, String userId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref().child('medicines/$userId/$timestamp.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  // Create sample data for testing
  List<MedicineModel> getSampleMedicines() {
    return [
      MedicineModel(
        id: '1',
        name: 'Panadol Extra',
        generic: 'Paracetamol 500mg',
        category: 'painkillers',
        quantity: 20,
        expiry: 'Dec 2025',
        donor: 'City Pharmacy',
        distance: 1.2,
        verified: true,
        postedDate: DateTime.now().subtract(Duration(days: 1)),
      ),
      MedicineModel(
        id: '2',
        name: 'Augmentin',
        generic: 'Amoxicillin 625mg',
        category: 'antibiotics',
        quantity: 14,
        expiry: 'Mar 2025',
        donor: 'Ahmed Medical',
        distance: 3.4,
        verified: true,
        postedDate: DateTime.now().subtract(Duration(days: 2)),
      ),
      MedicineModel(
        id: '3',
        name: 'Centrum Silver',
        generic: 'Multivitamin',
        category: 'vitamins',
        quantity: 30,
        expiry: 'Aug 2025',
        donor: 'Sara Rehman',
        distance: 5.1,
        verified: false,
        postedDate: DateTime.now().subtract(Duration(days: 3)),
      ),
    ];
  }
}
