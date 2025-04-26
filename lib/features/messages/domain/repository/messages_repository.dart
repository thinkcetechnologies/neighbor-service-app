import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/models/failure.dart';
import 'package:nsapp/core/models/message.dart';

import '../../../../core/models/profile.dart';

abstract class MessagesRepository {
  Future<Either<Failure, bool>> sendMessage(Message message);
  Future<Either<Failure, Profile>> reloadMessageReceiver(String user);
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getMessages(String receiver);
  Future<Either<Failure, List<Stream<QuerySnapshot<Map<String, dynamic>>>>>>
  getMyMessages();
  Future<Either<Failure, bool>> deleteMessage(Message message);
  Future<Either<Failure, bool>> updateMessage(Message message);
}
