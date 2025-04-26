import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';

import '../../../../core/models/failure.dart';
import '../repository/messages_repository.dart';

class GetMyMessagesUseCase extends UseCase{
  final MessagesRepository repository;
  GetMyMessagesUseCase(this.repository);
  @override
  Future<Either<Failure, List<Stream<QuerySnapshot<Map<String, dynamic>>>>>> call(params) async {
    final results = await repository.getMyMessages();
    return results.fold((l) => Left(l), (r) => Right(r));
  }
}