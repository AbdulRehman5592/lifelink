import 'package:cloud_firestore/cloud_firestore.dart';

enum EmergencyType { accident, surgery, critical_condition, disaster }

enum EmergencyStatus { active, responded, resolved, cancelled }

class EmergencyModel {
  String? id;
  String title;
  String description;
  EmergencyType type;
  EmergencyStatus status;
  String hospitalName;
  String hospitalAddress;
  String bloodType;
  int unitsNeeded;
  String? contactPerson;
  String? contactPhone;
  String userId;
  DateTime reportedAt;
  DateTime? deadline;
  GeoPoint? location;
  List<String> responderIds;
  bool isVerified;

  EmergencyModel({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    this.status = EmergencyStatus.active,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.bloodType,
    required this.unitsNeeded,
    this.contactPerson,
    this.contactPhone,
    required this.userId,
    required this.reportedAt,
    this.deadline,
    this.location,
    this.responderIds = const [],
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'hospitalName': hospitalName,
      'hospitalAddress': hospitalAddress,
      'bloodType': bloodType,
      'unitsNeeded': unitsNeeded,
      'contactPerson': contactPerson,
      'contactPhone': contactPhone,
      'userId': userId,
      'reportedAt': reportedAt.millisecondsSinceEpoch,
      'deadline': deadline?.millisecondsSinceEpoch,
      'location': location,
      'responderIds': responderIds,
      'isVerified': isVerified,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory EmergencyModel.fromMap(Map<String, dynamic> map, String documentId) {
    return EmergencyModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: EmergencyType.values.firstWhere(
        (e) => e.toString() == 'EmergencyType.${map['type']}',
        orElse: () => EmergencyType.critical_condition,
      ),
      status: EmergencyStatus.values.firstWhere(
        (e) => e.toString() == 'EmergencyStatus.${map['status']}',
        orElse: () => EmergencyStatus.active,
      ),
      hospitalName: map['hospitalName'] ?? '',
      hospitalAddress: map['hospitalAddress'] ?? '',
      bloodType: map['bloodType'] ?? '',
      unitsNeeded: map['unitsNeeded'] ?? 1,
      contactPerson: map['contactPerson'],
      contactPhone: map['contactPhone'],
      userId: map['userId'] ?? '',
      reportedAt: DateTime.fromMillisecondsSinceEpoch(map['reportedAt']),
      deadline: map['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deadline'])
          : null,
      location: map['location'],
      responderIds: List<String>.from(map['responderIds'] ?? []),
      isVerified: map['isVerified'] ?? false,
    );
  }

  EmergencyModel copyWith({
    String? id,
    String? title,
    String? description,
    EmergencyType? type,
    EmergencyStatus? status,
    String? hospitalName,
    String? hospitalAddress,
    String? bloodType,
    int? unitsNeeded,
    String? contactPerson,
    String? contactPhone,
    String? userId,
    DateTime? reportedAt,
    DateTime? deadline,
    GeoPoint? location,
    List<String>? responderIds,
    bool? isVerified,
  }) {
    return EmergencyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      bloodType: bloodType ?? this.bloodType,
      unitsNeeded: unitsNeeded ?? this.unitsNeeded,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      userId: userId ?? this.userId,
      reportedAt: reportedAt ?? this.reportedAt,
      deadline: deadline ?? this.deadline,
      location: location ?? this.location,
      responderIds: responderIds ?? this.responderIds,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
