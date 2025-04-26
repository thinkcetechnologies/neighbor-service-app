import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/models/failure.dart';
import 'package:nsapp/core/models/rate.dart';
import 'package:nsapp/core/models/request.dart';
import 'package:nsapp/features/seeker/data/datasource/remote/seeker_remote_datasource.dart';
import 'package:nsapp/features/seeker/domain/repository/seeker_repository.dart';

class SeekerRepositoryImpl extends SeekerRepository {
  final SeekerRemoteDatasource datasource;

  SeekerRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> createRequest(Request request) async {
    try {
      final results = await datasource.createRequest(request);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> myRequest() async {
    try {
      final results =   datasource.myRequest();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
    return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> getAcceptedUsers({required String request}) async {
    try {
      final results =   datasource.getAcceptedUsers(request: request);
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> approvedRequest({required String user, required String requestId}) async {
    try {
      final results = await datasource.approveRequest(user: user, requestId: requestId);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>>>> reloadRequest({required String request}) async {
    try {
      final results = datasource.reloadRequest(request: request);
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelApprovedRequest({required String requestId}) async {
    try {
      final results = await datasource.cancelApproveRequest(requestId: requestId);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteRequest({required String requestId}) async{
    try {
      final results = await datasource.deleteRequest(requestId: requestId);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateRequest(Request request) async {
    try {
      final results = await datasource.updateRequest(request: request);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> getPopularProviders() async {
    try {
      final results =   datasource.getPopularProviders();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> addToFavorite({required String userID}) async {
    try {
      final results =  await datasource.addToFavorite(uid: userID);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromFavorite({required String userID}) async {
    try {
      final results =  await datasource.removeFromFavorite(uid: userID);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> getMyFavorites() async {
    try {
      final results =  datasource.getMyFavorites();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }
  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> getAppointments() async {
    try {
      final results =  datasource.getAppointment();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> searchProvider() async {
    try {
      final results =  datasource.searchProviders();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsDone(Request request) async {
    try {
      final results = await datasource.markAsDone(request: request);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> rate(Rate rete) async {
    try {
      final results = await datasource.rate(rete);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

}
