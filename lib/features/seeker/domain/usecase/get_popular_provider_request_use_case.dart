import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';

import '../../../../core/models/failure.dart';
import '../repository/seeker_repository.dart';

class GetPopularProviderRequestUseCase extends UseCase{
  final SeekerRepository repository;

  GetPopularProviderRequestUseCase(this.repository);
  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>> > call(params) async {
    final results = await repository.getPopularProviders();

    return results.fold((l) => Left(l), (r) => Right(r));
  }
}