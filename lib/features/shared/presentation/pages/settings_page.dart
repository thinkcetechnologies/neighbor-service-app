import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_home_page.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_home_page.dart';
import 'package:nsapp/features/shared/presentation/bloc/shared_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/settings_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final LocalAuthentication localAuthentication = LocalAuthentication();
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: BlocConsumer<SharedBloc, SharedState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                CustomTextWidget(text: "SETTINGS"),
                SizedBox(height: 20),
                SettingsWidget(
                  action: Switch(
                    value: UseBiometricState.usebiometric,
                    onChanged: (val) async {
                      final bool hasBiometric =
                          await localAuthentication.canCheckBiometrics;
                      if (hasBiometric) {
                        final isAuthenticated = await localAuthentication
                            .authenticate(
                              localizedReason: "Unlock neighbor service",
                              options: AuthenticationOptions(
                                biometricOnly: true,
                              ),
                            );
                        if (isAuthenticated) {
                          scaffold.currentContext!.read<SharedBloc>().add(
                            UseBiometricEvent(usebiometric: val),
                          );
                        }
                      } else {
                        customAlert(
                          context,
                          AlertType.warning,
                          "Your may not have biometric support or biometric not setup",
                        );
                      }
                    },
                  ),
                  name: "USE BIOMETRIC",
                ),
                SizedBox(height: 20),
                SettingsWidget(
                  action: Switch(
                    value: ThemeModeState.themeMode == ThemeMode.dark,
                    onChanged: (val) {
                      if (val) {
                        context.read<SharedBloc>().add(
                          ToggleThemeModeEvent(themeMode: ThemeMode.dark),
                        );
                      } else {
                        context.read<SharedBloc>().add(
                          ToggleThemeModeEvent(themeMode: ThemeMode.light),
                        );
                      }
                    },
                  ),
                  name: "ENABLE DARK MODE",
                ),
                SizedBox(height: 20),
                SettingsWidget(
                  action: IconButton(
                    onPressed: () {
                      Get.toNamed("/change-password");
                    },
                    icon: Icon(Icons.password),
                  ),
                  name: "CHANGE PASSWORD",
                ),
                SizedBox(height: 20),
                SettingsWidget(
                  action: IconButton(
                    onPressed: () {
                      auth.signOut();
                      SuccessGetProfileState.profile = Profile();
                      NavigatorSeekerState.widget = SeekerHomePage();
                      NavigatorSeekerState.page = 1;
                      NavigatorProviderState.widget = ProviderHomePage();
                      NavigatorProviderState.page = 1;
                      Get.offAllNamed("/login");
                    },
                    icon: Icon(Icons.logout),
                  ),
                  name: "LOGOUT",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
