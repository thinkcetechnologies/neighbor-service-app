import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';

import '../../../../core/models/failure.dart';
import '../repository/seeker_repository.dart';

class ReloadRequestUseCase extends UseCase{
  final SeekerRepository repository;

  ReloadRequestUseCase(this.repository);
  @override
  Future<Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>>> > call(params) async {
    final results = await repository.reloadRequest(request: params);

    return results.fold((l) => Left(l), (r) => Right(r));
  }
  
}