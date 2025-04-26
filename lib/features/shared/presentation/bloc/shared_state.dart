part of 'shared_bloc.dart';

abstract class SharedState {}

class SharedInitialState extends SharedState {}

class SharedLoadingState extends SharedState {}

class DashboardState extends SharedState {
  static bool isProvider = false;
}

class ThemeModeState extends SharedState {
  static ThemeMode themeMode = ThemeMode.system;
}

class SuccessAddNotificationsState extends SharedState {}

class FailureAddNotificationState extends SharedState {}

class SuccessGetMyNotificationsState extends SharedState {
  static Stream<QuerySnapshot<Map<String, dynamic>>>? notifications;
}

class FailureGetMyNotificationsState extends SharedState {}

class SuccessAddReportState extends SharedState {}

class FailureAddReportState extends SharedState {}

class SuccessNotifyState extends SharedState {}

class FailureNotifyState extends SharedState {}

class ViewImageState extends SharedState {
  static String url = "";
}

class SuccessPlacesState extends SharedState {
  static List<MapPlaces> places = [];
}

class FailurePlacesState extends SharedState {}

class SuccessPlaceState extends SharedState {
  static Place places = Place();
}

class FailurePlaceState extends SharedState {}

class MapLocationState extends SharedState {
  static LatLng location = LatLng(
    locationData.latitude!,
    locationData.longitude!,
  );
  static String address = "";
}

class UseMapState extends SharedState {
  static bool useMap = false;
}

class UseBiometricState extends SharedState {
  static bool usebiometric = false;
}

class ValidUserSubscriptionState extends SharedState {
  static bool isValid = false;
}

class SuccessDeleteUserSubscriptionState extends SharedState {}

class FailureDeleteUserSubscriptionState extends SharedState {}
