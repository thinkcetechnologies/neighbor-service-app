import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/constants/app_dark_theme.dart';
import 'package:nsapp/core/constants/app_light_theme.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/helpers/pages.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/features/authentications/data/datasource/remote/authentication_remote_data_source_impl.dart';
import 'package:nsapp/features/authentications/data/repository/authenication_repository_impl.dart';
import 'package:nsapp/features/authentications/domain/usecase/login_use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/login_with_google_use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/logout_use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/register_use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/register_with_google_use_case.dart';
import 'package:nsapp/features/authentications/domain/usecase/reset_password_use_case.dart';
import 'package:nsapp/features/authentications/presentation/bloc/authentication_bloc.dart';
import 'package:nsapp/features/messages/data/datasource/remote/message_remote_datasource_impl.dart';
import 'package:nsapp/features/messages/data/repository/messages_repository_impl.dart';
import 'package:nsapp/features/messages/domain/usecase/delete_message_use_case.dart';
import 'package:nsapp/features/messages/domain/usecase/get_messages_use_case.dart';
import 'package:nsapp/features/messages/domain/usecase/reload_message_receiver_use_case.dart';
import 'package:nsapp/features/messages/domain/usecase/send_message_use_case.dart';
import 'package:nsapp/features/messages/domain/usecase/update_message_use_case.dart';
import 'package:nsapp/features/messages/presentation/bloc/message_bloc.dart';
import 'package:nsapp/features/profile/data/datasource/remote/profile_remote_datasource_impl.dart';
import 'package:nsapp/features/profile/data/repository/profile_repository_impl.dart';
import 'package:nsapp/features/profile/domain/usecase/add_about_use_case.dart';
import 'package:nsapp/features/profile/domain/usecase/add_profile_use_case.dart';
import 'package:nsapp/features/profile/domain/usecase/add_review_use_case.dart';
import 'package:nsapp/features/profile/domain/usecase/get_about_use_case.dart';
import 'package:nsapp/features/profile/domain/usecase/get_profile_stream_use_case.dart';
import 'package:nsapp/features/profile/domain/usecase/get_profile_use_case.dart';
import 'package:nsapp/features/profile/domain/usecase/get_reviews_use_case.dart';
import 'package:nsapp/features/profile/domain/usecase/update_device_token_use_case.dart';
import 'package:nsapp/features/profile/domain/usecase/update_profile_use_case.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/provider/data/datasource/remote/provider_remote_datasource_impl.dart';
import 'package:nsapp/features/provider/data/repository/provider_repository_impl.dart';
import 'package:nsapp/features/provider/domain/usecase/accept_request_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/add_appointment_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/cancel_request_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/get_accepted_request_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/get_appointments_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/get_recent_request_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/get_requests_use_case.dart';
import 'package:nsapp/features/provider/domain/usecase/reload_profile_use_case.dart';
import 'package:nsapp/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:nsapp/features/seeker/data/datasource/remote/seeker_remote_datasource_impl.dart';
import 'package:nsapp/features/seeker/data/repository/seeker_repository_impl.dart';
import 'package:nsapp/features/seeker/domain/usecase/add_to_favorite_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/approve_provider_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/cancel_approved_request_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/create_request_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/delete_request_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/get_accepted_users_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/get_appointments_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/get_my_favorites_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/get_my_request_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/get_popular_provider_request_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/mark_as_done_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/rate_provider_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/reload_request_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/remove_from_favorite_use_case.dart';
import 'package:nsapp/features/seeker/domain/usecase/search_provider_use_case.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/shared/data/datasource/remote/shared_remote_datasource_impl.dart';
import 'package:nsapp/features/shared/data/repository/shared_repository_impl.dart';
import 'package:nsapp/features/shared/domain/usecase/add_notification_use_case.dart';
import 'package:nsapp/features/shared/domain/usecase/add_report_use_case.dart';
import 'package:nsapp/features/shared/domain/usecase/get_my_notifications_use_case.dart';
import 'package:nsapp/features/shared/domain/usecase/search_place_use_case.dart';
import 'package:nsapp/features/shared/domain/usecase/search_places_use_case.dart';
import 'package:nsapp/features/shared/domain/usecase/send_notification_use_case.dart';
import 'package:nsapp/features/shared/presentation/bloc/shared_bloc.dart';

import 'core/constants/string_constants.dart';
import 'features/messages/domain/usecase/get_my_messages_use_case.dart';
import 'features/provider/domain/usecase/serach_request_use_case.dart';
import 'features/seeker/domain/usecase/update_request_use_case.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = "merchant.flutter.stripe.test";
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Helpers.requestPermission();
  await messaging.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Get.snackbar("New Notification", message.data["body"]);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    Get.snackbar("New Notification", message.data["body"]);
  });
  await messaging.setAutoInitEnabled(true);

  runApp(const NeighborServiceApp());
}

class NeighborServiceApp extends StatelessWidget {
  const NeighborServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create:
              (context) => AuthenticationBloc(
                LoginUseCase(
                  AuthenicationRepositoryImpl(
                    AuthenticationRemoteDataSourceImpl(),
                  ),
                ),
                RegisterUseCase(
                  AuthenicationRepositoryImpl(
                    AuthenticationRemoteDataSourceImpl(),
                  ),
                ),
                LogoutUseCase(
                  AuthenicationRepositoryImpl(
                    AuthenticationRemoteDataSourceImpl(),
                  ),
                ),
                ResetPasswordUseCase(
                  AuthenicationRepositoryImpl(
                    AuthenticationRemoteDataSourceImpl(),
                  ),
                ),
                LoginWithGoogleUseCase(
                  AuthenicationRepositoryImpl(
                    AuthenticationRemoteDataSourceImpl(),
                  ),
                ),
                RegisterWithGoogleUseCase(
                  AuthenicationRepositoryImpl(
                    AuthenticationRemoteDataSourceImpl(),
                  ),
                ),
              ),
        ),
        BlocProvider<ProfileBloc>(
          create:
              (context) => ProfileBloc(
                AddProfileUseCase(
                  repository: ProfileRepositoryImpl(
                    ProfileRemoteDataSourceImpl(),
                  ),
                ),
                GetProfileUseCase(
                  ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()),
                ),
                GetProfileStreamUseCase(
                  ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()),
                ),
                UpdateProfileUseCase(
                  repository: ProfileRepositoryImpl(
                    ProfileRemoteDataSourceImpl(),
                  ),
                ),
                AddAboutUseCase(
                  repository: ProfileRepositoryImpl(
                    ProfileRemoteDataSourceImpl(),
                  ),
                ),
                AddReviewUseCase(
                  repository: ProfileRepositoryImpl(
                    ProfileRemoteDataSourceImpl(),
                  ),
                ),
                GetAboutUseCase(
                  ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()),
                ),
                GetReviewsUseCase(
                  ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()),
                ),
                UpdateDeviceTokenUseCase(
                  repository: ProfileRepositoryImpl(
                    ProfileRemoteDataSourceImpl(),
                  ),
                ),
              ),
        ),
        BlocProvider<SharedBloc>(
          create:
              (context) => SharedBloc(
                AddNotificationUseCase(
                  SharedRepositoryImpl(SharedRemoteDatasourceImpl()),
                ),
                GetMyNotificationsUseCase(
                  SharedRepositoryImpl(SharedRemoteDatasourceImpl()),
                ),
                AddReportUseCase(
                  SharedRepositoryImpl(SharedRemoteDatasourceImpl()),
                ),
                SendNotificationUseCase(
                  SharedRepositoryImpl(SharedRemoteDatasourceImpl()),
                ),
                SearchPlaceUseCase(
                  SharedRepositoryImpl(SharedRemoteDatasourceImpl()),
                ),
                SearchPlacesUseCase(
                  SharedRepositoryImpl(SharedRemoteDatasourceImpl()),
                ),
              ),
        ),
        BlocProvider<MessageBloc>(
          create:
              (context) => MessageBloc(
                SendMessageUseCase(
                  MessagesRepositoryImpl(MessageRemoteDatasourceImpl()),
                ),
                GetMessagesUseCase(
                  MessagesRepositoryImpl(MessageRemoteDatasourceImpl()),
                ),
                GetMyMessagesUseCase(
                  MessagesRepositoryImpl(MessageRemoteDatasourceImpl()),
                ),
                ReloadMessageReceiverUseCase(
                  MessagesRepositoryImpl(MessageRemoteDatasourceImpl()),
                ),
                DeleteMessageUseCase(
                  MessagesRepositoryImpl(MessageRemoteDatasourceImpl()),
                ),
                UpdateMessageUseCase(
                  MessagesRepositoryImpl(MessageRemoteDatasourceImpl()),
                ),
              ),
        ),
        BlocProvider<SeekerBloc>(
          create:
              (context) => SeekerBloc(
                CreateRequestUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                GetMyRequestUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                GetAcceptedUsersUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                ReloadRequestUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                ApproveProviderUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                CancelApprovedRequestUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                DeleteRequestUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                UpdateRequestUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                GetPopularProviderRequestUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                AddToFavoriteUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                RemoveFromFavoriteUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                GetMyFavoritesUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                GetSeekerAppointmentsUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                SearchProviderUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                MarkAsDoneUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
                RateProviderUseCase(
                  SeekerRepositoryImpl(SeekerRemoteDatasourceImpl()),
                ),
              ),
        ),
        BlocProvider<ProviderBloc>(
          create:
              (context) => ProviderBloc(
                GetRecentRequestUseCase(
                  ProviderRepositoryImpl(ProviderRemoteDatasourceImpl()),
                ),
                AcceptRequestUseCase(
                  ProviderRepositoryImpl(ProviderRemoteDatasourceImpl()),
                ),
                CancelRequestUseCase(
                  ProviderRepositoryImpl(ProviderRemoteDatasourceImpl()),
                ),
                ReloadProfileUseCase(
                  ProviderRepositoryImpl(ProviderRemoteDatasourceImpl()),
                ),
                GetAcceptedRequestUseCase(
                  ProviderRepositoryImpl(ProviderRemoteDatasourceImpl()),
                ),
                AddAppointmentUseCase(
                  ProviderRepositoryImpl(ProviderRemoteDatasourceImpl()),
                ),
                GetAppointmentsUseCase(
                  ProviderRepositoryImpl(ProviderRemoteDatasourceImpl()),
                ),
                GetRequestsUseCase(
                  ProviderRepositoryImpl(ProviderRemoteDatasourceImpl()),
                ),
                SerachRequestUseCase(
                  ProviderRepositoryImpl(ProviderRemoteDatasourceImpl()),
                ),
              ),
        ),
      ],
      child: BlocBuilder<SharedBloc, SharedState>(
        builder: (context, snapshot) {
          return GetMaterialApp(
            title: "Neighbor Service App",
            theme: providerLightTheme,
            darkTheme: providerDarkTheme,
            themeMode: ThemeModeState.themeMode,
            initialRoute: "/",
            getPages: pages,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
