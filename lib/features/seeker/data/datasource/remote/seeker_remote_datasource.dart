import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsapp/core/models/rate.dart';
import 'package:nsapp/core/models/request.dart';

abstract class SeekerRemoteDatasource{
  Future<bool> createRequest(Request request);
  Future<bool> rate(Rate rate);
  Stream<QuerySnapshot<Map<String, dynamic>>>?  myRequest();
  Stream<QuerySnapshot<Map<String, dynamic>>>?  getPopularProviders();
  Stream<QuerySnapshot<Map<String, dynamic>>>? getAcceptedUsers({required String request});
  Stream<QuerySnapshot<Map<String, dynamic>>>? getMyFavorites();
  Future<bool> approveRequest({required String user, required String requestId});
  Future<bool> cancelApproveRequest({required String requestId});
  Future<bool> deleteRequest({required String requestId});
  Future<bool> updateRequest({required Request request});
  Future<bool> markAsDone({required Request request});
  Future<bool> addToFavorite({required String uid});
  Future<bool> removeFromFavorite({required String uid});
  Stream<DocumentSnapshot<Map<String, dynamic>>>? reloadRequest({required String request});

  Stream<QuerySnapshot<Map<String, dynamic>>>? getAppointment();
  Stream<QuerySnapshot<Map<String, dynamic>>>? searchProviders();
}