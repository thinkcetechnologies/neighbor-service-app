import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsapp/core/models/about.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/core/models/review.dart';

abstract class ProfileRemoteDataSource {
  Future<bool> addProfile(Profile profile);
  Future<bool> updateDeviceToken();
  Future<bool> addReview(Review review);
  Future<bool> addAbout(About about);
  Future<bool> updateProfile(Profile profile);
  Future<bool> deleteProfile(String id);
  Future<List<Profile>> getProfiles();
  Future<Profile?> getProfile(String id);
  Stream<DocumentSnapshot<Map<String, dynamic>>>? getProfileStream();
  Stream<DocumentSnapshot<Map<String, dynamic>>>? getAboutStream(String userId);
  Stream<QuerySnapshot<Map<String, dynamic>>>? getReviews(String user);

}
