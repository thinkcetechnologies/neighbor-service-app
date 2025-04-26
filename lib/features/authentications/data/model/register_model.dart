class RegisterModel {
  final String email;
  final String password;

  RegisterModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
