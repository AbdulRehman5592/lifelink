import 'package:cloud_firestore/cloud_firestore.dart';

enum BloodRequestStatus { pending, active, fulfilled, cancelled, expired }

enum PriorityLevel { low, medium, high, critical }

class BloodRequestModel {
  String? id;
  String patientName;
  String hospitalName;
  String hospitalAddress;
  String bloodType;
  int unitsNeeded;
  PriorityLevel priority;
  BloodRequestStatus status;
  String? patientAge;
  String? patientGender;
  String? medicalCondition;
  String? contactPerson;
  String? contactPhone;
  String? notes;
  String userId; // Who created the request
  List<String>? responderIds; // Users who responded
  DateTime requestDate;
  DateTime? deadline;
  GeoPoint? location;
  bool isUrgent;

  BloodRequestModel({
    this.id,
    required this.patientName,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.bloodType,
    required this.unitsNeeded,
    required this.priority,
    this.status = BloodRequestStatus.active,
    this.patientAge,
    this.patientGender,
    this.medicalCondition,
    this.contactPerson,
    this.contactPhone,
    this.notes,
    required this.userId,
    this.responderIds,
    required this.requestDate,
    this.deadline,
    this.location,
    this.isUrgent = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientName': patientName,
      'hospitalName': hospitalName,
      'hospitalAddress': hospitalAddress,
      'bloodType': bloodType,
      'unitsNeeded': unitsNeeded,
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'medicalCondition': medicalCondition,
      'contactPerson': contactPerson,
      'contactPhone': contactPhone,
      'notes': notes,
      'userId': userId,
      'responderIds': responderIds ?? [],
      'requestDate': requestDate.millisecondsSinceEpoch,
      'deadline': deadline?.millisecondsSinceEpoch,
      'location': location,
      'isUrgent': isUrgent,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory BloodRequestModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return BloodRequestModel(
      id: documentId,
      patientName: map['patientName'] ?? '',
      hospitalName: map['hospitalName'] ?? '',
      hospitalAddress: map['hospitalAddress'] ?? '',
      bloodType: map['bloodType'] ?? '',
      unitsNeeded: map['unitsNeeded'] ?? 1,
      priority: PriorityLevel.values.firstWhere(
        (e) => e.toString() == 'PriorityLevel.${map['priority']}',
        orElse: () => PriorityLevel.medium,
      ),
      status: BloodRequestStatus.values.firstWhere(
        (e) => e.toString() == 'BloodRequestStatus.${map['status']}',
        orElse: () => BloodRequestStatus.pending,
      ),
      patientAge: map['patientAge'],
      patientGender: map['patientGender'],
      medicalCondition: map['medicalCondition'],
      contactPerson: map['contactPerson'],
      contactPhone: map['contactPhone'],
      notes: map['notes'],
      userId: map['userId'] ?? '',
      responderIds: List<String>.from(map['responderIds'] ?? []),
      requestDate: DateTime.fromMillisecondsSinceEpoch(map['requestDate']),
      deadline: map['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deadline'])
          : null,
      location: map['location'],
      isUrgent: map['isUrgent'] ?? false,
    );
  }

  BloodRequestModel copyWith({
    String? id,
    String? patientName,
    String? hospitalName,
    String? hospitalAddress,
    String? bloodType,
    int? unitsNeeded,
    PriorityLevel? priority,
    BloodRequestStatus? status,
    String? patientAge,
    String? patientGender,
    String? medicalCondition,
    String? contactPerson,
    String? contactPhone,
    String? notes,
    String? userId,
    List<String>? responderIds,
    DateTime? requestDate,
    DateTime? deadline,
    GeoPoint? location,
    bool? isUrgent,
  }) {
    return BloodRequestModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      bloodType: bloodType ?? this.bloodType,
      unitsNeeded: unitsNeeded ?? this.unitsNeeded,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
      responderIds: responderIds ?? this.responderIds,
      requestDate: requestDate ?? this.requestDate,
      deadline: deadline ?? this.deadline,
      location: location ?? this.location,
      isUrgent: isUrgent ?? this.isUrgent,
    );
  }
}
