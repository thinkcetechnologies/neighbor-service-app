import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/models/about.dart';
import 'package:nsapp/core/models/failure.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/core/models/review.dart';
import 'package:nsapp/features/profile/domain/repository/profile_repository.dart';
import 'package:nsapp/features/profile/data/datasource/remote/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> createProfile(Profile profile) async {
    try {
      final isSuccess = await remoteDataSource.addProfile(profile);
      if (isSuccess) {
        return right(true);
      }
      return left(Failure(massege: 'Failed to create profile'));
    } on Exception {
      return left(Failure(massege: 'Failed to create profile'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfile(Profile profile) async {
    try {
      final isSuccess = await remoteDataSource.updateProfile(profile);
      if (isSuccess) {
        return right(true);
      }
      return left(Failure(massege: 'Failed to update profile'));
    } on Exception {
      return left(Failure(massege: 'Failed to update profile'));
    }
  }

  @override
  Future<Either<Failure, List<Profile>>> getProfiles() async {
    try {
      final profiles = await remoteDataSource.getProfiles();
      if (profiles.isNotEmpty) {
        return right(profiles);
      }
      return left(Failure(massege: 'Profiles not found'));
    } on Exception {
      return left(Failure(massege: 'Failed to get profiles'));
    }
  }

  @override
  Future<Either<Failure, Profile>> getProfile(String id) async {
    try {
      final profile = await remoteDataSource.getProfile(id);
      if (profile != null) {
        return right(profile);
      }
      return left(Failure(massege: 'Profile not found'));
    } on Exception {
      return left(Failure(massege: 'Failed to get profile'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProfile(String id) async {
    try {
      final isSuccess = await remoteDataSource.deleteProfile(id);
      if (isSuccess) {
        return right(true);
      }
      return left(Failure(massege: 'Failed to delete profile'));
    } on Exception {
      return left(Failure(massege: 'Failed to delete profile'));
    }
  }

  @override
  Future<Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>>>> getProfileStream() async {
    try {
      final profile =  remoteDataSource.getProfileStream();
      if (profile != null) {
        return Right(profile);
      }
      return Left(Failure(massege: 'Profile not found'));
    } on Exception {
      return Left(Failure(massege: 'Failed to get profile'));
    }
  }

  @override
  Future<Either<Failure, bool>> createAbout(About about) async {
    try {
      final isSuccess = await remoteDataSource.addAbout(about);
      if (isSuccess) {
        return Right(isSuccess);
      }
      return Left(Failure(massege: 'Failed to delete profile'));
    } on Exception {
      return Left(Failure(massege: 'Failed to delete profile'));
    }
  }

  @override
  Future<Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>>>> getAboutStream(String userId) async{
    try {
      final profile =  remoteDataSource.getAboutStream(userId);
      if (profile != null) {
        return Right(profile);
      }
      return Left(Failure(massege: 'Profile not found'));
    } on Exception {
      return Left(Failure(massege: 'Failed to get profile'));
    }
  }

  @override
  Future<Either<Failure, bool>> addReview(Review review) async{
    try {
      final isSuccess = await remoteDataSource.addReview(review);
      if (isSuccess) {
        return Right(isSuccess);
      }
      return Left(Failure(massege: 'Failed to delete profile'));
    } on Exception {
      return Left(Failure(massege: 'Failed to delete profile'));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> getReviewStream(String userId) async{
    try {
      final results =  remoteDataSource.getReviews(userId);
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: 'Profile not found'));
    } on Exception {
      return Left(Failure(massege: 'Failed to get profile'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateToken() async {
    try {
      final isSuccess = await remoteDataSource.updateDeviceToken();
      if (isSuccess) {
        return right(true);
      }
      return left(Failure(massege: 'Failed to create profile'));
    } on Exception {
      return left(Failure(massege: 'Failed to create profile'));
    }
  }
}
