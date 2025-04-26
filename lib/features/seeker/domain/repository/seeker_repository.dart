
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/models/failure.dart';
import 'package:nsapp/core/models/request.dart';

import '../../../../core/models/rate.dart';

abstract class SeekerRepository{
  Future<Either<Failure, bool>> createRequest(Request request);
  Future<Either<Failure, bool>> rate(Rate rete);
  Future<Either<Failure, bool>> updateRequest(Request request);
  Future<Either<Failure, bool>> markAsDone(Request request);
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>> >> myRequest();
  Future<Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>> >> reloadRequest({required String request});
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>> >> getPopularProviders();
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>> >> getMyFavorites();

  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>> >> getAcceptedUsers({required String request});
  Future<Either<Failure, bool>> approvedRequest({required String user, required String requestId});
  Future<Either<Failure, bool>> cancelApprovedRequest({required String requestId});
  Future<Either<Failure, bool>> deleteRequest({required String requestId});
  Future<Either<Failure, bool>> addToFavorite({required String userID});
  Future<Either<Failure, bool>> removeFromFavorite({required String userID});

  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>> >> getAppointments();
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>> >> searchProvider();
}