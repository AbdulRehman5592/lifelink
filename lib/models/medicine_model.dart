class MedicineModel {
  String? id;
  String name; // Matches screen's 'name'
  String generic; // Matches screen's 'generic'
  String category; // 'painkillers', 'antibiotics', etc.
  int quantity;
  String expiry; // String format like 'Dec 2025'
  String donor; // Donor name
  double distance; // NUMBER for calculations (in km)
  bool verified;
  DateTime postedDate;
  String? description;
  String? pickupAddress;
  String status; // 'available', 'reserved', 'donated'
  String? donorId; // Optional for Firebase
  List<String>? images;

  // Fields for donation form
  String? medicineName; // For donation form
  String? genericName; // For donation form

  MedicineModel({
    this.id,
    required this.name,
    required this.generic,
    required this.category,
    required this.quantity,
    required this.expiry,
    required this.donor,
    required this.distance,
    this.verified = false,
    required this.postedDate,
    this.description,
    this.pickupAddress,
    this.status = 'available',
    this.donorId,
    this.images,
    this.medicineName,
    this.genericName,
  }) {
    // If medicineName/genericName not provided, use name/generic
    medicineName ??= name;
    genericName ??= generic;
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'generic': generic,
      'category': category,
      'quantity': quantity,
      'expiry': expiry,
      'donor': donor,
      'distance': distance, // NUMBER type
      'verified': verified,
      'postedDate': postedDate.millisecondsSinceEpoch,
      'description': description,
      'pickupAddress': pickupAddress,
      'status': status,
      'donorId': donorId,
      'images': images ?? [],
      'medicineName': medicineName,
      'genericName': genericName,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  // Factory constructor from Firestore
  factory MedicineModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MedicineModel(
      id: documentId,
      name: map['name'] ?? '',
      generic: map['generic'] ?? '',
      category: map['category'] ?? 'other',
      quantity: map['quantity'] ?? 0,
      expiry: map['expiry'] ?? '',
      donor: map['donor'] ?? '',
      distance: (map['distance'] ?? 0).toDouble(), // Convert to double
      verified: map['verified'] ?? false,
      postedDate: DateTime.fromMillisecondsSinceEpoch(map['postedDate'] ?? 0),
      description: map['description'],
      pickupAddress: map['pickupAddress'],
      status: map['status'] ?? 'available',
      donorId: map['donorId'],
      images: List<String>.from(map['images'] ?? []),
      medicineName: map['medicineName'],
      genericName: map['genericName'],
    );
  }

  // Convert to UI-friendly format (exactly what screen expects)
  // The screen expects distance as string "1.2 km", so we format it here
  Map<String, dynamic> toUIData() {
    return {
      'id': id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'generic': generic,
      'quantity': quantity,
      'expiry': expiry,
      'donor': donor,
      'distance': '${distance.toStringAsFixed(1)} km', // Format as string
      'verified': verified,
      // Optional: include category for filtering
      'category': category,
    };
  }

  // Create from UI form data
  factory MedicineModel.fromFormData(
    Map<String, dynamic> formData,
    String donorName,
    String donorId,
  ) {
    return MedicineModel(
      name: formData['medicineName'] ?? '',
      generic: formData['genericName'] ?? formData['medicineName'] ?? '',
      category: formData['category'] ?? 'other',
      quantity: int.tryParse(formData['quantity'] ?? '0') ?? 0,
      expiry: formData['expiryDate'] ?? '',
      donor: donorName,
      donorId: donorId,
      distance: 0.0,
      verified: false,
      postedDate: DateTime.now(),
      description: formData['description'],
      pickupAddress: formData['pickupAddress'],
      status: 'available',
      medicineName: formData['medicineName'],
      genericName: formData['genericName'],
    );
  }

  // Check if valid for donation (simple check)
  bool get isValidForDonation {
    return quantity > 0 && status == 'available';
  }

  // Get distance as formatted string for UI
  String get distanceString => '${distance.toStringAsFixed(1)} km';

  // Copy with for updates
  MedicineModel copyWith({
    String? id,
    String? name,
    String? generic,
    String? category,
    int? quantity,
    String? expiry,
    String? donor,
    double? distance,
    bool? verified,
    DateTime? postedDate,
    String? description,
    String? pickupAddress,
    String? status,
    String? donorId,
    List<String>? images,
    String? medicineName,
    String? genericName,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      generic: generic ?? this.generic,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      expiry: expiry ?? this.expiry,
      donor: donor ?? this.donor,
      distance: distance ?? this.distance,
      verified: verified ?? this.verified,
      postedDate: postedDate ?? this.postedDate,
      description: description ?? this.description,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      status: status ?? this.status,
      donorId: donorId ?? this.donorId,
      images: images ?? this.images,
      medicineName: medicineName ?? this.medicineName,
      genericName: genericName ?? this.genericName,
    );
  }
}
