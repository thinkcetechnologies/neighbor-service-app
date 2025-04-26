import 'package:nsapp/features/authentications/data/datasource/remote/authentication_remote_data_source.dart';
import 'package:nsapp/features/authentications/domain/repository/authentication_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nsapp/core/models/failure.dart';

class AuthenicationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationRemoteDataSource dataSource;

  AuthenicationRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, bool>> register(String email, String password) async {
    try {
      final isSuccess = await dataSource.register(email, password);
      if(isSuccess){
        return Right(isSuccess);
      }
      return Left(Failure(massege: "e.message"));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(massege: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await dataSource.login(email, password);
      if (user != null) {
        return Right(user);
      }
      return Left(Failure(massege: "An error occurred"));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(massege: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await dataSource.logout();
      return right(true);
    } on FirebaseAuthException catch (e) {
      return left(Failure(massege: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
      return right(true);
    } on FirebaseAuthException catch (e) {
      return left(Failure(massege: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async{
    try {
      final results  = await dataSource.loginWithGoogle();
      if(results != null){
        return Right(results);
      }
      return Left(Failure(massege: "An error occurred"));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(massege: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> registerWithGoogle() async{
    try {
      final results = await dataSource.registerWithGoogle();
      if(results){
        return Right(results);
      }
      return Left(Failure(massege: "An error occured"));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(massege: e.message));
    }
  }
}
