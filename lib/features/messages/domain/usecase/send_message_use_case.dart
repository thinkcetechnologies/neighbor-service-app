import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';
import 'package:nsapp/features/messages/domain/repository/messages_repository.dart';

import '../../../../core/models/failure.dart';

class SendMessageUseCase extends UseCase{
  final MessagesRepository repository;
  SendMessageUseCase(this.repository);
  @override
  Future<Either<Failure, bool>> call(params) async {
    final results = await repository.sendMessage(params);
    return results.fold((l) => Left(l), (r) => Right(r));
  }
}