part of 'provider_bloc.dart';

sealed class ProviderState {}

final class ProviderInitial extends ProviderState {}

final class LoadingProviderState extends ProviderState {}

class NavigatorProviderState extends ProviderState {
  static Widget widget = const ProviderHomePage();
  static int page = 1;
}

class ProviderVisitedPagesState extends ProviderState {
  static List<VisitedPages> pages = [];
}

class SuccessGetRecentRequestState extends ProviderState {
  static Stream<QuerySnapshot<Map<String, dynamic>>>? myRequests;
}

class SuccessGetAcceptRequestState extends ProviderState {
  static Stream<QuerySnapshot<Map<String, dynamic>>>? accepts;
}

class FailureGetAcceptRequestState extends ProviderState {}

class FailureGetRequestsState extends ProviderState {}

class FailureGetRecentRequestState extends ProviderState {}

class ReloadState extends ProviderState {}

class RequestDetailState extends ProviderState {
  static Request request = Request();
  static Profile profile = Profile();
}

class SuccessRequestAcceptState extends ProviderState {}

class FailureRequestAcceptState extends ProviderState {}

class SuccessRequestCancelState extends ProviderState {}

class FailureRequestCancelState extends ProviderState {}

class SuccessReloadProfileState extends ProviderState {
  static bool exists = false;
}

class FailureReloadProfileState extends ProviderState {}

class SuccessAddAppointmentState extends ProviderState {}

class FailureAddAppointmentState extends ProviderState {}

class FailureGetAppointmentState extends ProviderState {}

class FailureSearchRequestState extends ProviderState {}

class SuccessGetAppointmentsState extends ProviderState {
  static Stream<QuerySnapshot<Map<String, dynamic>>>? appointments;
}

class SuccessGetRequestsState extends ProviderState {
  static Stream<QuerySnapshot<Map<String, dynamic>>>? requests;
}

class SuccessSearchRequestState extends ProviderState {
  static Stream<QuerySnapshot<Map<String, dynamic>>>? requests;
}

class SearchingState extends ProviderState {
  static bool isSearching = false;
}
