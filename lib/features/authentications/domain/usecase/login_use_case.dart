import 'package:nsapp/core/helpers/use_case.dart';
import 'package:dartz/dartz.dart';

import 'package:nsapp/features/authentications/domain/repository/authentication_repository.dart';
import 'package:nsapp/core/models/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginUseCase extends UseCase {
  final AuthenticationRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(params) async {
    final results = await repository.login(params.email, params.password);
    return results.fold((l) => Left(l), (r) => Right(r));
  }
}
