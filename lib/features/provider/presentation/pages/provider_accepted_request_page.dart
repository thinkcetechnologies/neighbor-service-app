import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/string_constants.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_request_detail_page.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/dimension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/models/request.dart';
import '../../../../core/models/request_accept.dart';
import '../../../messages/presentation/bloc/message_bloc.dart';
import '../../../messages/presentation/pages/chat_page.dart';
import '../../../shared/presentation/widget/empty_widget.dart';

class ProviderAcceptedRequestPage extends StatefulWidget {
  const ProviderAcceptedRequestPage({super.key});

  @override
  State<ProviderAcceptedRequestPage> createState() =>
      _ProviderAcceptedRequestPageState();
}

class _ProviderAcceptedRequestPageState
    extends State<ProviderAcceptedRequestPage> {
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.read<ProviderBloc>().add(GetAcceptedRequestEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: BlocConsumer<ProviderBloc, ProviderState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: "MY ACCEPTED REQUESTS",
                  fontWeight: FontWeight.w700,
                ),
                Divider(),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: SuccessGetAcceptRequestState.accepts,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var accepts = snapshot.data!.docs;
                      if (accepts.isNotEmpty) {
                        return ListView.builder(
                          itemCount: accepts.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FutureBuilder<Profile>(
                              future: Helpers.getSeekerProfile(
                                accepts[index]["user"],
                              ),
                              builder: (context, profile) {
                                if (profile.hasData) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 25),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withAlpha(150),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child:
                                                  (accepts[index]["withImage"])
                                                      ? Image.network(
                                                        accepts[index]["imageUrl"],
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                        // loadingBuilder: (context, child, loading) {
                                                        //   return CircularProgressIndicator();
                                                        // },
                                                      )
                                                      : Image.asset(
                                                        logoAssets,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                            ),
                                            Positioned(
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: appBlackColor
                                                      .withAlpha(150),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 40,
                                                    color:
                                                        (accepts[index]["approvedUser"] ==
                                                                "")
                                                            ? appOrangeColor1
                                                            : (accepts[index]["approvedUser"] ==
                                                                user!.uid)
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10),
                                        SizedBox(
                                          height: 100,
                                          width: size(context).width - 133,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
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
                                                            profile
                                                                .data!
                                                                .name ??
                                                            "",
                                                      ),
                                                      CustomTextWidget(
                                                        text: DateFormat(
                                                          "EEEE yyyy-MMMM-dd",
                                                        ).format(
                                                          DateTime.parse(
                                                            accepts[index]["createAt"],
                                                          ),
                                                        ),
                                                        fontSize: 10,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .color!
                                                            .withAlpha(150),
                                                      ),
                                                    ],
                                                  ),
                                                  PopupMenuButton(
                                                    // iconColor: appWhiteColor,
                                                    onSelected: (val) {
                                                      switch (val) {
                                                        case 1:
                                                          context.read<ProviderBloc>().add(
                                                            RequestDetailEvent(
                                                              request:
                                                                  Request.fromJson(
                                                                    accepts[index],
                                                                  ),
                                                              profile:
                                                                  profile.data!,
                                                            ),
                                                          );
                                                          context
                                                              .read<
                                                                ProviderBloc
                                                              >()
                                                              .add(
                                                                ReloadProfileEvent(
                                                                  request:
                                                                      accepts[index]
                                                                          .id,
                                                                ),
                                                              );
                                                          context
                                                              .read<
                                                                ProviderBloc
                                                              >()
                                                              .add(
                                                                NavigateProviderEvent(
                                                                  page: 3,
                                                                  widget:
                                                                      ProviderRequestDetailPage(),
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
                                                                      profile
                                                                          .data!,
                                                                ),
                                                              );
                                                          context
                                                              .read<
                                                                ProviderBloc
                                                              >()
                                                              .add(
                                                                NavigateProviderEvent(
                                                                  page: 4,
                                                                  widget:
                                                                      ChatPage(),
                                                                ),
                                                              );
                                                          break;
                                                        case 3:
                                                          context
                                                              .read<
                                                                MessageBloc
                                                              >()
                                                              .add(
                                                                CalenderAppointmentEvent(
                                                                  setAppointment:
                                                                      true,
                                                                ),
                                                              );
                                                          context
                                                              .read<
                                                                MessageBloc
                                                              >()
                                                              .add(
                                                                SetMessageReceiverEvent(
                                                                  profile:
                                                                      profile
                                                                          .data!,
                                                                ),
                                                              );
                                                          context
                                                              .read<
                                                                ProviderBloc
                                                              >()
                                                              .add(
                                                                NavigateProviderEvent(
                                                                  page: 4,
                                                                  widget:
                                                                      ChatPage(),
                                                                ),
                                                              );
                                                          break;
                                                        case 4:
                                                          context.read<ProviderBloc>().add(
                                                            CancelRequestAcceptEvent(
                                                              requestAccept:
                                                                  RequestAccept(
                                                                    requestId:
                                                                        accepts[index]
                                                                            .id,
                                                                    uid:
                                                                        user!
                                                                            .uid,
                                                                  ),
                                                            ),
                                                          );
                                                          break;
                                                        case 5:
                                                          Helpers.getLocation();
                                                          context.read<ProviderBloc>().add(
                                                            RequestDetailEvent(
                                                              request:
                                                                  Request.fromJson(
                                                                    accepts[index],
                                                                  ),
                                                              profile:
                                                                  profile.data!,
                                                            ),
                                                          );
                                                          Get.toNamed(
                                                            "/map-direction",
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
                                                                    .calendar_month,
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              CustomTextWidget(
                                                                text:
                                                                    "Schedule Appointment",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 4,
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.close),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              CustomTextWidget(
                                                                text: "Cancel",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 5,
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .directions_bus,
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              CustomTextWidget(
                                                                text:
                                                                    "Direction",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ];
                                                    },
                                                  ),
                                                ],
                                              ),
                                              CustomTextWidget(
                                                text: accepts[index]["title"],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Skeletonizer(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  logoAssets,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 40,
                                                      color:
                                                          (accepts[index]["approvedUser"] ==
                                                                  "")
                                                              ? appOrangeColor1
                                                              : (accepts[index]["approvedUser"] ==
                                                                  user!.uid)
                                                              ? Colors.green
                                                              : Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          SizedBox(
                                            height: 100,
                                            width: size(context).width - 133,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
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
                                                              " profile.data!.name",
                                                        ),
                                                        CustomTextWidget(
                                                          text:
                                                              "EEEE yyyy-MMMM-dd",

                                                          fontSize: 10,
                                                          color: Theme.of(
                                                                context,
                                                              )
                                                              .textTheme
                                                              .titleLarge!
                                                              .color!
                                                              .withAlpha(150),
                                                        ),
                                                      ],
                                                    ),
                                                    PopupMenuButton(
                                                      // iconColor: appWhiteColor,
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
                                                        ];
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                CustomTextWidget(
                                                  text: accepts[index]["title"],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      } else {
                        return EmptyWidget(
                          message: "You have not accepted any request yet",
                          height: size(context).height - 250,
                        );
                      }
                    }
                    return LoadingWidget();
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
