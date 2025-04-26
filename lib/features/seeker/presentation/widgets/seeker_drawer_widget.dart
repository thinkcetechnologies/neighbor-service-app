import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_appointment_page.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_home_page.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_request_page.dart';
import 'package:nsapp/features/shared/presentation/pages/report_page.dart';
import 'package:nsapp/features/shared/presentation/pages/settings_page.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

import '../../../../core/constants/string_constants.dart';

class SeekerDrawerWidget extends StatelessWidget {
  const SeekerDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: size(context).height,
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: appOrangeColor1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              (SuccessGetProfileState
                                          .profile
                                          .profilePictureUrl !=
                                      "")
                                  ? NetworkImage(
                                    SuccessGetProfileState
                                        .profile
                                        .profilePictureUrl!,
                                  )
                                  : AssetImage(logo2Assets),
                          radius: 30,
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              text: SuccessGetProfileState.profile.name ?? "",
                              color: appWhiteColor,
                            ),
                            CustomTextWidget(
                              text: "Seeker",
                              color: appWhiteColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    PopupMenuButton(
                      iconColor: appWhiteColor,
                      onSelected: (val) {
                        switch (val) {
                          case 1:
                            Get.back();
                            Get.toNamed("/edit-profile");
                            break;
                          case 2:
                            Get.back();
                            Get.toNamed("/profile");
                            break;
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(Icons.edit_document),
                                SizedBox(width: 6),
                                CustomTextWidget(text: "Edit Profile"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: [
                                Icon(Icons.remove_red_eye),
                                SizedBox(width: 6),
                                CustomTextWidget(text: "Profile"),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),

                CustomTextWidget(
                  text: SuccessGetProfileState.profile.email ?? "",
                  color: appWhiteColor,
                ),
                SizedBox(height: 10),
                CustomTextWidget(text: myAddress, color: appWhiteColor),
              ],
            ),
          ),

          ListTile(
            onTap: () {
              context.read<SeekerBloc>().add(
                NavigateSeekerEvent(page: 1, widget: SeekerHomePage()),
              );
              Get.back();
            },
            leading: Icon(Icons.home, size: 20),
            title: CustomTextWidget(text: "Home", fontSize: 16),
          ),
          Divider(),
          ListTile(
            onTap: () {
              context.read<SeekerBloc>().add(
                NavigateSeekerEvent(
                  page: NavigatorSeekerState.page,
                  widget: SeekerRequestPage(),
                ),
              );
              Get.back();
            },
            leading: Icon(Icons.request_page, size: 20),
            title: CustomTextWidget(text: "My Request", fontSize: 16),
          ),
          Divider(),
          ListTile(
            onTap: () {
              context.read<SeekerBloc>().add(
                NavigateSeekerEvent(
                  page: NavigatorSeekerState.page,
                  widget: ReportPage(),
                ),
              );
              Get.back();
            },
            leading: Icon(Icons.report, size: 20),
            title: CustomTextWidget(text: "Report", fontSize: 16),
          ),
          Divider(),
          ListTile(
            onTap: () {
              context.read<SeekerBloc>().add(
                NavigateSeekerEvent(
                  page: NavigatorSeekerState.page,
                  widget: SeekerAppointmentPage(),
                ),
              );
              Get.back();
            },
            leading: Icon(Icons.calendar_month, size: 20),
            title: CustomTextWidget(text: "Calender", fontSize: 16),
          ),
          Divider(),

          ListTile(
            onTap: () {
              context.read<SeekerBloc>().add(
                NavigateSeekerEvent(
                  page: NavigatorSeekerState.page,
                  widget: SettingsPage(),
                ),
              );
              Get.back();
            },
            leading: Icon(Icons.settings, size: 20),
            title: CustomTextWidget(text: "Settings", fontSize: 16),
          ),
          Divider(),
        ],
      ),
    );
  }
}
