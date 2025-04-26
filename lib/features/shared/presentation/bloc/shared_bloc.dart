import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/map_places.dart';
import 'package:nsapp/core/models/notification.dart' as not;
import 'package:nsapp/core/models/notify.dart';
import 'package:nsapp/core/models/place.dart';
import 'package:nsapp/core/models/report.dart';
import 'package:nsapp/features/shared/domain/usecase/add_notification_use_case.dart';
import 'package:nsapp/features/shared/domain/usecase/add_report_use_case.dart';
import 'package:nsapp/features/shared/domain/usecase/get_my_notifications_use_case.dart';
import 'package:nsapp/features/shared/domain/usecase/search_place_use_case.dart';
import 'package:nsapp/features/shared/domain/usecase/search_places_use_case.dart';
import 'package:nsapp/features/shared/domain/usecase/send_notification_use_case.dart';

part 'shared_event.dart';
part 'shared_state.dart';

class SharedBloc extends Bloc<SharedEvent, SharedState> {
  final AddNotificationUseCase addNotificationUseCase;
  final GetMyNotificationsUseCase getMyNotificationsUseCase;
  final AddReportUseCase addReportUseCase;
  final SendNotificationUseCase sendNotificationUseCase;
  final SearchPlaceUseCase searchPlaceUseCase;
  final SearchPlacesUseCase searchPlacesUseCase;

  SharedBloc(
    this.addNotificationUseCase,
    this.getMyNotificationsUseCase,
    this.addReportUseCase,
    this.sendNotificationUseCase,
    this.searchPlaceUseCase,
    this.searchPlacesUseCase,
  ) : super(SharedInitialState()) {
    on<ToggleDashboardEvent>((event, emit) {
      DashboardState.isProvider = event.isProvider;
      emit(DashboardState());
    });
    on<ToggleThemeModeEvent>((event, emit) async {
      if (event.themeMode == ThemeMode.dark) {
        final isSuccess = await Helpers.saveBool("darkmode", true);
        if (isSuccess) {
          ThemeModeState.themeMode = event.themeMode;
        }
      } else {
        final isSuccess = await Helpers.saveBool("darkmode", false);
        if (isSuccess) {
          ThemeModeState.themeMode = event.themeMode;
        }
      }
      emit(ThemeModeState());
    });
    on<AddNotificationEvent>((event, emit) async {
      final results = await addNotificationUseCase(event.notification);
      results.fold(
        (l) => emit(FailureAddNotificationState()),
        (r) => emit(SuccessAddNotificationsState()),
      );
    });

    on<AddReportEvent>((event, emit) async {
      emit(SharedLoadingState());
      final results = await addReportUseCase(event.report);
      results.fold(
        (l) => emit(FailureAddReportState()),
        (r) => emit(SuccessAddReportState()),
      );
    });

    on<SendNotificationEvent>((event, emit) async {
      final results = await sendNotificationUseCase(event.notify);
      results.fold(
        (l) => emit(FailureNotifyState()),
        (r) => emit(SuccessNotifyState()),
      );
    });

    on<SearchPlaceEvent>((event, emit) async {
      final results = await searchPlaceUseCase(event.placeId);
      results.fold((l) => emit(FailurePlaceState()), (r) {
        SuccessPlaceState.places = r;
        emit(SuccessPlaceState());
      });
    });

    on<SearchPlacesEvent>((event, emit) async {
      final results = await searchPlacesUseCase(event.input);
      results.fold((l) => emit(FailurePlacesState()), (r) {
        SuccessPlacesState.places = r;
        emit(SuccessPlacesState());
      });
    });

    on<GetMyNotificationsEvent>((event, emit) async {
      final results = await getMyNotificationsUseCase(event);
      results.fold((l) => emit(FailureGetMyNotificationsState()), (r) {
        SuccessGetMyNotificationsState.notifications = r;
        emit(SuccessGetMyNotificationsState());
      });
    }, transformer: sequential());
    on<SetViewImageEvent>((event, emit) {
      ViewImageState.url = event.url;
      emit(ViewImageState());
    });
    on<UseMapEvent>((event, emit) {
      UseMapState.useMap = event.useMap;
      emit(UseMapState());
    });
    on<MapLocationEvent>((event, emit) async {
      MapLocationState.location = event.location;
      MapLocationState.address = await Helpers.getAddressFromMap(
        event.location,
      );
      emit(MapLocationState());
    });

    on<UseBiometricEvent>((event, emit) async {
      final bool isSuccess = await Helpers.saveBool(
        "usebiometric",
        event.usebiometric,
      );
      if (isSuccess) {
        UseBiometricState.usebiometric = event.usebiometric;
      }
      emit(UseBiometricState());
    });
    on<CheckUserSubscriptionEvent>((event, emit) async {
      final bool isValid = await Helpers.userHasTheValidSubscription();
      ValidUserSubscriptionState.isValid = isValid;
      emit(ValidUserSubscriptionState());
    });
    on<DeleteUserSubscriptionEvent>((event, emit) async {
      final bool isValid = await Helpers.deleteUserSubscriptionDetails();
      if (isValid) {
        emit(SuccessDeleteUserSubscriptionState());
        return;
      }
      return emit(FailureDeleteUserSubscriptionState());
    });
  }
}
