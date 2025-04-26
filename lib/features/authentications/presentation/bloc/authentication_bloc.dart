import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/helpers/use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/login_use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/login_with_google_use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/logout_use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/register_use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/register_with_google_use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/reset_password_use_case.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final RegisterWithGoogleUseCase registerWithGoogleUseCase;
  AuthenticationBloc(
    this.loginUseCase,
    this.registerUseCase,
    this.logoutUseCase,
      this.resetPasswordUseCase,
      this.loginWithGoogleUseCase,
      this.registerWithGoogleUseCase,
  ) : super(InitialAuthenticationState()) {
    on<LoginAuthenticationEvent>((event, emit) async {
      emit(LoadingAuthenticationState());
      final results = await loginUseCase.call(
        AuthParams(email: event.email, password: event.password),
      );
      results.fold(
        (l) => emit(FailureLoginAuthenticationState()),
        (r) => emit(SuccessLoginAuthenticationState()),
      );
    });
    on<RegisterAuthenticationEvent>((event, emit) async {
      emit(LoadingAuthenticationState());
      final results = await registerUseCase.call(
        AuthParams(email: event.email, password: event.password),
      );
      results.fold(
        (l) => emit(FailureRegisterAuthenticationState()),
        (r) => emit(SuccessRegisterAuthenticationState()),
      );
    });
    on<LogoutAuthenticationEvent>((event, emit) async {
      emit(LoadingAuthenticationState());
      final results = await logoutUseCase.call(event);
      results.fold(
        (l) => emit(FailureLoginAuthenticationState()),
        (r) => emit(SuccessLogoutAuthenticationState()),
      );
    });
    on<ResetPasswordAuthenticationEvent>((event, emit) async {
      emit(LoadingAuthenticationState());
      final results = await resetPasswordUseCase.call(event.email);
      results.fold(
            (l) => emit(FailureResetPasswordAuthenticationState()),
            (r) => emit(SuccessResetPasswordAuthenticationState()),
      );
    });
    on<RegisterWithGoogleAuthenticationEvent>((event, emit) async {
      emit(LoadingAuthenticationState());
      final results = await registerWithGoogleUseCase.call(event);
      results.fold(
            (l) => emit(FailureRegisterAuthenticationState()),
            (r) => emit(SuccessRegisterAuthenticationState()),
      );
    });
    on<LoginWithGoogleAuthenticationEvent>((event, emit) async {
      emit(LoadingAuthenticationState());
      final results = await loginWithGoogleUseCase.call(event);
      results.fold(
            (l) => emit(FailureLoginAuthenticationState()),
            (r) => emit(SuccessLoginAuthenticationState()),
      );
    });
  }
}
