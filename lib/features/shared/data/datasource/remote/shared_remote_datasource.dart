import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:nsapp/core/models/notify.dart';
import 'package:nsapp/core/models/report.dart';

import '../../../../../core/models/place.dart';
import '../../../../../core/models/map_places.dart';
import '../../../../../core/models/notification.dart' as not;

abstract class SharedRemoteDatasource {
  Future<bool> addNotification(not.Notification notification);

  Future<bool> addReport(Report report);

  Stream<QuerySnapshot<Map<String, dynamic>>>? getMyNotifications();

  Future<Place?> searchPlace({required String placeID});

  Future<List<MapPlaces>?> searchPlaces({required String input});

  Future<bool> sendNotificationToUser(Notify notify);
}
