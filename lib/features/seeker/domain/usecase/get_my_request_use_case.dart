import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';
import 'package:nsapp/core/models/failure.dart' show Failure;

import '../repository/seeker_repository.dart';

class GetMyRequestUseCase extends UseCase{
  final SeekerRepository repository;

  GetMyRequestUseCase(this.repository);
  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>> > call(params) async {
    final results = await repository.myRequest();

    return results.fold((l) => Left(l), (r) => Right(r));
  }

}