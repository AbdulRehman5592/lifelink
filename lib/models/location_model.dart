import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  GeoPoint coordinates;
  String address;
  String city;
  String country;
  String? postalCode;
  double? latitude;
  double? longitude;

  LocationModel({
    required this.coordinates,
    required this.address,
    required this.city,
    required this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'coordinates': coordinates,
      'address': address,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      coordinates: map['coordinates'] ?? GeoPoint(0, 0),
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      postalCode: map['postalCode'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}