import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/models/failure.dart';
import 'package:nsapp/core/models/notify.dart';
import 'package:nsapp/core/models/report.dart';

import '../../../../core/models/map_places.dart';
import '../../../../core/models/notification.dart';
import '../../../../core/models/place.dart';

abstract class SharedRepository {
  Future<Either<Failure, bool>> addNotification(Notification notification);

  Future<Either<Failure, bool>> addReport(Report report);

  Future<Either<Failure, bool>> sendNotification(Notify notify);

  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getMyNotifications();

  Future<Either<Failure, Place>> searchPlace({required String placeID});

  Future<Either<Failure, List<MapPlaces>>> searchPlaces({
    required String input,
  });
}
