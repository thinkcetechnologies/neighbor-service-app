import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_home_page.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_home_page.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

import '../bloc/shared_bloc.dart';

AppBar homeAppBar({
  String? title,
  Color? color,
  Function(bool)? onToggle,
  bool value = false,
  List<PopupMenuEntry<int>>? actions,
  required BuildContext context,
}) => AppBar(
  elevation: 10,
  actions: [
    (SuccessGetProfileState.profile.userType == "provider") ?
    Switch(
      value: value,
      onChanged: onToggle,
      activeColor: appDeepBlueColor1,
      inactiveTrackColor: appOrangeColor1,
      thumbColor: WidgetStatePropertyAll(appWhiteColor),
    ) : SizedBox(),
    PopupMenuButton<int>(
      itemBuilder: (context) {
        return actions!;
      },
      onSelected: (value) {
        switch(value){
          case 1:
            Get.toNamed("/profile");
            break;
          case 2:
            context.read<SharedBloc>().add(
              ToggleThemeModeEvent(themeMode: ThemeMode.dark),
            );
            break;
          case 3:
            context.read<SharedBloc>().add(
              ToggleThemeModeEvent(themeMode: ThemeMode.light),
            );
            break;
          case 4:
            auth.signOut();
            SuccessGetProfileState.profile = Profile();
            NavigatorSeekerState.widget = SeekerHomePage();
            NavigatorSeekerState.page = 1;
            NavigatorProviderState.widget = ProviderHomePage();
            NavigatorProviderState.page = 1;
            Get.offAllNamed("/login");
            break;
        }
      },
    ),
  ],
  title: Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: CustomTextWidget(text: title ?? '', color: appWhiteColor),
  ),
);
