import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/models/failure.dart';
import 'package:nsapp/core/models/map_places.dart';
import 'package:nsapp/core/models/notification.dart';
import 'package:nsapp/core/models/notify.dart';
import 'package:nsapp/core/models/place.dart';
import 'package:nsapp/core/models/report.dart';
import 'package:nsapp/features/shared/data/datasource/remote/shared_remote_datasource.dart';
import 'package:nsapp/features/shared/domain/repository/shared_repository.dart';

class SharedRepositoryImpl extends SharedRepository {
  final SharedRemoteDatasource datasource;

  SharedRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> addNotification(
    Notification notification,
  ) async {
    try {
      final results = await datasource.addNotification(notification);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getMyNotifications() async {
    try {
      final results = datasource.getMyNotifications();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> addReport(Report report) async {
    try {
      final results = await datasource.addReport(report);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> sendNotification(Notify notify) async {
    try {
      final results = await datasource.sendNotificationToUser(notify);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Place>> searchPlace({required String placeID}) async {
    try {
      final results = await datasource.searchPlace(placeID: placeID);
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, List<MapPlaces>>> searchPlaces({
    required String input,
  }) async {
    try {
      final results = await datasource.searchPlaces(input: input);
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }
}
