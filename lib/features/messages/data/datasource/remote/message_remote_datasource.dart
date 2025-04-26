import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsapp/core/models/message.dart';
import 'package:nsapp/core/models/profile.dart';

abstract class MessageRemoteDatasource {
  Future<bool> sendMessage(Message message);
  Future<Profile?> reloadMessageReceiver(String user);
  Stream<QuerySnapshot<Map<String, dynamic>>>? getMessages({
    required String receiver,
  });
  Future<List<Stream<QuerySnapshot<Map<String, dynamic>>>>?> getMyMessages();
  Future<bool> updateMessage(Message message);
  Future<bool> deleteMessage(Message message);
}
