import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String bloodType;
  final String? gender;
  final DateTime? dateOfBirth;
  final DateTime createdAt;
  final GeoPoint? location;
  final List<String> badges;
  final int totalDonations;
  final DateTime nextDonationDate;
  final bool isOrganDonor;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.bloodType,
    this.gender,
    this.dateOfBirth,
    required this.createdAt,
    this.location,
    required this.badges,
    required this.totalDonations,
    required this.nextDonationDate,
    required this.isOrganDonor,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'bloodType': bloodType,
      'gender': gender,
      'dateOfBirth':
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'location': location,
      'badges': badges,
      'totalDonations': totalDonations,
      'nextDonationDate': Timestamp.fromDate(nextDonationDate),
      'isOrganDonor': isOrganDonor,
    };
  }

  // Create from Firestore document
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      bloodType: json['bloodType'] as String,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? (json['dateOfBirth'] as Timestamp).toDate()
          : null,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      location: json['location'] as GeoPoint?,
      badges: List<String>.from(json['badges'] ?? []),
      totalDonations: json['totalDonations'] as int,
      nextDonationDate: (json['nextDonationDate'] as Timestamp).toDate(),
      isOrganDonor: json['isOrganDonor'] as bool,
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? fullName,
    String? phoneNumber,
    String? bloodType,
    String? gender,
    DateTime? dateOfBirth,
    GeoPoint? location,
    List<String>? badges,
    int? totalDonations,
    DateTime? nextDonationDate,
    bool? isOrganDonor,
  }) {
    return UserModel(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bloodType: bloodType ?? this.bloodType,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt,
      location: location ?? this.location,
      badges: badges ?? this.badges,
      totalDonations: totalDonations ?? this.totalDonations,
      nextDonationDate: nextDonationDate ?? this.nextDonationDate,
      isOrganDonor: isOrganDonor ?? this.isOrganDonor,
    );
  }

  static UserModel fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      bloodType: map['bloodType'] as String,
      gender: map['gender'] as String?,
      dateOfBirth: map['dateOfBirth'] != null
          ? (map['dateOfBirth'] as Timestamp).toDate()
          : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      location: map['location'] as GeoPoint?,
      badges: List<String>.from(map['badges'] ?? []),
      totalDonations: map['totalDonations'] as int,
      nextDonationDate: (map['nextDonationDate'] as Timestamp).toDate(),
      isOrganDonor: map['isOrganDonor'] as bool,
    );
  }

  Map<Object, Object?> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'bloodType': bloodType,
      'gender': gender,
      'dateOfBirth':
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'location': location,
      'badges': badges,
      'totalDonations': totalDonations,
      'nextDonationDate': Timestamp.fromDate(nextDonationDate),
      'isOrganDonor': isOrganDonor,
    };
  }
}
