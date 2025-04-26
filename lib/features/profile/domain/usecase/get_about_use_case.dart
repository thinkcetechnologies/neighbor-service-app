import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';

import '../../../../core/models/failure.dart';
import '../repository/profile_repository.dart';

class GetAboutUseCase extends UseCase{
  final ProfileRepository repository;

  GetAboutUseCase(this.repository);

  @override
  Future<Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>>>> call(params) async {
    final results = await repository.getAboutStream(params);
    return results.fold(
          (failure) => Left(failure),
          (about) => Right(about),
    );
  }
}