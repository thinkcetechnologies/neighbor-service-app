import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';

import '../../../../core/models/failure.dart';
import '../repository/provider_repository.dart';

class AcceptRequestUseCase extends UseCase {
  final ProviderRepository repository;

  AcceptRequestUseCase(this.repository);
  @override
  Future<Either<Failure, bool>> call(params) async {
    final results = await repository.acceptRequest(
      uid: params.uid,
      requestId: params.requestId,
    );

    return results.fold((l) => Left(l), (r) => Right(r));
  }
}
