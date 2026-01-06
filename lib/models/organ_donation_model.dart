enum OrganType { kidney, liver, heart, lungs, cornea, pancreas, bone_marrow }
enum PledgeStatus { not_registered, registered, verified, consented, active_donor }

class OrganDonationModel {
  String? id;
  String userId;
  String fullName;
  List<OrganType> pledgedOrgans;
  PledgeStatus pledgeStatus;
  DateTime? pledgeDate;
  String? donorCardNumber;
  String? consentFormUrl;
  bool familyConsent;
  String? emergencyContact;
  String? medicalHistory;
  bool isVerified;
  DateTime? lastUpdated;

  OrganDonationModel({
    this.id,
    required this.userId,
    required this.fullName,
    this.pledgedOrgans = const [],
    this.pledgeStatus = PledgeStatus.not_registered,
    this.pledgeDate,
    this.donorCardNumber,
    this.consentFormUrl,
    this.familyConsent = false,
    this.emergencyContact,
    this.medicalHistory,
    this.isVerified = false,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'pledgedOrgans': pledgedOrgans.map((e) => e.toString().split('.').last).toList(),
      'pledgeStatus': pledgeStatus.toString().split('.').last,
      'pledgeDate': pledgeDate?.millisecondsSinceEpoch,
      'donorCardNumber': donorCardNumber,
      'consentFormUrl': consentFormUrl,
      'familyConsent': familyConsent,
      'emergencyContact': emergencyContact,
      'medicalHistory': medicalHistory,
      'isVerified': isVerified,
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory OrganDonationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrganDonationModel(
      id: documentId,
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      pledgedOrgans: (map['pledgedOrgans'] as List<dynamic>?)
          ?.map((e) => OrganType.values.firstWhere(
                (o) => o.toString() == 'OrganType.$e',
                orElse: () => OrganType.kidney,
              ))
          .toList() ?? [],
      pledgeStatus: PledgeStatus.values.firstWhere(
        (e) => e.toString() == 'PledgeStatus.${map['pledgeStatus']}',
        orElse: () => PledgeStatus.not_registered,
      ),
      pledgeDate: map['pledgeDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['pledgeDate'])
          : null,
      donorCardNumber: map['donorCardNumber'],
      consentFormUrl: map['consentFormUrl'],
      familyConsent: map['familyConsent'] ?? false,
      emergencyContact: map['emergencyContact'],
      medicalHistory: map['medicalHistory'],
      isVerified: map['isVerified'] ?? false,
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastUpdated'])
          : null,
    );
  }

  OrganDonationModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    List<OrganType>? pledgedOrgans,
    PledgeStatus? pledgeStatus,
    DateTime? pledgeDate,
    String? donorCardNumber,
    String? consentFormUrl,
    bool? familyConsent,
    String? emergencyContact,
    String? medicalHistory,
    bool? isVerified,
    DateTime? lastUpdated,
  }) {
    return OrganDonationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      pledgedOrgans: pledgedOrgans ?? this.pledgedOrgans,
      pledgeStatus: pledgeStatus ?? this.pledgeStatus,
      pledgeDate: pledgeDate ?? this.pledgeDate,
      donorCardNumber: donorCardNumber ?? this.donorCardNumber,
      consentFormUrl: consentFormUrl ?? this.consentFormUrl,
      familyConsent: familyConsent ?? this.familyConsent,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      isVerified: isVerified ?? this.isVerified,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}