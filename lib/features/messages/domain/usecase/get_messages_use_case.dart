import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';

import '../../../../core/models/failure.dart';
import '../repository/messages_repository.dart';

class GetMessagesUseCase extends UseCase{
  final MessagesRepository repository;
  GetMessagesUseCase(this.repository);
  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> call(params) async {
    final results = await repository.getMessages(params);
    return results.fold((l) => Left(l), (r) => Right(r));
  }
}