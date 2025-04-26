import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/constants/string_constants.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfileStreamEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: SuccessGetProfileStreamState.profile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Profile profile = Profile.fromJson(snapshot.data!);
                Profile();
                return SizedBox(
                  height: size(context).height,
                  child: Column(
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color:
                              (profile.userType! == "provider")
                                  ? appBlueCardColor
                                  : appOrangeColor1,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          (profile.profilePictureUrl != "")
                                              ? NetworkImage(
                                                profile.profilePictureUrl!,
                                              )
                                              : AssetImage(logoAssets),
                                      radius: 35,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          text: profile.name!,
                                          color: appWhiteColor,
                                        ),
                                        CustomTextWidget(
                                          text: profile.email!,
                                          color: appWhiteColor.withAlpha(150),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.toNamed("/edit-profile");
                                  },
                                  icon: Icon(
                                    Icons.edit_document,
                                    color: appWhiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size(context).height - 210,
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          primary: true,
                          children: [
                            ListTile(
                              leading: CustomTextWidget(text: "EMAIL"),
                              trailing: CustomTextWidget(
                                text: profile.email?.toUpperCase() ?? "",
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: CustomTextWidget(text: "USER TYPE"),
                              trailing: CustomTextWidget(
                                text: profile.userType?.toUpperCase() ?? "",
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: CustomTextWidget(text: "COUNTRY"),
                              trailing: CustomTextWidget(
                                text: profile.country?.toUpperCase() ?? "",
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: CustomTextWidget(text: "PHONE NUMBER"),
                              trailing: CustomTextWidget(
                                text:
                                    "(${profile.countryCode}) ${profile.phone}",
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: CustomTextWidget(text: "ADDRESS"),
                              trailing: CustomTextWidget(
                                text: profile.address?.toUpperCase() ?? "",
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: CustomTextWidget(text: "GENDER"),
                              trailing: CustomTextWidget(
                                text: profile.gender?.toUpperCase() ?? "",
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: CustomTextWidget(text: "STATE"),
                              trailing: CustomTextWidget(
                                text: profile.state?.toUpperCase() ?? "",
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: CustomTextWidget(text: "SERVICE"),
                              trailing: CustomTextWidget(
                                text: profile.service?.toUpperCase() ?? "",
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: CustomTextWidget(text: "DATE OF BIRTH"),
                              trailing: CustomTextWidget(
                                text:
                                    DateFormat(
                                      "EEEE yyyy-MMMM-dd",
                                    ).format(profile.birthDate!).toUpperCase(),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: CustomTextWidget(text: "ZIPCODE"),
                              trailing: CustomTextWidget(
                                text:
                                    profile.zipCode != ""
                                        ? profile.zipCode ?? "NOT SET"
                                        : "NOT SET",
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: CustomTextWidget(text: "FAVORITES"),
                              trailing: CustomTextWidget(
                                text: profile.favorites!.length.toString(),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return LoadingWidget();
              }
            },
          );
        },
      ),
    );
  }
}
