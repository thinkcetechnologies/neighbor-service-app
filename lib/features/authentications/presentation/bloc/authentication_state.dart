part of 'authentication_bloc.dart';

abstract class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {}

class LoadingAuthenticationState extends AuthenticationState {}

class SuccessLoginAuthenticationState extends AuthenticationState {}

class SuccessRegisterAuthenticationState extends AuthenticationState {}
class SuccessResetPasswordAuthenticationState extends AuthenticationState {}

class SuccessLogoutAuthenticationState extends AuthenticationState {}

class FailureLoginAuthenticationState extends AuthenticationState {}

class FailureRegisterAuthenticationState extends AuthenticationState {}
class FailureResetPasswordAuthenticationState extends AuthenticationState {}

class FailureLogoutAuthenticationState extends AuthenticationState {}
