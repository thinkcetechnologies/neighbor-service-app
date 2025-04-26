import 'package:nsapp/core/initialize/init.dart';

class Request {
  final String? id;
  final String? title;
  final String? approvedUser;
  final List? acceptedUsers;
  final bool? withImage;
  final bool? done;
  String? imageUrl;
  final String? description;
  final String? userId;
  final String? service;
  final bool? approved;
  final DateTime? createAt;
  final bool? isRangePrice;
  final String? price;
  final String? locationAddress;
  final double? latitude;
  final double? longitude;
   Map? position;

  Request({
    this.id,
    this.title,
    this.approvedUser,
    this.acceptedUsers,
    this.withImage,
    this.imageUrl,
    this.description,
    this.userId,
    this.service,
    this.approved,
    this.createAt,
    this.isRangePrice,
    this.price,
    this.latitude,
    this.locationAddress,
    this.longitude,
    this.position,
    this.done,
  });
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'approvedUser': approvedUser,
      'acceptedUsers': acceptedUsers,
      'withImage': withImage,
      'imageUrl': imageUrl,
      'description': description,
      'user': user!.uid,
      'service': service,
      'approved': approved,
      'createAt': DateTime.now().toIso8601String(),
      'isRangePrice': isRangePrice,
      'price': price,
      "longitude": longitude,
      "latitude": latitude,
      "address": locationAddress,
      "position": position,
      "done": done,
    };
  }

  static Request fromJson(dynamic snapshot) {
    var json = snapshot.data() as Map<String, dynamic>;
    return Request(
      id: snapshot.id,
      title: json['title'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      locationAddress: json['address'],
      approvedUser: json['approvedUser'],
      acceptedUsers: json['acceptedUsers'],
      withImage: json['withImage'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      userId: json['user'],
      service: json['service'],
      approved: json['approved'],
      createAt: DateTime.parse(json['createAt']),
      isRangePrice: json['isRangePrice'],
      price: json['price'],
      position: json["position"],
      done: json["done"],
    );
  }
}
