import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRemoteDataSource {
  Future<bool> register(String email, String password);
  Future<bool> registerWithGoogle();
  Future<User?> login(String email, String password);
  Future<bool> resetPassword(String email);
  Future<User?> loginWithGoogle();

  Future<bool> logout();
}
