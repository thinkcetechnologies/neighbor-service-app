import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsapp/core/models/appointment.dart';

abstract class ProviderRemoteDatasource {
  Stream<QuerySnapshot<Map<String, dynamic>>>? getRecentRequest();
  Stream<QuerySnapshot<Map<String, dynamic>>>? getRequests({
    DocumentSnapshot? startAfter,
  });
  Stream<QuerySnapshot<Map<String, dynamic>>>? searchRequests();
  Future<bool> acceptRequest({required String uid, required String requestId});
  Future<bool> cancelRequest({required String uid, required String requestId});
  Stream<QuerySnapshot<Map<String, dynamic>>>? getAcceptedRequest();
  Stream<QuerySnapshot<Map<String, dynamic>>>? getAppointment();
  Future<bool> reloadProfile({required String request});
  Future<bool> addAppointment({required Appointment appointment});
}
