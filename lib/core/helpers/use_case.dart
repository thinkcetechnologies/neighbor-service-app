abstract class UseCase {
  Future call(dynamic params);
}

abstract class Params {}

class AuthParams extends Params {
  final String email;
  final String password;

  AuthParams({required this.email, required this.password});
}
