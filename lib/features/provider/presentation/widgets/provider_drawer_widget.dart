import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/features/profile/presentation/pages/about_page.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_accepted_request_page.dart';
import 'package:nsapp/features/shared/presentation/pages/report_page.dart';
import 'package:nsapp/features/shared/presentation/pages/settings_page.dart';
import 'package:nsapp/features/shared/presentation/pages/subscription_page.dart';

import '../../../../core/constants/dimension.dart';
import '../../../../core/constants/string_constants.dart';
import '../../../../core/initialize/init.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';
import '../bloc/provider_bloc.dart';
import '../pages/provider_home_page.dart';

class ProviderDrawerWidget extends StatelessWidget {
  const ProviderDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: size(context).height,
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: appBlueCardColor),
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
                              text: "Provider",
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
                          case 3:
                            Get.back();
                            context.read<ProfileBloc>().add(
                              AboutUserEvent(userID: user!.uid),
                            );
                            context.read<ProviderBloc>().add(
                              NavigateProviderEvent(
                                page: 1,
                                widget: AboutPage(),
                              ),
                            );
                            break;
                          case 4:
                            Get.back();
                            Get.toNamed("/edit-portfolio");
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
                          PopupMenuItem(
                            value: 3,
                            child: Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 6),
                                CustomTextWidget(text: "Portfolio"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 4,
                            child: Row(
                              children: [
                                Icon(Icons.edit_document),
                                SizedBox(width: 6),
                                CustomTextWidget(text: "Edit Portfolio"),
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
              context.read<ProviderBloc>().add(
                NavigateProviderEvent(page: 1, widget: ProviderHomePage()),
              );
              Get.back();
            },
            leading: Icon(Icons.home, size: 20),
            title: CustomTextWidget(text: "Home", fontSize: 16),
          ),
          Divider(),
          ListTile(
            onTap: () {
              context.read<ProviderBloc>().add(
                NavigateProviderEvent(
                  page: NavigatorProviderState.page,
                  widget: ProviderAcceptedRequestPage(),
                ),
              );
              Get.back();
            },
            leading: Icon(Icons.request_page, size: 20),
            title: CustomTextWidget(text: "My Jobs", fontSize: 16),
          ),
          Divider(),
          ListTile(
            onTap: () {
              context.read<ProviderBloc>().add(
                NavigateProviderEvent(
                  page: NavigatorProviderState.page,
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
              context.read<ProviderBloc>().add(
                NavigateProviderEvent(
                  page: NavigatorProviderState.page,
                  widget: SubscriptionPage(),
                ),
              );
              Get.back();
            },
            leading: Icon(Icons.subscriptions_outlined, size: 20),
            title: CustomTextWidget(text: "Subscription", fontSize: 16),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Get.back();
              context.read<ProfileBloc>().add(
                AboutUserEvent(userID: user!.uid),
              );
              context.read<ProviderBloc>().add(
                NavigateProviderEvent(page: 1, widget: AboutPage()),
              );
              Get.back();
            },
            leading: Icon(Icons.person, size: 20),
            title: CustomTextWidget(text: "About", fontSize: 16),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Get.back();
              Get.toNamed("/edit-portfolio");
            },
            leading: Icon(Icons.edit_square, size: 20),
            title: CustomTextWidget(text: "Edit About", fontSize: 16),
          ),
          Divider(),
          ListTile(
            onTap: () {
              context.read<ProviderBloc>().add(
                NavigateProviderEvent(
                  page: NavigatorProviderState.page,
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
