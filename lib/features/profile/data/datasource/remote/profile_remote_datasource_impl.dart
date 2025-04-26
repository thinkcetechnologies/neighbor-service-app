import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/about.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/core/models/review.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';

import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<bool> addProfile(Profile profile) async {
    try {
      if (image != null) {
        final file = await image!.readAsBytes();
        final url = await Helpers.uploadMedia(
          folder: "profileImages/",
          file: file,
        );
        profile.profilePictureUrl = url;
      } else {
        profile.profilePictureUrl = "";
      }
      await store.collection('profiles').doc(user!.uid).set(profile.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateProfile(Profile profile) async {
    try {
      if (image != null) {
        final file = await image!.readAsBytes();
        final url = await Helpers.uploadMedia(
          folder: "profileImages/",
          file: file,
        );
        profile.profilePictureUrl = url;
      }

      await store
          .collection('profiles')
          .doc(user!.uid)
          .update(profile.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteProfile(String id) async {
    try {
      await store.collection('profiles').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Profile>> getProfiles() async {
    try {
      final querySnapshot = await store.collection('profiles').get();
      return querySnapshot.docs
          .map((doc) => Profile.fromJson(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Profile?> getProfile(String id) async {
    try {
      final docSnapshot =
          await store
              .collection('profiles')
              .where("userId", isEqualTo: id)
              .get();
      return Profile.fromJson(docSnapshot.docs.first);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? getProfileStream() {
    try {
      final docSnapshot =
          store.collection('profiles').doc(user!.uid).snapshots();
      return docSnapshot;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> addAbout(About about) async {
    try {
      List<String> urls = [];
      if (images != null) {
        for (var img in ImagesProfileState.images!) {
          final file = await img.readAsBytes();
          final url = await Helpers.uploadMedia(folder: "about/", file: file);
          urls.add(url);
        }
        about.imageUrls = urls;
      } else {
        about.imageUrls = urls;
      }

      await store.collection('about').doc(user!.uid).set(about.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? getAboutStream(
    String userId,
  ) {
    try {
      final docSnapshot = store.collection('about').doc(userId).snapshots();
      return docSnapshot;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> addReview(Review review) async {
    try {
      await store.collection('review').add(review.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getReviews(String user) {
    try {
      final docSnapshot =
          store.collection('review').where("to", isEqualTo: user).snapshots();
      return docSnapshot;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateDeviceToken() async {
    try {
      String token = await Helpers.getToken();

      await store.collection('profiles').doc(user!.uid).update({
        "deviceToken": token,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
