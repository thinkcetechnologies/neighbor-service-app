import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nsapp/core/models/failure.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, bool>> register(String email, String password);
  Future<Either<Failure, bool>> registerWithGoogle();
  Future<Either<Failure, bool>> resetPassword(String email);
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> loginWithGoogle();
  Future<Either<Failure, bool>> logout();
}
