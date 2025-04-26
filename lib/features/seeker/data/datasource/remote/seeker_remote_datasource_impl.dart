import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/rate.dart';
import 'package:nsapp/core/models/request.dart';
import 'package:nsapp/features/seeker/data/datasource/remote/seeker_remote_datasource.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';

class SeekerRemoteDatasourceImpl extends SeekerRemoteDatasource {
  @override
  Future<bool> createRequest(Request request) async {

    try {
      if (request.withImage!) {
        final file = await image!.readAsBytes();
        final url = await Helpers.uploadMedia(
          folder: "requests",
          file: file,
        );
        request.imageUrl = url;
      } else {
        request.imageUrl = "";
      }
      GeoPoint location = GeoPoint(
        request.latitude!,
        request.longitude!,
      );
      GeoFirePoint position = GeoFirePoint(location);
      request.position = position.data;
      await store.collection("requests").add(request.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? myRequest() {
    try {
      return store
          .collection("requests")
          .where("user", isEqualTo: user!.uid)
          .snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getPopularProviders() {
    try {
      return store
          .collection("profiles")
          .where("type", isEqualTo: "provider")
          .where("userId", isNotEqualTo: user!.uid)
          .limit(15)
          .snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getAcceptedUsers({
    required String request,
  }) {
    try {
      return store
          .collection("profiles")
          .where("acceptedRequests", arrayContains: request)
          .snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> approveRequest({
    required String user,
    required String requestId,
  }) async {
    try {
      await store.collection("requests").doc(requestId).update({
        "approvedUser": user,
        "approved": true,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? reloadRequest({
    required String request,
  }) {
    try {
      return store.collection("requests").doc(request).snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> cancelApproveRequest({required String requestId}) async {
    try {
      await store.collection("requests").doc(requestId).update({
        "approvedUser": "",
        "approved": false,
      });
      print(requestId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteRequest({required String requestId}) async {
    try {
      await store.collection("requests").doc(requestId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateRequest({required Request request}) async {
    try {
      if (request.withImage!) {
        final file = await image!.readAsBytes();
        final url = await Helpers.uploadMedia(
          folder: "requests",
          file: file,
        );
        request.imageUrl = url;
      } else {
        request.imageUrl = request.imageUrl;
      }
      GeoPoint location = GeoPoint(
        request.latitude!,
        request.longitude!,
      );
      GeoFirePoint position = GeoFirePoint(location);
      request.position = position.data;
      await store.collection("requests").doc(request.id).update(request.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> addToFavorite({required String uid}) async {
    try {
      await store.collection("profiles").doc(uid).update({"favorites": FieldValue.arrayUnion([user!.uid])});
      await store.collection("profiles").doc(user!.uid).update({"myFavorites": FieldValue.arrayUnion([uid])});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removeFromFavorite({required String uid}) async {
    try {
      await store.collection("profiles").doc(uid).update({"favorites": FieldValue.arrayRemove([user!.uid])});
      await store.collection("profiles").doc(user!.uid).update({"myFavorites": FieldValue.arrayRemove([uid])});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getMyFavorites() {

      try {
        return store
            .collection("profiles")
            .where("favorites", arrayContains: user!.uid)
            .snapshots();
      } catch (e) {
        return null;
      }
  }
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getAppointment() {
    try {
      return store
          .collection("appointments")
          .where("user", isEqualTo: user!.uid)
          .snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? searchProviders() {
    try {
      return store
          .collection("profiles")
          .where("type", isEqualTo: "provider")
          .snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> markAsDone({required Request request}) async {
    try {
      await store.collection("requests").doc(request.id).update({"done": true});
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> rate(Rate rate) async {
    try{
      await store.collection("profiles").doc(rate.id).update({"ratings": FieldValue.arrayUnion([rate.rate]), "rating": rate.averageRate});
      Get.snackbar("Success", "Successfully rated ${ProviderToReviewState.profile.name}");
      return true;
    }catch(e){
      return false;
    }
  }
}
