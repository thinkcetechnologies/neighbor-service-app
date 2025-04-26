import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/models/appointment.dart';
import 'package:nsapp/core/models/failure.dart';
import 'package:nsapp/features/provider/data/datasource/remote/provider_remote_datasource.dart';
import 'package:nsapp/features/provider/domain/repository/provider_repository.dart';

class ProviderRepositoryImpl extends ProviderRepository {
  final ProviderRemoteDatasource datasource;

  ProviderRepositoryImpl(this.datasource);
  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getRecentRequest() async {
    try {
      final results = datasource.getRecentRequest();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> acceptRequest({
    required String uid,
    required String requestId,
  }) async {
    try {
      final results = await datasource.acceptRequest(
        uid: uid,
        requestId: requestId,
      );
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelRequest({
    required String uid,
    required String requestId,
  }) async {
    try {
      final results = await datasource.cancelRequest(
        uid: uid,
        requestId: requestId,
      );
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> reloadProfile({
    required String requestId,
  }) async {
    try {
      final results = await datasource.reloadProfile(request: requestId);
      return Right(results);
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getAcceptedRequest() async {
    try {
      final results = datasource.getAcceptedRequest();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> addAppointment({
    required Appointment appointment,
  }) async {
    try {
      final results = await datasource.addAppointment(appointment: appointment);
      return Right(results);
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getAppointments() async {
    try {
      final results = datasource.getAppointment();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getRequests({DocumentSnapshot? document}) async {
    try {
      final results = datasource.getRequests(startAfter: document);
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  searchRequests() async {
    try {
      final results = datasource.searchRequests();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }
}
