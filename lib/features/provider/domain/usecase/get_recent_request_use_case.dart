import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';
import 'package:nsapp/features/provider/domain/repository/provider_repository.dart';

import '../../../../core/models/failure.dart';

class GetRecentRequestUseCase extends UseCase {
  final ProviderRepository repository;

  GetRecentRequestUseCase(this.repository);
  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> call(
    params,
  ) async {
    final results = await repository.getRecentRequest();

    return results.fold((l) => Left(l), (r) => Right(r));
  }
}
