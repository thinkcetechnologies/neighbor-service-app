import 'package:get/get.dart';
import 'package:nsapp/features/authentications/presentation/pages/login_auth_page.dart';
import 'package:nsapp/features/authentications/presentation/pages/register_auth_page.dart';
import 'package:nsapp/features/authentications/presentation/pages/reset_password_page.dart';
import 'package:nsapp/features/profile/presentation/pages/add_about_page.dart';
import 'package:nsapp/features/profile/presentation/pages/add_profile_auth_page.dart';
import 'package:nsapp/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:nsapp/features/profile/presentation/pages/profile_page.dart';
import 'package:nsapp/features/shared/presentation/pages/biometric_page.dart';
import 'package:nsapp/features/shared/presentation/pages/change_password_page.dart';
import 'package:nsapp/features/shared/presentation/pages/home_page.dart';
import 'package:nsapp/features/shared/presentation/pages/image_view_page.dart';
import 'package:nsapp/features/shared/presentation/pages/map_direction_page.dart';
import 'package:nsapp/features/shared/presentation/pages/map_location_page.dart';
import 'package:nsapp/features/shared/presentation/pages/settings_page.dart';
import 'package:nsapp/features/shared/presentation/pages/splash_screen_page.dart';

List<GetPage<dynamic>> pages = [
  GetPage(name: '/', page: () => SplashScreenPage()),
  GetPage(name: '/login', page: () => LoginAuthPage()),
  GetPage(name: '/register', page: () => RegisterAuthPage()),
  GetPage(name: '/add-profile', page: () => AddProfileAuthPage()),
  GetPage(name: '/home', page: () => HomePage()),
  GetPage(name: '/reset-password', page: () => ResetPasswordPage()),
  GetPage(name: '/profile', page: () => ProfilePage()),
  GetPage(name: '/edit-profile', page: () => EditProfilePage()),
  GetPage(name: '/edit-portfolio', page: () => AddAboutPage()),
  GetPage(name: '/map-location', page: () => MapLocationPage()),
  GetPage(name: "/map-direction", page: () => MapDirectionPage()),
  GetPage(
    name: '/image',
    page: () => ImageViewPage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(name: '/biometric', page: () => BiometricPage()),
  GetPage(name: '/settings', page: () => SettingsPage()),
  GetPage(name: '/change-password', page: () => ChangePasswordPage()),
];
