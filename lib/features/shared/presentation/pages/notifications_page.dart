import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/models/notification.dart' as not;
import 'package:nsapp/features/provider/presentation/pages/provider_accepted_request_page.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_request_page.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/empty_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../messages/presentation/bloc/message_bloc.dart';
import '../../../messages/presentation/pages/chat_page.dart';
import '../../../provider/presentation/bloc/provider_bloc.dart';
import '../../../seeker/presentation/bloc/seeker_bloc.dart';
import '../bloc/shared_bloc.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    context.read<SharedBloc>().add(GetMyNotificationsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SharedBloc, SharedState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SizedBox(
            height: size(context).height - 130,
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                SizedBox(height: 20),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: SuccessGetMyNotificationsState.notifications,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            not.Notification notification = not
                                .Notification.fromJson(
                              snapshot.data!.docs[index],
                            );
                            return FutureBuilder(
                              future: Helpers.getSeekerProfile(
                                notification.from!,
                              ),
                              builder: (context, profile) {
                                if (profile.hasData) {
                                  return Column(
                                    children: [
                                      Divider(),
                                      ListTile(
                                        onTap: () {
                                          Get.bottomSheet(
                                            Container(
                                              padding: EdgeInsets.all(20),
                                              width: size(context).width,
                                              height: 300,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).scaffoldBackgroundColor,
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomTextWidget(
                                                      text:
                                                          (notification
                                                                      .about! ==
                                                                  "user")
                                                              ? "FAVORITE"
                                                              : notification
                                                                  .about!
                                                                  .toUpperCase(),
                                                      fontSize: 20,
                                                    ),
                                                    SizedBox(height: 20),
                                                    CustomTextWidget(
                                                      text: notification.title!,
                                                    ),
                                                    SizedBox(height: 20),
                                                    CustomTextWidget(
                                                      text:
                                                          notification
                                                              .description!,
                                                    ),
                                                    (notification.about! ==
                                                            "user")
                                                        ? SizedBox()
                                                        : ButtonWithoutIconWidget(
                                                          onPressed: () {
                                                            Get.back();
                                                            switch (notification
                                                                .about) {
                                                              case "message":
                                                                context
                                                                    .read<
                                                                      MessageBloc
                                                                    >()
                                                                    .add(
                                                                      SetMessageReceiverEvent(
                                                                        profile:
                                                                            profile.data!,
                                                                      ),
                                                                    );
                                                                DashboardState
                                                                        .isProvider
                                                                    ? context
                                                                        .read<
                                                                          ProviderBloc
                                                                        >()
                                                                        .add(
                                                                          NavigateProviderEvent(
                                                                            page:
                                                                                4,
                                                                            widget:
                                                                                ChatPage(),
                                                                          ),
                                                                        )
                                                                    : context
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
                                                              case "request":
                                                                DashboardState
                                                                        .isProvider
                                                                    ? context
                                                                        .read<
                                                                          ProviderBloc
                                                                        >()
                                                                        .add(
                                                                          NavigateProviderEvent(
                                                                            page:
                                                                                3,
                                                                            widget:
                                                                                ProviderAcceptedRequestPage(),
                                                                          ),
                                                                        )
                                                                    : context
                                                                        .read<
                                                                          SeekerBloc
                                                                        >()
                                                                        .add(
                                                                          NavigateSeekerEvent(
                                                                            page:
                                                                                4,
                                                                            widget:
                                                                                SeekerRequestPage(),
                                                                          ),
                                                                        );
                                                                break;
                                                              default:
                                                                break;
                                                            }
                                                          },
                                                          color:
                                                              appBlueCardColor,
                                                          label: "VIEW DETAILS",
                                                        ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        trailing: Icon(
                                          Icons.circle,
                                          color:
                                              (notification.seen!)
                                                  ? Colors.blueGrey
                                                  : Colors.green[900],
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomTextWidget(
                                              text: notification.title ?? "",
                                            ),
                                            CustomTextWidget(
                                              text:
                                                  notification.description ??
                                                  "",
                                            ),
                                            CustomTextWidget(
                                              text: DateFormat(
                                                "EEEE MMMM-dd-yyyy HH:mm",
                                              ).format(notification.date!),
                                              fontSize: 10,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color!
                                                  .withAlpha(150),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  );
                                }
                                return Skeletonizer(
                                  child: ListTile(
                                    trailing: Icon(
                                      Icons.circle,
                                      color:
                                          (notification.seen!)
                                              ? Colors.blueGrey
                                              : Colors.green[900],
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          text: " notification.title ?? ",
                                        ),
                                        CustomTextWidget(
                                          text: "notification.description ",
                                        ),
                                        CustomTextWidget(
                                          text: "EEEE MMMM-dd-yyyy",

                                          fontSize: 10,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!
                                              .withAlpha(150),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else {
                        return EmptyWidget(
                          message: "You don't have notification yet!",
                          height: size(context).height - 230,
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
