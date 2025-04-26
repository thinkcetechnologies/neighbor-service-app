import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/message.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/messages/data/datasource/remote/message_remote_datasource.dart';
import 'package:nsapp/features/messages/presentation/bloc/message_bloc.dart';

class MessageRemoteDatasourceImpl extends MessageRemoteDatasource {
  @override
  Future<bool> sendMessage(Message message) async {
    try {
      if (MessageImageState.image != null) {
        final f = await MessageImageState.image!.readAsBytes();
        final String url = await Helpers.uploadMedia(
          folder: "messages/",
          file: f,
        );
        message.mediaUrl = url;
      } else {
        message.mediaUrl = "";
      }
      await store
          .collection("chatrooms")
          .doc(
            Helpers.createChatRoom(
              sender: message.sender,
              receiver: message.receiver,
            ),
          )
          .collection("messages")
          .add(message.toJson());

      var senderRooms =
          await store.collection("rooms").doc(message.sender).get();
      var receiverRooms =
          await store.collection("rooms").doc(message.receiver).get();

      if (receiverRooms.exists) {
        List rooms = receiverRooms.data()?["rooms"];
        String room = Helpers.createChatRoom(
          sender: message.sender,
          receiver: message.receiver,
        );
        if (!rooms.contains(room)) {
          await store.collection("rooms").doc(message.receiver).update({
            "rooms": FieldValue.arrayUnion([
              Helpers.createChatRoom(
                sender: message.sender,
                receiver: message.receiver,
              ),
            ]),
          });
        }
      } else {
        await store.collection("rooms").doc(message.receiver).set({
          "rooms": FieldValue.arrayUnion([
            Helpers.createChatRoom(
              sender: message.sender,
              receiver: message.receiver,
            ),
          ]),
        });
      }

      if (senderRooms.exists) {
        List rooms = senderRooms.data()?["rooms"];
        String room = Helpers.createChatRoom(
          sender: message.sender,
          receiver: message.receiver,
        );
        if (!rooms.contains(room)) {
          await store.collection("rooms").doc(message.sender).update({
            "rooms": FieldValue.arrayUnion([
              Helpers.createChatRoom(
                sender: message.sender,
                receiver: message.receiver,
              ),
            ]),
          });
        }
      } else {
        await store.collection("rooms").doc(message.sender).set({
          "rooms": FieldValue.arrayUnion([
            Helpers.createChatRoom(
              sender: message.sender,
              receiver: message.receiver,
            ),
          ]),
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getMessages({
    required String receiver,
  }) {
    try {
      return store
          .collection("chatrooms")
          .doc(Helpers.createChatRoom(sender: user!.uid, receiver: receiver))
          .collection("messages")
          .orderBy("createAt")
          .snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Stream<QuerySnapshot<Map<String, dynamic>>>>?>
  getMyMessages() async {
    try {
      List<Stream<QuerySnapshot<Map<String, dynamic>>>> chats = [];
      var myRooms = await store.collection("rooms").doc(user!.uid).get();
      if (myRooms.exists) {
        List rooms = myRooms.data()?["rooms"];
        for (var room in rooms) {
          var snapshot =
              store
                  .collection("chatrooms")
                  .doc(room)
                  .collection("messages")
                  .orderBy("createAt")
                  .snapshots();
          chats.add(snapshot);
        }
      } else {
        return null;
      }
      if (chats.isNotEmpty) {
        return chats;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Profile?> reloadMessageReceiver(String user) async {
    try {
      final results = await store.collection("profiles").doc(user).get();
      if (results.exists) {
        return Profile.fromJson(results);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteMessage(Message message) async {
    try {
      store
          .collection("chatrooms")
          .doc(
            Helpers.createChatRoom(
              sender: user!.uid,
              receiver: message.receiver,
            ),
          )
          .collection("messages")
          .doc(message.id)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateMessage(Message message) async {
    try {
      store
          .collection("chatrooms")
          .doc(
            Helpers.createChatRoom(
              sender: user!.uid,
              receiver: message.receiver,
            ),
          )
          .collection("messages")
          .doc(message.id)
          .update({"message": message.message});
      return true;
    } catch (e) {
      return false;
    }
  }
}
