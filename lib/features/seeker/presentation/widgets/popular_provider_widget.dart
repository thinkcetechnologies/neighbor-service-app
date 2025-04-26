import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/constants/string_constants.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/notify.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/messages/presentation/pages/chat_page.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/seeker/presentation/widgets/rating_review_form_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/empty_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';

import '../../../messages/presentation/bloc/message_bloc.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/pages/about_page.dart';
import '../../../shared/presentation/bloc/shared_bloc.dart';
import 'package:nsapp/core/models/notification.dart' as not;

class PopularProviderWidget extends StatefulWidget {
  const PopularProviderWidget({super.key});

  @override
  State<PopularProviderWidget> createState() => _PopularProviderWidgetState();
}

class _PopularProviderWidgetState extends State<PopularProviderWidget> {
  @override
  void initState() {
    context.read<SeekerBloc>().add(GetPopularProvidersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeekerBloc, SeekerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          height: 200,
          width: size(context).width,
          decoration: BoxDecoration(),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: SuccessPopularProvidersState.providers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Profile profile = Profile.fromJson(
                        snapshot.data!.docs[index],
                      );
                      return Container(
                        height: 200,
                        width: 160,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child:
                                  (profile.profilePictureUrl != "")
                                      ? Image.network(
                                        profile.profilePictureUrl!,
                                        width: 160,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.asset(
                                        logo2Assets,
                                        width: 160,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                            ),
                            Positioned(
                              child: Container(
                                height: 200,
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: appBlackColor.withAlpha(150),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 2,
                              child:
                                  (profile.favorites!.contains(user!.uid))
                                      ? GestureDetector(
                                        onTap: () {
                                          context.read<SeekerBloc>().add(
                                            RemoveFromFavoriteEvent(
                                              userId: profile.id!,
                                            ),
                                          );
                                          context.read<SharedBloc>().add(
                                            AddNotificationEvent(
                                              notification: not.Notification(
                                                title: "Favorite removed",
                                                description:
                                                    "${SuccessGetProfileState.profile.name} removed you from favorites",
                                                seen: false,
                                                aboutId: profile.id!,
                                                about: "user",
                                                date: DateTime.now(),
                                                from: user!.uid,
                                                user: profile.id!,
                                              ),
                                            ),
                                          );
                                          context.read<SharedBloc>().add(
                                            SendNotificationEvent(
                                              notify: Notify(
                                                userId: profile.id!,
                                                title: "Favorite removed",
                                                body:
                                                    "${SuccessGetProfileState.profile.name} removed you from favorites",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                      )
                                      : GestureDetector(
                                        onTap: () {
                                          context.read<SeekerBloc>().add(
                                            AddToFavoriteEvent(
                                              userId: profile.id!,
                                            ),
                                          );
                                          context.read<SharedBloc>().add(
                                            AddNotificationEvent(
                                              notification: not.Notification(
                                                title: "Favorite added",
                                                description:
                                                    "${SuccessGetProfileState.profile.name} added you as favorite",
                                                seen: false,
                                                aboutId: profile.id!,
                                                about: "user",
                                                date: DateTime.now(),
                                                from: user!.uid,
                                                user: profile.id!,
                                              ),
                                            ),
                                          );
                                          context.read<SharedBloc>().add(
                                            SendNotificationEvent(
                                              notify: Notify(
                                                userId: profile.id!,
                                                title: "Favorite added",
                                                body:
                                                    "${SuccessGetProfileState.profile.name} added you as favorite",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.favorite_border,
                                          color: appWhiteColor,
                                        ),
                                      ),
                            ),
                            Positioned(
                              left: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: appOrangeColor1),
                                  SizedBox(width: 7),
                                  CustomTextWidget(
                                    text: "${profile.rating}",
                                    color: appWhiteColor,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 120,
                                width: 160,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: appDeepBlueColor1,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextWidget(
                                      text: profile.name!,
                                      fontSize: 17,
                                      color: appWhiteColor,
                                    ),
                                    CustomTextWidget(
                                      text: profile.service!,
                                      color: appWhiteColor.withAlpha(100),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: CustomTextWidget(
                                            text: profile.address!,
                                            color: appWhiteColor.withAlpha(150),
                                          ),
                                        ),
                                        PopupMenuButton(
                                          iconColor: appWhiteColor,
                                          onSelected: (val) {
                                            switch (val) {
                                              case 1:
                                                context.read<ProfileBloc>().add(
                                                  AboutUserEvent(
                                                    userID: profile.id!,
                                                  ),
                                                );
                                                context.read<SeekerBloc>().add(
                                                  NavigateSeekerEvent(
                                                    page: 1,
                                                    widget: AboutPage(),
                                                  ),
                                                );
                                                break;
                                              case 2:
                                                context.read<MessageBloc>().add(
                                                  SetMessageReceiverEvent(
                                                    profile: profile,
                                                  ),
                                                );
                                                context.read<SeekerBloc>().add(
                                                  NavigateSeekerEvent(
                                                    page: 4,
                                                    widget: ChatPage(),
                                                  ),
                                                );
                                                break;
                                              case 3:
                                                context.read<SeekerBloc>().add(
                                                  SetProviderToReviewEvent(
                                                    uid: profile.id!,
                                                  ),
                                                );
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return RatingReviewFormWidget();
                                                  },
                                                );
                                                break;
                                            }
                                          },
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                value: 1,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.remove_red_eye),
                                                    SizedBox(width: 6),
                                                    CustomTextWidget(
                                                      text: "Details",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 2,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.chat),
                                                    SizedBox(width: 6),
                                                    CustomTextWidget(
                                                      text: "Chat",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 3,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.remove_red_eye),
                                                    SizedBox(width: 6),
                                                    CustomTextWidget(
                                                      text: "Review",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ];
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return EmptyWidget(
                    message: "No popular provider available at the moment",
                    height: 180,
                  );
                }
              } else {
                return LoadingWidget();
              }
            },
          ),
        );
      },
    );
  }
}
