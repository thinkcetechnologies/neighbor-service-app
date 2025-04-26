part of 'provider_bloc.dart';

sealed class ProviderEvent {}

class NavigateProviderEvent extends ProviderEvent {
  final Widget widget;
  final int page;

  NavigateProviderEvent({required this.page, required this.widget});
}

class GetRecentRequestEvent extends ProviderEvent {}

class GetAcceptedRequestEvent extends ProviderEvent {}

class GetRequestsEvent extends ProviderEvent {
  final DocumentSnapshot? documentSnapshot;

  GetRequestsEvent({this.documentSnapshot});
}

class ReloadEvent extends ProviderEvent {}

class RequestDetailEvent extends ProviderEvent {
  final Request request;
  final Profile profile;

  RequestDetailEvent({required this.request, required this.profile});
}

class CancelRequestAcceptEvent extends ProviderEvent {
  final RequestAccept requestAccept;

  CancelRequestAcceptEvent({required this.requestAccept});
}

class RequestAcceptEvent extends ProviderEvent {
  final RequestAccept requestAccept;

  RequestAcceptEvent({required this.requestAccept});
}

class ReloadProfileEvent extends ProviderEvent {
  final String request;

  ReloadProfileEvent({required this.request});
}

class AddAppointmentEvent extends ProviderEvent {
  final Appointment appointment;

  AddAppointmentEvent({required this.appointment});
}

class GetAppointmentsEvent extends ProviderEvent {}
class SearchRequestEvent extends ProviderEvent {}

class ProviderBackPressedEvent extends ProviderEvent{}
class SearchEvent extends ProviderEvent{
  final bool isSearching;

  SearchEvent({required this.isSearching});
}