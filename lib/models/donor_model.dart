import 'package:cloud_firestore/cloud_firestore.dart';

enum DonorStatus { active, inactive, suspended, verified }

class DonorModel {
  String? id;
  String userId;
  String fullName;
  String bloodType;
  DateTime lastDonationDate;
  bool isAvailable;
  DonorStatus status;
  int totalDonations;
  String? healthCertificateUrl;
  DateTime? nextAvailableDate;
  GeoPoint? location;
  double? distance; // Calculated distance in km
  bool isVerified;

  DonorModel({
    this.id,
    required this.userId,
    required this.fullName,
    required this.bloodType,
    required this.lastDonationDate,
    this.isAvailable = true,
    this.status = DonorStatus.active,
    this.totalDonations = 0,
    this.healthCertificateUrl,
    this.nextAvailableDate,
    this.location,
    this.distance,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'bloodType': bloodType,
      'lastDonationDate': lastDonationDate.millisecondsSinceEpoch,
      'isAvailable': isAvailable,
      'status': status.toString().split('.').last,
      'totalDonations': totalDonations,
      'healthCertificateUrl': healthCertificateUrl,
      'nextAvailableDate': nextAvailableDate?.millisecondsSinceEpoch,
      'location': location,
      'isVerified': isVerified,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory DonorModel.fromMap(Map<String, dynamic> map, String documentId) {
    return DonorModel(
      id: documentId,
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      bloodType: map['bloodType'] ?? '',
      lastDonationDate: DateTime.fromMillisecondsSinceEpoch(
        map['lastDonationDate'],
      ),
      isAvailable: map['isAvailable'] ?? true,
      status: DonorStatus.values.firstWhere(
        (e) => e.toString() == 'DonorStatus.${map['status']}',
        orElse: () => DonorStatus.active,
      ),
      totalDonations: map['totalDonations'] ?? 0,
      healthCertificateUrl: map['healthCertificateUrl'],
      nextAvailableDate: map['nextAvailableDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['nextAvailableDate'])
          : null,
      location: map['location'],
      isVerified: map['isVerified'] ?? false,
    );
  }

  bool get canDonate {
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
    return lastDonationDate.isBefore(threeMonthsAgo) && isAvailable;
  }

  DonorModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? bloodType,
    DateTime? lastDonationDate,
    bool? isAvailable,
    DonorStatus? status,
    int? totalDonations,
    String? healthCertificateUrl,
    DateTime? nextAvailableDate,
    GeoPoint? location,
    double? distance,
    bool? isVerified,
  }) {
    return DonorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      bloodType: bloodType ?? this.bloodType,
      lastDonationDate: lastDonationDate ?? this.lastDonationDate,
      isAvailable: isAvailable ?? this.isAvailable,
      status: status ?? this.status,
      totalDonations: totalDonations ?? this.totalDonations,
      healthCertificateUrl: healthCertificateUrl ?? this.healthCertificateUrl,
      nextAvailableDate: nextAvailableDate ?? this.nextAvailableDate,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
