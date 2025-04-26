import 'dart:io' show Platform, exit;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

import '../bloc/shared_bloc.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  init() async {
    final bool dark = await Helpers.getBool("darkmode");
    final bool usebiometric = await Helpers.getBool("usebiometric");
    if (dark) {
      scaffold.currentContext?.read<SharedBloc>().add(
        ToggleThemeModeEvent(themeMode: ThemeMode.dark),
      );
    } else {
      scaffold.currentContext?.read<SharedBloc>().add(
        ToggleThemeModeEvent(themeMode: ThemeMode.light),
      );
    }
    InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          Helpers.getLocation();
          scaffold.currentContext?.read<ProfileBloc>().add(GetProfileEvent());
          Future.delayed(const Duration(seconds: 10), () {
            if (user != null) {
              if (SuccessGetProfileState.profile.name != null) {
                scaffold.currentContext!.read<ProfileBloc>().add(
                  UpdateTokenEvent(),
                );
                if (SuccessGetProfileState.profile.userType == "provider") {
                  scaffold.currentContext!.read<SharedBloc>().add(
                    ToggleDashboardEvent(isProvider: true),
                  );
                }
                if (usebiometric) {
                  scaffold.currentContext?.read<SharedBloc>().add(
                    UseBiometricEvent(usebiometric: true),
                  );
                  Get.offAllNamed('/biometric');
                } else {
                  scaffold.currentContext?.read<SharedBloc>().add(
                    UseBiometricEvent(usebiometric: false),
                  );
                  Get.offAllNamed("/home");
                }
              } else {
                Get.offAllNamed('/add-profile');
              }
            } else {
              Get.offAllNamed('/login');
            }
          });
          break;
        case InternetStatus.disconnected:
          Future.delayed(Duration(seconds: 3), () {
            showDialog(
              context: scaffold.currentContext!,
              builder: (context) {
                return Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: size(context).height,
                    width: size(context).width,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: size(context).width * 0.80,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Column(
                          children: [
                            CustomTextWidget(
                              text:
                                  "To use Neighbor Service, Please turn on your data",
                            ),
                            SizedBox(height: 25),
                            Icon(Icons.wifi_off_sharp, color: Colors.red),
                            SizedBox(height: 25),
                            ButtonWithoutIconWidget(
                              onPressed: () {
                                if (Platform.isAndroid) {
                                  SystemNavigator.pop();
                                } else if (Platform.isIOS) {
                                  exit(0);
                                }
                              },
                              label: "Close",
                              color: appOrangeColor1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          });

          break;
      }
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: SizedBox(
        width: size(context).width,
        height: size(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(logo2Assets, fit: BoxFit.cover),
            CustomTextWidget(
              text:
                  'Connecting your business and\nyour side hustle to customers',

              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
