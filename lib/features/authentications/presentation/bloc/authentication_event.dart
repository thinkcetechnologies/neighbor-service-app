part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {}

class LoginAuthenticationEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginAuthenticationEvent({required this.email, required this.password});
}

class RegisterAuthenticationEvent extends AuthenticationEvent {
  final String email;
  final String password;

  RegisterAuthenticationEvent({required this.email, required this.password});
}

class ResetPasswordAuthenticationEvent extends AuthenticationEvent {
  final String email;

  ResetPasswordAuthenticationEvent({required this.email});
}

class LogoutAuthenticationEvent extends AuthenticationEvent {}

class LoginWithGoogleAuthenticationEvent extends AuthenticationEvent {}

class RegisterWithGoogleAuthenticationEvent extends AuthenticationEvent {}
