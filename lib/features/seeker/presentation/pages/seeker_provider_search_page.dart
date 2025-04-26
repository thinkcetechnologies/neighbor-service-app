import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimension.dart';
import '../../../../core/constants/string_constants.dart';
import '../../../../core/initialize/init.dart';
import '../../../../core/models/notification.dart' as not;
import '../../../../core/models/notify.dart';
import '../../../../core/models/profile.dart';
import '../../../messages/presentation/bloc/message_bloc.dart';
import '../../../messages/presentation/pages/chat_page.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/pages/about_page.dart';
import '../../../shared/presentation/bloc/shared_bloc.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';
import '../../../shared/presentation/widget/empty_widget.dart';
import '../../../shared/presentation/widget/loading_widget.dart';

class SeekerProviderSearchPage extends StatefulWidget {
  const SeekerProviderSearchPage({super.key});

  @override
  State<SeekerProviderSearchPage> createState() =>
      _SeekerProviderSearchPageState();
}

class _SeekerProviderSearchPageState extends State<SeekerProviderSearchPage> {
  QuerySnapshot<Map<String, dynamic>>? providers;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> searchedProviders = [];

  Profile search = Profile();

  @override
  void initState() {
    context.read<SeekerBloc>().add(SearchProviderEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SeekerBloc, SeekerState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                SearchBar(
                  leading: Icon(Icons.search),
                  hintText: "Search Provider",
                  backgroundColor: WidgetStatePropertyAll(appWhiteColor),
                  onChanged: (value) {
                    searchedProviders = [];

                    if (value.isNotEmpty) {
                      context.read<SeekerBloc>().add(
                        SearchEvent(isSearching: true),
                      );
                      for (var provider in providers!.docs) {
                        Profile rq = Profile.fromJson(provider);
                        if (rq.name!.toLowerCase().contains(
                              value.toLowerCase(),
                            ) ||
                            rq.service!.toLowerCase().contains(
                              value.toLowerCase(),
                            ) ||
                            rq.address!.toLowerCase().contains(
                              value.toLowerCase(),
                            )) {
                          searchedProviders.add(provider);
                        }
                      }
                    } else {
                      context.read<SeekerBloc>().add(
                        SearchEvent(isSearching: false),
                      );
                    }
                  },
                  autoFocus: true,
                  elevation: WidgetStatePropertyAll(10),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: SuccessSearchProviderState.providers,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        providers = snapshot.data!;

                        return Center(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),

                            itemCount:
                                (SearchingState.isSearching)
                                    ? searchedProviders.length
                                    : snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              if (SearchingState.isSearching) {
                                search = Profile.fromJson(
                                  searchedProviders[index],
                                );

                                if (searchedProviders.isNotEmpty) {
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
                                              (search.profilePictureUrl != "")
                                                  ? Image.network(
                                                    search.profilePictureUrl!,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: appBlackColor.withAlpha(
                                                150,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 2,
                                          child:
                                              (search.favorites!.contains(
                                                    user!.uid,
                                                  ))
                                                  ? GestureDetector(
                                                    onTap: () {
                                                      context
                                                          .read<SeekerBloc>()
                                                          .add(
                                                            RemoveFromFavoriteEvent(
                                                              userId:
                                                                  search.id!,
                                                            ),
                                                          );
                                                      context.read<SharedBloc>().add(
                                                        AddNotificationEvent(
                                                          notification: not.Notification(
                                                            title:
                                                                "Favorite removed",
                                                            description:
                                                                "${SuccessGetProfileState.profile.name} removed you from favorites",
                                                            seen: false,
                                                            aboutId: search.id!,
                                                            about: "user",
                                                            date:
                                                                DateTime.now(),
                                                            from: user!.uid,
                                                            user: search.id!,
                                                          ),
                                                        ),
                                                      );
                                                      context.read<SharedBloc>().add(
                                                        SendNotificationEvent(
                                                          notify: Notify(
                                                            userId: search.id!,
                                                            title:
                                                                "Favorite removed",
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
                                                      context
                                                          .read<SeekerBloc>()
                                                          .add(
                                                            AddToFavoriteEvent(
                                                              userId:
                                                                  search.id!,
                                                            ),
                                                          );
                                                      context.read<SharedBloc>().add(
                                                        AddNotificationEvent(
                                                          notification: not.Notification(
                                                            title:
                                                                "Favorite added",
                                                            description:
                                                                "${SuccessGetProfileState.profile.name} added you as favorite",
                                                            seen: false,
                                                            aboutId: search.id!,
                                                            about: "user",
                                                            date:
                                                                DateTime.now(),
                                                            from: user!.uid,
                                                            user: search.id!,
                                                          ),
                                                        ),
                                                      );
                                                      context.read<SharedBloc>().add(
                                                        SendNotificationEvent(
                                                          notify: Notify(
                                                            userId: search.id!,
                                                            title:
                                                                "Favorite added",
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
                                              Icon(
                                                Icons.star,
                                                color: appOrangeColor1,
                                              ),
                                              SizedBox(width: 7),
                                              CustomTextWidget(
                                                text: search.rating ?? "0.0",
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
                                                bottomRight: Radius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomTextWidget(
                                                  text: search.name!,
                                                  fontSize: 17,
                                                  color: appWhiteColor,
                                                ),
                                                CustomTextWidget(
                                                  text: search.service!,
                                                  color: appWhiteColor
                                                      .withAlpha(100),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      child: CustomTextWidget(
                                                        text: search.address!,
                                                        color: appWhiteColor
                                                            .withAlpha(150),
                                                      ),
                                                    ),
                                                    PopupMenuButton(
                                                      iconColor: appWhiteColor,
                                                      onSelected: (val) {
                                                        switch (val) {
                                                          case 1:
                                                            context
                                                                .read<
                                                                  ProfileBloc
                                                                >()
                                                                .add(
                                                                  AboutUserEvent(
                                                                    userID:
                                                                        search
                                                                            .id!,
                                                                  ),
                                                                );
                                                            context
                                                                .read<
                                                                  SeekerBloc
                                                                >()
                                                                .add(
                                                                  NavigateSeekerEvent(
                                                                    page: 1,
                                                                    widget:
                                                                        AboutPage(),
                                                                  ),
                                                                );
                                                            break;
                                                          case 2:
                                                            context
                                                                .read<
                                                                  MessageBloc
                                                                >()
                                                                .add(
                                                                  SetMessageReceiverEvent(
                                                                    profile:
                                                                        search,
                                                                  ),
                                                                );
                                                            context
                                                                .read<
                                                                  SeekerBloc
                                                                >()
                                                                .add(
                                                                  NavigateSeekerEvent(
                                                                    page: 4,
                                                                    widget:
                                                                        ChatPage(),
                                                                  ),
                                                                );
                                                            break;
                                                          case 3:
                                                            break;
                                                        }
                                                      },
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                ),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                CustomTextWidget(
                                                                  text:
                                                                      "Details",
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.chat,
                                                                ),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
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
                                                                Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                ),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                CustomTextWidget(
                                                                  text:
                                                                      "Review",
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
                                } else {
                                  return EmptyWidget(
                                    message: "No provider match your search",
                                    height: size(context).height - 280,
                                  );
                                }
                              } else {
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: appBlackColor.withAlpha(150),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 2,
                                        child:
                                            (profile.favorites!.contains(
                                                  user!.uid,
                                                ))
                                                ? GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<SeekerBloc>()
                                                        .add(
                                                          RemoveFromFavoriteEvent(
                                                            userId: profile.id!,
                                                          ),
                                                        );
                                                    context.read<SharedBloc>().add(
                                                      AddNotificationEvent(
                                                        notification: not.Notification(
                                                          title:
                                                              "Favorite removed",
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
                                                          title:
                                                              "Favorite removed",
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
                                                    context
                                                        .read<SeekerBloc>()
                                                        .add(
                                                          AddToFavoriteEvent(
                                                            userId: profile.id!,
                                                          ),
                                                        );
                                                    context.read<SharedBloc>().add(
                                                      AddNotificationEvent(
                                                        notification: not.Notification(
                                                          title:
                                                              "Favorite added",
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
                                                          title:
                                                              "Favorite added",
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
                                            Icon(
                                              Icons.star,
                                              color: appOrangeColor1,
                                            ),
                                            SizedBox(width: 7),
                                            CustomTextWidget(
                                              text: profile.rating ?? "0.0",
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                text: profile.name!,
                                                fontSize: 17,
                                                color: appWhiteColor,
                                              ),
                                              CustomTextWidget(
                                                text: profile.service!,
                                                color: appWhiteColor.withAlpha(
                                                  100,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: CustomTextWidget(
                                                      text: profile.address!,
                                                      color: appWhiteColor
                                                          .withAlpha(150),
                                                    ),
                                                  ),
                                                  PopupMenuButton(
                                                    iconColor: appWhiteColor,
                                                    onSelected: (val) {
                                                      switch (val) {
                                                        case 1:
                                                          context
                                                              .read<
                                                                ProfileBloc
                                                              >()
                                                              .add(
                                                                AboutUserEvent(
                                                                  userID:
                                                                      profile
                                                                          .id!,
                                                                ),
                                                              );
                                                          context
                                                              .read<
                                                                SeekerBloc
                                                              >()
                                                              .add(
                                                                NavigateSeekerEvent(
                                                                  page: 1,
                                                                  widget:
                                                                      AboutPage(),
                                                                ),
                                                              );
                                                          break;
                                                        case 2:
                                                          context
                                                              .read<
                                                                MessageBloc
                                                              >()
                                                              .add(
                                                                SetMessageReceiverEvent(
                                                                  profile:
                                                                      profile,
                                                                ),
                                                              );
                                                          context
                                                              .read<
                                                                SeekerBloc
                                                              >()
                                                              .add(
                                                                NavigateSeekerEvent(
                                                                  page: 4,
                                                                  widget:
                                                                      ChatPage(),
                                                                ),
                                                              );
                                                          break;
                                                        case 3:
                                                          break;
                                                      }
                                                    },
                                                    itemBuilder: (context) {
                                                      return [
                                                        PopupMenuItem(
                                                          value: 1,
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
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
                                                              SizedBox(
                                                                width: 6,
                                                              ),
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
                                                              Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
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
                              }
                            },
                          ),
                        );
                      } else {
                        return EmptyWidget(
                          message: "No request available at the moment",
                          height: size(context).height - 280,
                        );
                      }
                    } else {
                      return LoadingWidget();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
