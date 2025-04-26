import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/models/about.dart';
import 'package:nsapp/core/models/failure.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/core/models/review.dart';

abstract class ProfileRepository {
  Future<Either<Failure, bool>> createProfile(Profile profile);
  Future<Either<Failure, bool>> updateToken();
  Future<Either<Failure, bool>> createAbout(About about);
  Future<Either<Failure, bool>> addReview(Review review);
  Future<Either<Failure, bool>> updateProfile(Profile profile);
  Future<Either<Failure, bool>> deleteProfile(String id);
  Future<Either<Failure, List<Profile>>> getProfiles();
  Future<Either<Failure, Profile?>> getProfile(String id);
  Future<Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>>>> getProfileStream();
  Future<Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>>>> getAboutStream(String userId);
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> getReviewStream(String userId);
}
