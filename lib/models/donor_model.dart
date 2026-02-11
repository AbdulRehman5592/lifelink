enum DonorStatus { active, inactive, suspended, verified }

class DonorModel {
  String? id;
  String userId;
  String fullName;
  String bloodType;
  String? gender;
  DateTime? dateOfBirth;
  bool isAvailable;
  DonorStatus status;


  DonorModel({
    this.id,
    required this.userId,
    required this.fullName,
    required this.bloodType,
    this.gender,
    this.dateOfBirth,
    this.isAvailable = true,
    this.status = DonorStatus.active,

  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'bloodType': bloodType,
      'gender': gender,
      'dateOfBirth':
          dateOfBirth != null ? dateOfBirth!.millisecondsSinceEpoch : null,
      'isAvailable': isAvailable,
      'status': status.toString().split('.').last,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory DonorModel.fromMap(Map<String, dynamic> map, String documentId) {
    return DonorModel(
      id: documentId,
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      bloodType: map['bloodType'] ?? '',
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'])
          : null,
      isAvailable: map['isAvailable'] ?? true,
      status: DonorStatus.values.firstWhere(
        (e) => e.toString() == 'DonorStatus.${map['status']}',
        orElse: () => DonorStatus.active,
      ),

    );
  }


  DonorModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? bloodType,
    String? gender,
    DateTime? dateOfBirth,
    bool? isAvailable,
    DonorStatus? status,
  }) {
    return DonorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      bloodType: bloodType ?? this.bloodType,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isAvailable: isAvailable ?? this.isAvailable,
      status: status ?? this.status,
    );
  }
}
