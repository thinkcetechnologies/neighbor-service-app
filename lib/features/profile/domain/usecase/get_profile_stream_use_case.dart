import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';

import '../../../../core/models/failure.dart';
import '../repository/profile_repository.dart';

class GetProfileStreamUseCase extends UseCase{
  final ProfileRepository repository;

  GetProfileStreamUseCase(this.repository);

  @override
  Future<Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>>>> call(params) async {
    final results = await repository.getProfileStream();
    return results.fold(
          (failure) => Left(failure),
          (profile) => Right(profile),
    );
  }
}