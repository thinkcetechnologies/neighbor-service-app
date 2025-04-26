import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/models/appointment.dart';
import 'package:nsapp/core/models/failure.dart';

abstract class ProviderRepository {
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getRecentRequest();
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getRequests({DocumentSnapshot? document});
  Future<Either<Failure, bool>> acceptRequest({
    required String uid,
    required String requestId,
  });
  Future<Either<Failure, bool>> cancelRequest({
    required String uid,
    required String requestId,
  });
  Future<Either<Failure, bool>> reloadProfile({required String requestId});
  Future<Either<Failure, bool>> addAppointment({
    required Appointment appointment,
  });
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getAcceptedRequest();
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  searchRequests();
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getAppointments();
}
