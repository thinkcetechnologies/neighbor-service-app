import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/appointment.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/provider/data/datasource/remote/provider_remote_datasource.dart';

class ProviderRemoteDatasourceImpl extends ProviderRemoteDatasource {
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getRecentRequest() {
    try {
      return store
          .collection("requests")
          .where("done", isEqualTo: false)
          .where("approved", isEqualTo: false)
          .where("user", isNotEqualTo: user!.uid)
          .limit(10)
          .orderBy("createAt", descending: true)
          .snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> acceptRequest({
    required String uid,
    required String requestId,
  }) async {
    try {
      await store.collection("requests").doc(requestId).update({
        "acceptedUsers": FieldValue.arrayUnion([uid]),
      });
      await store.collection("profiles").doc(uid).update({
        "acceptedRequests": FieldValue.arrayUnion([requestId]),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> cancelRequest({
    required String uid,
    required String requestId,
  }) async {
    try {
      await store.collection("requests").doc(requestId).update({
        "acceptedUsers": FieldValue.arrayRemove([uid]),
      });
      await store.collection("profiles").doc(uid).update({
        "acceptedRequests": FieldValue.arrayRemove([requestId]),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getAcceptedRequest() {
    return store
        .collection("requests")
        .where("acceptedUsers", arrayContains: user!.uid)
        .snapshots();
  }

  @override
  Future<bool> reloadProfile({required String request}) async {
    try {
      Profile profile = Profile();
      final results = await store.collection("profiles").doc(user!.uid).get();
      profile = Profile.fromJson(results);
      return profile.acceptedRequests!.contains(request);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> addAppointment({required Appointment appointment}) async {
    try {
      await store.collection("appointments").add(appointment.toJson());
      return true;
    } catch (e) {
      return false;
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
  Stream<QuerySnapshot<Map<String, dynamic>>>? getRequests({
    DocumentSnapshot? startAfter,
  }) {
    try {
      return store
          .collection("requests")
          .where("done", isEqualTo: false)
          .where("approved", isEqualTo: false)
          .where("user", isNotEqualTo: user!.uid)
          .orderBy("createAt", descending: true)
          .snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? searchRequests() {
    try {
      return store
          .collection("requests")
          .where("done", isEqualTo: false)
          .where("approved", isEqualTo: false)
          .where("user", isNotEqualTo: user!.uid)
          .orderBy("createAt", descending: true)
          .snapshots();
    } catch (e) {
      return null;
    }
  }
}
