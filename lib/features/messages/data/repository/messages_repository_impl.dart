import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/models/failure.dart';
import 'package:nsapp/core/models/message.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/messages/data/datasource/remote/message_remote_datasource.dart';
import 'package:nsapp/features/messages/domain/repository/messages_repository.dart';

class MessagesRepositoryImpl extends MessagesRepository {
  final MessageRemoteDatasource messageRemoteDatasource;
  MessagesRepositoryImpl(this.messageRemoteDatasource);
  @override
  Future<Either<Failure, bool>> sendMessage(Message message) async {
    try {
      final results = await messageRemoteDatasource.sendMessage(message);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>>
  getMessages(String receiver) async {
    try {
      final results = messageRemoteDatasource.getMessages(receiver: receiver);
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, List<Stream<QuerySnapshot<Map<String, dynamic>>>>>>
  getMyMessages() async {
    try {
      final results = await messageRemoteDatasource.getMyMessages();
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, Profile>> reloadMessageReceiver(String user) async {
    try {
      final results = await messageRemoteDatasource.reloadMessageReceiver(user);
      if (results != null) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMessage(Message message) async {
    try {
      final results = await messageRemoteDatasource.deleteMessage(message);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateMessage(Message message) async {
    try {
      final results = await messageRemoteDatasource.updateMessage(message);
      if (results) {
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } catch (e) {
      return Left(Failure(massege: "An error occurred"));
    }
  }
}
