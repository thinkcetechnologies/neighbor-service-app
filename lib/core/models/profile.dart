import 'package:nsapp/core/initialize/init.dart';

class Profile {
  final String? id;
  final String? name;
  final String? email;
  final String? address;
  final String? phone;
  final String? rating;
  final String? country;
  final String? city;
  final String? state;
  final String? countryCode;
  final String? zipCode;
  final DateTime? birthDate;
  final List? favorites;
  final String? gender;
  final List? ratings;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  String? profilePictureUrl;
  final String? service;
  final String? userType;
  final String? userId;
  final List? acceptedRequests;
  final List? myFavorites;
  final String? deviceToken;
  final double? longitude;
  final double? latitude;

  Profile({
    this.id,
    this.name,
    this.email,
    this.address,
    this.phone,
    this.country,
    this.city,
    this.state,
    this.countryCode,
    this.zipCode,
    this.birthDate,
    this.gender,
    this.createdAt,
    this.updatedAt,
    this.profilePictureUrl,
    this.service,
    this.userId,
    this.userType,
    this.favorites,
    this.acceptedRequests,
    this.myFavorites,
    this.rating,
    this.ratings,
    this.deviceToken,
    this.longitude,
    this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "rating": rating,
      "ratings": ratings,
      'name': name,
      'type': userType,
      'favorites': favorites,
      'email': email,
      'address': address,
      'phone': phone,
      'country': country,
      'city': city,
      'state': state,
      'countryCode': countryCode,
      'zipCode': zipCode,
      'birthDate': birthDate,
      'gender': gender,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'profilePictureUrl': profilePictureUrl,
      'service': service,
      'userId': user!.uid,
      "acceptedRequests": acceptedRequests,
      "myFavorites": myFavorites,
      "deviceToken": deviceToken,
      "longitude": longitude,
      "latitude": latitude,
    };
  }

  static Profile fromJson(dynamic snapshot) {
    var json = snapshot.data() as Map<String, dynamic>;
    return Profile(
      id: snapshot.id,
      deviceToken: json["deviceToken"],
      name: json['name'],
      rating: json['rating']?.toString(),
      ratings: json['ratings'],
      userType: json['type'],
      favorites: json['favorites'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      country: json['country'],
      city: json['city'],
      state: json['state'],
      countryCode: json['countryCode'],
      zipCode: json['zipCode'],
      birthDate: json['birthDate'].toDate(),
      gender: json['gender'],
      createdAt: json['createdAt'].toDate(),
      updatedAt: json['updatedAt'].toDate(),
      profilePictureUrl: json['profilePictureUrl'],
      service: json['service'],
      userId: json['userId'],
      acceptedRequests: json["acceptedRequests"],
      myFavorites: json["myFavorites"],
      longitude: json["longitude"],
      latitude: json["latitude"],
    );
  }
}
