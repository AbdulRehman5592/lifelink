

enum DonorStatus { active, inactive, suspended, verified }

class DonorModel {
  String? id;
  String userId;
  String fullName;
  String bloodType;
  bool isAvailable;
  DonorStatus status;


  DonorModel({
    this.id,
    required this.userId,
    required this.fullName,
    required this.bloodType,
    this.isAvailable = true,
    this.status = DonorStatus.active,

  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'bloodType': bloodType,
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
    bool? isAvailable,
    DonorStatus? status,
  }) {
    return DonorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      bloodType: bloodType ?? this.bloodType,
      isAvailable: isAvailable ?? this.isAvailable,
      status: status ?? this.status,
    );
  }
}
