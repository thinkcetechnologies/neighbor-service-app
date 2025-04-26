import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/core/models/request_accept.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_update_request_page.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimension.dart';
import '../../../../core/constants/string_constants.dart';
import '../../../../core/initialize/init.dart';
import '../../../../core/models/notification.dart' as not;
import '../../../../core/models/notify.dart';
import '../../../../core/models/request.dart';
import '../../../messages/presentation/bloc/message_bloc.dart';
import '../../../messages/presentation/pages/chat_page.dart';
import '../../../profile/presentation/pages/about_page.dart';
import '../../../shared/presentation/bloc/shared_bloc.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';
import '../../../shared/presentation/widget/empty_widget.dart';
import '../../../shared/presentation/widget/loading_view.dart';
import '../bloc/seeker_bloc.dart';

class SeekerRequestDetailsPage extends StatefulWidget {
  const SeekerRequestDetailsPage({super.key});

  @override
  State<SeekerRequestDetailsPage> createState() =>
      _SeekerRequestDetailsPageState();
}

class _SeekerRequestDetailsPageState extends State<SeekerRequestDetailsPage> {
  @override
  void initState() {
    context.read<SeekerBloc>().add(
      ReloadRequestEvent(request: SeekerRequestDetailState.request.id!),
    );
    context.read<SeekerBloc>().add(
      GetAcceptedUsersSeekerEvent(
        request: SeekerRequestDetailState.request.id!,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeekerBloc, SeekerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return LoadingView(
          isLoading: (state is LoadingSeekerState),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: SuccessReloadRequestState.request,
              builder: (context, snapshot) {
                var request = snapshot;
                if (request.hasData) {
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      CustomTextWidget(text: "Request Details"),
                      Divider(),
                      SizedBox(height: 20),
                      Skeletonizer(
                        enabled: (!snapshot.hasData),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
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
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          text: snapshot.data!["service"],
                                        ),
                                        CustomTextWidget(
                                          text: DateFormat(
                                            "EEEE yyyy-MMMM-dd",
                                          ).format(
                                            DateTime.parse(
                                              snapshot.data!["createAt"],
                                            ),
                                          ),
                                          fontSize: 11,
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .color!
                                              .withAlpha(120),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                PopupMenuButton(
                                  onSelected: (val) {
                                    switch (val) {
                                      case 1:
                                        context.read<SeekerBloc>().add(
                                          SeekerRequestDetailEvent(
                                            request: Request.fromJson(
                                              request.data,
                                            ),
                                          ),
                                        );
                                        context.read<SeekerBloc>().add(
                                          NavigateSeekerEvent(
                                            page: 3,
                                            widget:
                                                const SeekerUpdateRequestPage(),
                                          ),
                                        );
                                        break;
                                      case 2:
                                        context.read<SeekerBloc>().add(
                                          DeleteRequestEvent(
                                            request: snapshot.data!.id,
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
                                              Icons.edit_document,
                                              color: appBlueCardColor,
                                            ),
                                            SizedBox(width: 6),
                                            CustomTextWidget(text: "Edit"),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 6),
                                            CustomTextWidget(text: "Delete"),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 3,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_box,
                                              color: Colors.green[900],
                                            ),
                                            SizedBox(width: 6),
                                            CustomTextWidget(text: "Done"),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            CustomTextWidget(text: snapshot.data!["title"]),
                            SizedBox(height: 20),
                            CustomTextWidget(
                              text: snapshot.data!["description"],
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge!.color!.withAlpha(120),
                              fontSize: 13,
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: size(context).width,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.titleLarge!.color!.withAlpha(160),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    (snapshot.data!["withImage"])
                                        ? GestureDetector(
                                          onTap: () {
                                            context.read<SharedBloc>().add(
                                              SetViewImageEvent(
                                                url:
                                                    snapshot.data!["imageUrl"]!,
                                              ),
                                            );
                                            Get.toNamed("/image");
                                          },
                                          child: Image.network(
                                            snapshot.data!["imageUrl"]!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        : Image.asset(
                                          logoAssets,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                            SizedBox(height: 20),
                            CustomTextWidget(
                              text: "Budget \$${snapshot.data!["price"]}",
                            ),
                            SizedBox(height: 20),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: SuccessAcceptedUsersState.users,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var users = snapshot.data!.docs;
                                  if (users.isNotEmpty) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: users.length,
                                      itemBuilder: (context, index) {
                                        var myUser = users[index];
                                        return Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .color!
                                                      .withAlpha(140),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    child:
                                                        (myUser["profilePictureUrl"] !=
                                                                "")
                                                            ? Image.network(
                                                              myUser["profilePictureUrl"],
                                                              width: 60,
                                                              height: 60,
                                                              fit: BoxFit.cover,
                                                            )
                                                            : Image.asset(
                                                              logoAssets,
                                                              width: 60,
                                                              height: 60,
                                                              fit: BoxFit.cover,
                                                            ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  SizedBox(
                                                    width:
                                                        size(context).width -
                                                        95,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CustomTextWidget(
                                                              text:
                                                                  myUser["name"],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.star,
                                                                  color:
                                                                      appOrangeColor1,
                                                                  size: 14,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                CustomTextWidget(
                                                                  text: "4.5",
                                                                ),
                                                              ],
                                                            ),
                                                            CustomTextWidget(
                                                              text:
                                                                  myUser["service"],
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            (request.data!["approvedUser"] !=
                                                                    myUser.id)
                                                                ? IconButton(
                                                                  onPressed: () {
                                                                    context
                                                                        .read<
                                                                          SeekerBloc
                                                                        >()
                                                                        .add(
                                                                          ApprovedRequestEvent(
                                                                            requestAccept: RequestAccept(
                                                                              requestId:
                                                                                  SeekerRequestDetailState.request.id!,
                                                                              uid:
                                                                                  myUser.id,
                                                                            ),
                                                                          ),
                                                                        );

                                                                    context
                                                                        .read<
                                                                          SharedBloc
                                                                        >()
                                                                        .add(
                                                                          AddNotificationEvent(
                                                                            notification: not.Notification(
                                                                              title:
                                                                                  "Acceptance Approved",
                                                                              description:
                                                                                  "${SuccessGetProfileState.profile.name} approved your acceptance",
                                                                              seen:
                                                                                  false,
                                                                              aboutId:
                                                                                  myUser.id,
                                                                              about:
                                                                                  "user",
                                                                              date:
                                                                                  DateTime.now(),
                                                                              from:
                                                                                  user!.uid,
                                                                              user:
                                                                                  myUser.id,
                                                                            ),
                                                                          ),
                                                                        );
                                                                    context
                                                                        .read<
                                                                          SharedBloc
                                                                        >()
                                                                        .add(
                                                                          SendNotificationEvent(
                                                                            notify: Notify(
                                                                              userId:
                                                                                  myUser.id,
                                                                              title:
                                                                                  "Acceptance Approved",
                                                                              body:
                                                                                  "${SuccessGetProfileState.profile.name} approved your acceptance",
                                                                            ),
                                                                          ),
                                                                        );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color:
                                                                        Colors
                                                                            .green,
                                                                  ),
                                                                )
                                                                : IconButton(
                                                                  onPressed: () {
                                                                    context
                                                                        .read<
                                                                          SeekerBloc
                                                                        >()
                                                                        .add(
                                                                          CancelApprovedRequestEvent(
                                                                            request:
                                                                                SeekerRequestDetailState.request.id!,
                                                                          ),
                                                                        );
                                                                    context
                                                                        .read<
                                                                          SharedBloc
                                                                        >()
                                                                        .add(
                                                                          AddNotificationEvent(
                                                                            notification: not.Notification(
                                                                              title:
                                                                                  "Approval canceled",
                                                                              description:
                                                                                  "${SuccessGetProfileState.profile.name} canceled your approval",
                                                                              seen:
                                                                                  false,
                                                                              aboutId:
                                                                                  myUser.id,
                                                                              about:
                                                                                  "user",
                                                                              date:
                                                                                  DateTime.now(),
                                                                              from:
                                                                                  user!.uid,
                                                                              user:
                                                                                  myUser.id,
                                                                            ),
                                                                          ),
                                                                        );
                                                                    context
                                                                        .read<
                                                                          SharedBloc
                                                                        >()
                                                                        .add(
                                                                          SendNotificationEvent(
                                                                            notify: Notify(
                                                                              userId:
                                                                                  myUser.id,
                                                                              title:
                                                                                  "Approval canceled",
                                                                              body:
                                                                                  "${SuccessGetProfileState.profile.name} canceled your approval",
                                                                            ),
                                                                          ),
                                                                        );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    color:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                ),
                                                            PopupMenuButton(
                                                              onSelected: (
                                                                val,
                                                              ) {
                                                                switch (val) {
                                                                  case 1:
                                                                    context
                                                                        .read<
                                                                          ProfileBloc
                                                                        >()
                                                                        .add(
                                                                          AboutUserEvent(
                                                                            userID:
                                                                                myUser.id,
                                                                          ),
                                                                        );
                                                                    context
                                                                        .read<
                                                                          SeekerBloc
                                                                        >()
                                                                        .add(
                                                                          NavigateSeekerEvent(
                                                                            page:
                                                                                1,
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
                                                                            profile: Profile.fromJson(
                                                                              myUser,
                                                                            ),
                                                                          ),
                                                                        );
                                                                    context
                                                                        .read<
                                                                          SeekerBloc
                                                                        >()
                                                                        .add(
                                                                          NavigateSeekerEvent(
                                                                            page:
                                                                                4,
                                                                            widget:
                                                                                ChatPage(),
                                                                          ),
                                                                        );
                                                                    break;
                                                                  case 3:
                                                                    context
                                                                        .read<
                                                                          SeekerBloc
                                                                        >()
                                                                        .add(
                                                                          ApprovedRequestEvent(
                                                                            requestAccept: RequestAccept(
                                                                              requestId:
                                                                                  SeekerRequestDetailState.request.id!,
                                                                              uid:
                                                                                  myUser.id,
                                                                            ),
                                                                          ),
                                                                        );
                                                                    context
                                                                        .read<
                                                                          SharedBloc
                                                                        >()
                                                                        .add(
                                                                          AddNotificationEvent(
                                                                            notification: not.Notification(
                                                                              title:
                                                                                  "Acceptance Approved",
                                                                              description:
                                                                                  "${SuccessGetProfileState.profile.name} approved your acceptance",
                                                                              seen:
                                                                                  false,
                                                                              aboutId:
                                                                                  myUser.id,
                                                                              about:
                                                                                  "user",
                                                                              date:
                                                                                  DateTime.now(),
                                                                              from:
                                                                                  user!.uid,
                                                                              user:
                                                                                  myUser.id,
                                                                            ),
                                                                          ),
                                                                        );
                                                                    context
                                                                        .read<
                                                                          SharedBloc
                                                                        >()
                                                                        .add(
                                                                          SendNotificationEvent(
                                                                            notify: Notify(
                                                                              userId:
                                                                                  myUser.id,
                                                                              title:
                                                                                  "Acceptance Approved",
                                                                              body:
                                                                                  "${SuccessGetProfileState.profile.name} approved your acceptance",
                                                                            ),
                                                                          ),
                                                                        );
                                                                    break;
                                                                }
                                                              },

                                                              itemBuilder: (
                                                                context,
                                                              ) {
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
                                                                          width:
                                                                              6,
                                                                        ),
                                                                        CustomTextWidget(
                                                                          text:
                                                                              "About",
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem(
                                                                    value: 2,
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .chat,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              6,
                                                                        ),
                                                                        CustomTextWidget(
                                                                          text:
                                                                              "Chat",
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
                                                                              .check_box_sharp,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              6,
                                                                        ),
                                                                        CustomTextWidget(
                                                                          text:
                                                                              "Approve",
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
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 25),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    return EmptyWidget(
                                      message:
                                          "No acceptance for your request yet!",
                                      height: 200,
                                    );
                                  }
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return LoadingWidget();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
