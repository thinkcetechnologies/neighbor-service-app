import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/appointment.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/core/models/request.dart';
import 'package:nsapp/core/models/request_accept.dart';
import 'package:nsapp/core/models/visited_pages.dart';
import 'package:nsapp/features/provider/domain/usecase/accept_request_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/add_appointment_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/cancel_request_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/get_accepted_request_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/get_appointments_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/get_recent_request_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/get_requests_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/reload_profile_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/serach_request_use_case.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_home_page.dart';

part 'provider_event.dart';

part 'provider_state.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final GetRecentRequestUseCase getRecentRequestUseCase;
  final AcceptRequestUseCase acceptRequestUseCase;
  final CancelRequestUseCase cancelRequestUseCase;
  final ReloadProfileUseCase reloadProfileUseCase;
  final GetAcceptedRequestUseCase getAcceptedRequestUseCase;
  final AddAppointmentUseCase addAppointmentUseCase;
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final GetRequestsUseCase requestsUseCase;
  final SerachRequestUseCase serachRequestUseCase;

  ProviderBloc(
    this.getRecentRequestUseCase,
    this.acceptRequestUseCase,
    this.cancelRequestUseCase,
    this.reloadProfileUseCase,
    this.getAcceptedRequestUseCase,
    this.addAppointmentUseCase,
    this.getAppointmentsUseCase,
    this.requestsUseCase,
    this.serachRequestUseCase,
  ) : super(ProviderInitial()) {
    on<ProviderEvent>((event, emit) {});
    on<ReloadEvent>((event, emit) {
      emit(ReloadState());
    });
    on<RequestDetailEvent>((event, emit) {
      RequestDetailState.profile = event.profile;
      RequestDetailState.request = event.request;
      emit(RequestDetailState());
    });
    on<NavigateProviderEvent>((event, emit) {
      ProviderVisitedPagesState.pages.add(
        VisitedPages(
          widget: NavigatorProviderState.widget,
          page: NavigatorProviderState.page,
        ),
      );
      NavigatorProviderState.page = event.page;
      NavigatorProviderState.widget = event.widget;
      emit(NavigatorProviderState());
    });
    on<GetRecentRequestEvent>((event, emit) async {
      emit(LoadingProviderState());
      final results = await getRecentRequestUseCase(user!.uid);
      results.fold((l) => emit(FailureGetRecentRequestState()), (r) {
        SuccessGetRecentRequestState.myRequests = r;
        emit(SuccessGetRecentRequestState());
      });
    }, transformer: sequential());
    on<GetAcceptedRequestEvent>((event, emit) async {
      emit(LoadingProviderState());
      final results = await getAcceptedRequestUseCase(user!.uid);
      results.fold((l) => emit(FailureGetAcceptRequestState()), (r) {
        SuccessGetAcceptRequestState.accepts = r;
        emit(SuccessGetAcceptRequestState());
      });
    }, transformer: sequential());
    on<CancelRequestAcceptEvent>((event, emit) async {
      emit(LoadingProviderState());
      final results = await cancelRequestUseCase(event.requestAccept);
      results.fold(
        (l) => emit(FailureRequestCancelState()),
        (r) => emit(SuccessRequestCancelState()),
      );
    });
    on<RequestAcceptEvent>((event, emit) async {
      emit(LoadingProviderState());
      final results = await acceptRequestUseCase(event.requestAccept);
      results.fold(
        (l) => emit(FailureRequestAcceptState()),
        (r) => emit(SuccessRequestAcceptState()),
      );
    });
    on<ReloadProfileEvent>((event, emit) async {
      final results = await reloadProfileUseCase(event.request);
      results.fold((l) => emit(FailureReloadProfileState()), (r) {
        SuccessReloadProfileState.exists = r;
        emit(SuccessReloadProfileState());
      });
    });
    on<AddAppointmentEvent>((event, emit) async {
      emit(LoadingProviderState());
      final results = await addAppointmentUseCase(event.appointment);
      results.fold(
        (l) => emit(FailureAddAppointmentState()),
        (r) => emit(SuccessAddAppointmentState()),
      );
    });
    on<GetAppointmentsEvent>((event, emit) async {
      final results = await getAppointmentsUseCase(event);
      results.fold((l) => emit(FailureGetAppointmentState()), (r) {
        SuccessGetAppointmentsState.appointments = r;
        emit(SuccessGetAppointmentsState());
      });
    }, transformer: sequential());

    on<GetRequestsEvent>((event, emit) async {
      final results = await requestsUseCase(event.documentSnapshot);
      results.fold((l) => emit(FailureGetRequestsState()), (r) {
        SuccessGetRequestsState.requests = r;
        emit(SuccessGetRequestsState());
      });
    }, transformer: sequential());

    on<SearchRequestEvent>((event, emit) async {
      final results = await serachRequestUseCase(event);
      results.fold((l) => emit(FailureSearchRequestState()), (r) {
        SuccessSearchRequestState.requests = r;
        emit(SuccessSearchRequestState());
      });
    }, transformer: sequential());
    on<ProviderBackPressedEvent>((event, emit) {
      if (ProviderVisitedPagesState.pages.isNotEmpty) {
        NavigatorProviderState.page = ProviderVisitedPagesState.pages.last.page;
        NavigatorProviderState.widget =
            ProviderVisitedPagesState.pages.last.widget;
        ProviderVisitedPagesState.pages.removeLast();
        emit(NavigatorProviderState());
      }
    });
    on<SearchEvent>((event, emit){
      SearchingState.isSearching = event.isSearching;
      emit(SearchingState());
    });
  }
}
