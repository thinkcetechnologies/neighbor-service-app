import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/request_accept.dart';
import 'package:nsapp/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_view.dart';
import 'package:nsapp/features/shared/presentation/widget/subscribe_dialog_widget.dart';

import '../../../../core/models/notification.dart' as not;
import '../../../../core/models/notify.dart';
import '../../../messages/presentation/bloc/message_bloc.dart';
import '../../../messages/presentation/pages/chat_page.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../shared/presentation/bloc/shared_bloc.dart';

class ProviderRequestDetailPage extends StatefulWidget {
  const ProviderRequestDetailPage({super.key});

  @override
  State<ProviderRequestDetailPage> createState() =>
      _ProviderRequestDetailPageState();
}

class _ProviderRequestDetailPageState extends State<ProviderRequestDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProviderBloc, ProviderState>(
        listener: (context, state) {
          if (state is SuccessRequestAcceptState) {
            context.read<ProviderBloc>().add(
              ReloadProfileEvent(request: RequestDetailState.request.id!),
            );
          }
          if (state is SuccessRequestCancelState) {
            context.read<ProviderBloc>().add(
              ReloadProfileEvent(request: RequestDetailState.request.id!),
            );
          }
        },
        builder: (context, state) {
          return LoadingView(
            isLoading: (state is LoadingProviderState),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  CustomTextWidget(text: "Request Details"),
                  Divider(),
                  SizedBox(height: 20),
                  Column(
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
                                    (RequestDetailState
                                                .profile
                                                .profilePictureUrl !=
                                            "")
                                        ? NetworkImage(
                                          RequestDetailState
                                              .profile
                                              .profilePictureUrl!,
                                        )
                                        : AssetImage(logo2Assets),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                    text: RequestDetailState.profile.name!,
                                  ),
                                  CustomTextWidget(
                                    text: RequestDetailState.request.service!,
                                  ),
                                  CustomTextWidget(
                                    text: DateFormat(
                                      "EEEE yyyy-MMMM-dd",
                                    ).format(
                                      RequestDetailState.request.createAt!,
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
                          IconButton(
                            onPressed: () {
                              context.read<MessageBloc>().add(
                                SetMessageReceiverEvent(
                                  profile: RequestDetailState.profile,
                                ),
                              );
                              context.read<ProviderBloc>().add(
                                NavigateProviderEvent(
                                  page: 4,
                                  widget: ChatPage(),
                                ),
                              );
                            },
                            icon: Icon(Icons.chat, size: 35),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      CustomTextWidget(text: RequestDetailState.request.title!),
                      SizedBox(height: 20),
                      CustomTextWidget(
                        text: RequestDetailState.request.description!,
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
                              (RequestDetailState.request.withImage!)
                                  ? GestureDetector(
                                    onTap: () {
                                      context.read<SharedBloc>().add(
                                        SetViewImageEvent(
                                          url:
                                              RequestDetailState
                                                  .request
                                                  .imageUrl!,
                                        ),
                                      );
                                      Get.toNamed("/image");
                                    },
                                    child: Image.network(
                                      RequestDetailState.request.imageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : Image.asset(logoAssets, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextWidget(
                        text: "Budget \$${RequestDetailState.request.price!}",
                      ),
                      SizedBox(height: 20),
                      (SuccessReloadProfileState.exists)
                          ? ButtonWithoutIconWidget(
                            label: "CANCEL REQUEST",
                            onPressed: () {
                              context.read<ProviderBloc>().add(
                                CancelRequestAcceptEvent(
                                  requestAccept: RequestAccept(
                                    requestId: RequestDetailState.request.id!,
                                    uid: user!.uid,
                                  ),
                                ),
                              );
                              context.read<SharedBloc>().add(
                                AddNotificationEvent(
                                  notification: not.Notification(
                                    title: "Request Acceptance canceled",
                                    description:
                                        "${SuccessGetProfileState.profile.name} canceled your request acceptance",
                                    seen: false,
                                    aboutId: RequestDetailState.request.id!,
                                    about: "request",
                                    date: DateTime.now(),
                                    from: user!.uid,
                                    user: RequestDetailState.profile.id,
                                  ),
                                ),
                              );
                              context.read<SharedBloc>().add(
                                SendNotificationEvent(
                                  notify: Notify(
                                    userId: RequestDetailState.profile.id,
                                    title: "Request Acceptance canceled",
                                    body:
                                        "${SuccessGetProfileState.profile.name}  canceled your request acceptance",
                                  ),
                                ),
                              );
                            },
                            color: Colors.red,
                          )
                          : ButtonWithoutIconWidget(
                            label: "ACCEPT REQUEST",
                            onPressed: () {
                              if (ValidUserSubscriptionState.isValid) {
                                context.read<ProviderBloc>().add(
                                  RequestAcceptEvent(
                                    requestAccept: RequestAccept(
                                      requestId: RequestDetailState.request.id!,
                                      uid: user!.uid,
                                    ),
                                  ),
                                );
                                context.read<SharedBloc>().add(
                                  AddNotificationEvent(
                                    notification: not.Notification(
                                      title: "Request Accepted",
                                      description:
                                          "${SuccessGetProfileState.profile.name} accepted your request",
                                      seen: false,
                                      aboutId: RequestDetailState.request.id!,
                                      about: "request",
                                      date: DateTime.now(),
                                      from: user!.uid,
                                      user: RequestDetailState.profile.id,
                                    ),
                                  ),
                                );
                                context.read<SharedBloc>().add(
                                  SendNotificationEvent(
                                    notify: Notify(
                                      userId: RequestDetailState.profile.id,
                                      title: "Request Accepted",
                                      body:
                                          "${SuccessGetProfileState.profile.name} accepted your request",
                                    ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SubscribeDialogWidget();
                                  },
                                );
                              }
                            },
                            color: appBlueCardColor,
                          ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
