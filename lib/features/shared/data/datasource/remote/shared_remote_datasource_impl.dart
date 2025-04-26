import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/place.dart';
import 'package:nsapp/core/models/map_places.dart';
import 'package:nsapp/core/models/report.dart';
import 'package:nsapp/features/shared/data/datasource/remote/shared_remote_datasource.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/string_constants.dart';
import '../../../../../core/models/notification.dart' as not;
import '../../../../../core/models/notify.dart';

class SharedRemoteDatasourceImpl extends SharedRemoteDatasource {
  @override
  Future<bool> addNotification(not.Notification notification) async {
    try {
      await store.collection("notifications").add(notification.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getMyNotifications() {
    try {
      return store
          .collection("notifications")
          .where("user", isEqualTo: user!.uid)
          .snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> addReport(Report report) async {
    try {
      await store.collection("reports").add(report.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Place?> searchPlace({required String placeID}) async {
    try {
      Uuid uuid = Uuid();
      String token = uuid.v4();
      final response = await http.get(
        Uri.parse("$placeDetailsUrl/$placeID?sessionToken=$token"),
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": mapAPIKey,
          "X-Goog-FieldMask": "id,displayName,location",
        },
      );
      final result = json.decode(response.body);

      return Place.fromJson(result);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<List<MapPlaces>?> searchPlaces({required String input}) async {
    List<MapPlaces> locationRemoteModel = [];

    try {
      Uuid uuid = Uuid();
      var search = {"input": input, "sessionToken": uuid.v4()};
      final response = await http.post(
        Uri.parse(placesAutoCompleteUrl),
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": mapAPIKey,
        },
        body: json.encode(search),
      );
      if (response.statusCode == 200) {
        final results = json.decode(response.body)["suggestions"];

        for (var result in results) {
          locationRemoteModel.add(MapPlaces.fromJSON(result));
        }
      }
      return locationRemoteModel;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> sendNotificationToUser(Notify notify) async {
    try {
      final String serverKey = await Helpers.getAccessToken();

      String endpointFirebaseCloudMessaging =
          'https://fcm.googleapis.com/v1/projects/neighbor-service-app/messages:send';
      String deviceToken = await Helpers.getUserDeviceToken(
        uid: notify.userId!,
      );
      debugPrint(serverKey);

      final Map<String, dynamic> message = {
        'message': {
          'token': deviceToken,
          'notification': {'title': notify.title!, 'body': notify.body!},
          'data': {'title': notify.title!, "body": notify.body!},
        },
      };

      final http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: json.encode(message),
      );

      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully');
        return true;
      } else {
        debugPrint('Failed to send FCM: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint("FCM Exception: ${e.toString()}");
      return false;
    }
  }
}
