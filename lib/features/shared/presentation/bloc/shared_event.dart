part of 'shared_bloc.dart';

abstract class SharedEvent {}

class ToggleDashboardEvent extends SharedEvent {
  final bool isProvider;

  ToggleDashboardEvent({required this.isProvider});
}

class ToggleThemeModeEvent extends SharedEvent {
  final ThemeMode themeMode;

  ToggleThemeModeEvent({required this.themeMode});
}

class AddNotificationEvent extends SharedEvent {
  final not.Notification notification;

  AddNotificationEvent({required this.notification});
}

class GetMyNotificationsEvent extends SharedEvent {}

class AddReportEvent extends SharedEvent {
  final Report report;

  AddReportEvent({required this.report});
}

class SendNotificationEvent extends SharedEvent {
  final Notify notify;

  SendNotificationEvent({required this.notify});
}

class SetViewImageEvent extends SharedEvent {
  final String url;

  SetViewImageEvent({required this.url});
}

class SearchPlaceEvent extends SharedEvent {
  final String placeId;

  SearchPlaceEvent({required this.placeId});
}

class SearchPlacesEvent extends SharedEvent {
  final String input;

  SearchPlacesEvent({required this.input});
}

class MapLocationEvent extends SharedEvent {
  final LatLng location;

  MapLocationEvent({required this.location});
}

class UseMapEvent extends SharedEvent {
  final bool useMap;

  UseMapEvent({required this.useMap});
}

class UseBiometricEvent extends SharedEvent {
  final bool usebiometric;

  UseBiometricEvent({required this.usebiometric});
}

class CheckUserSubscriptionEvent extends SharedEvent {}

class DeleteUserSubscriptionEvent extends SharedEvent {}
