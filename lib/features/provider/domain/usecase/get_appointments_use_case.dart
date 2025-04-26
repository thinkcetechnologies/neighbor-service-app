import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nsapp/core/helpers/use_case.dart';

import '../../../../core/models/failure.dart';
import '../repository/provider_repository.dart';

class GetAppointmentsUseCase extends UseCase{
  final ProviderRepository repository;

  GetAppointmentsUseCase(this.repository);
  @override
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>> >> call(params) async {
    final results = await repository.getAppointments();
    return results.fold((l) => Left(l), (r) => Right(r));
  }
}