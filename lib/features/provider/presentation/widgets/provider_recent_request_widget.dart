import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/string_constants.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/models/request.dart';
import 'package:nsapp/core/models/request_distance.dart';
import 'package:nsapp/features/messages/presentation/pages/chat_page.dart';
import 'package:nsapp/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_request_detail_page.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';

import '../../../messages/presentation/bloc/message_bloc.dart';
import '../../../shared/presentation/widget/empty_widget.dart';

class ProviderRecentRequestWidget extends StatefulWidget {
  const ProviderRecentRequestWidget({super.key});

  @override
  State<ProviderRecentRequestWidget> createState() =>
      _ProviderRecentRequestWidgetState();
}

class _ProviderRecentRequestWidgetState
    extends State<ProviderRecentRequestWidget> {
  bool nearbyRequest = false;

  @override
  void initState() {
    context.read<ProviderBloc>().add(GetRecentRequestEvent());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProviderBloc, ProviderState>(
        builder: (context, state) {
          return StreamBuilder(
            stream: SuccessGetRecentRequestState.myRequests,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var recent = snapshot.data!.docs[index];
                      Request request = Request.fromJson(recent);
                      return FutureBuilder<RequestDistance>(
                        future: Helpers.getProfile(
                          request.userId!,
                          request.longitude!,
                          request.latitude!,
                        ),
                        builder: (context, seeker) {
                          if (seeker.hasData) {
                            nearbyRequest = true;
                            return Container(
                              width: 160,
                              height: 200,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 160,
                                    decoration: BoxDecoration(),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: Image.asset(
                                        logoAssets,
                                        width: 160,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                      width: 160,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: appBlackColor.withAlpha(160),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                      height: 50,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: CustomTextWidget(
                                          text: request.service ?? "",
                                          color: appWhiteColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      height: 80,
                                      width: 160,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: appBlueCardColor.withAlpha(200),
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: CustomTextWidget(
                                                  text:
                                                      seeker
                                                          .data!
                                                          .profile
                                                          ?.name ??
                                                      "",
                                                  color: appWhiteColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              CustomTextWidget(
                                                text:
                                                    "${seeker.data!.distance} away",
                                                color: appWhiteColor.withAlpha(
                                                  120,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ],
                                          ),
                                          PopupMenuButton(
                                            iconColor: appWhiteColor,
                                            onSelected: (val) {
                                              switch (val) {
                                                case 1:
                                                  context
                                                      .read<ProviderBloc>()
                                                      .add(
                                                        RequestDetailEvent(
                                                          request:
                                                              Request.fromJson(
                                                                recent,
                                                              ),
                                                          profile:
                                                              seeker
                                                                  .data!
                                                                  .profile!,
                                                        ),
                                                      );
                                                  context
                                                      .read<ProviderBloc>()
                                                      .add(
                                                        ReloadProfileEvent(
                                                          request: recent.id,
                                                        ),
                                                      );
                                                  context.read<ProviderBloc>().add(
                                                    NavigateProviderEvent(
                                                      page: 1,
                                                      widget:
                                                          ProviderRequestDetailPage(),
                                                    ),
                                                  );
                                                  break;
                                                case 2:
                                                  context
                                                      .read<MessageBloc>()
                                                      .add(
                                                        SetMessageReceiverEvent(
                                                          profile:
                                                              seeker
                                                                  .data!
                                                                  .profile!,
                                                        ),
                                                      );
                                                  context
                                                      .read<ProviderBloc>()
                                                      .add(
                                                        NavigateProviderEvent(
                                                          page: 4,
                                                          widget: ChatPage(),
                                                        ),
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
                                                        Icons.remove_red_eye,
                                                      ),
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
                                              ];
                                            },
                                          ),
                                        ],
                                      ),
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
                  );
                } else {
                  return EmptyWidget(
                    message: "No recent request at the moment",
                    height: 250,
                  );
                }
              } else if (snapshot.hasError) {
                return SizedBox();
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
