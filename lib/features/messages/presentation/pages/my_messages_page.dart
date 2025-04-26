import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/message.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/empty_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/models/profile.dart';
import '../../../provider/presentation/bloc/provider_bloc.dart';
import '../../../shared/presentation/bloc/shared_bloc.dart';
import '../bloc/message_bloc.dart';
import 'chat_page.dart';

class MyMessagesPage extends StatefulWidget {
  const MyMessagesPage({super.key});

  @override
  State<MyMessagesPage> createState() => _MyMessagesPageState();
}

class _MyMessagesPageState extends State<MyMessagesPage> {
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  bool hasData = false;

  @override
  void initState() {
    context.read<MessageBloc>().add(GetMyMessagesEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {
          print(state);
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  child: CustomTextWidget(text: "MY CHATS"),
                ),
                SizedBox(height: 10),
                Divider(),

                (SuccessGetMyMessagesState.myMessages != null)
                    ? ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          (hasData)
                              ? SuccessGetMyMessagesState.myMessages!.length
                              : 1,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                          stream: SuccessGetMyMessagesState.myMessages![index],
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              hasData = true;
                              Message message = Message.fromJson(
                                snapshot.data!.docs.last,
                              );

                              var unReads = 0;
                              for (var unread in snapshot.data!.docs) {
                                if (unread["read"] == false) {
                                  unReads++;
                                }
                              }
                              var chat =
                                  snapshot.data!.docs.last["receiver"] !=
                                          user!.uid
                                      ? snapshot.data!.docs.last["receiver"]
                                      : snapshot.data!.docs.last["sender"];

                              return FutureBuilder<Profile>(
                                future: Helpers.getSeekerProfile(chat),
                                builder: (context, profile) {
                                  if (profile.hasData) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            context.read<MessageBloc>().add(
                                              SetMessageReceiverEvent(
                                                profile: profile.data!,
                                              ),
                                            );
                                            DashboardState.isProvider
                                                ? context
                                                    .read<ProviderBloc>()
                                                    .add(
                                                      NavigateProviderEvent(
                                                        page: 4,
                                                        widget: ChatPage(),
                                                      ),
                                                    )
                                                : context
                                                    .read<SeekerBloc>()
                                                    .add(
                                                      NavigateSeekerEvent(
                                                        page: 4,
                                                        widget: ChatPage(),
                                                      ),
                                                    );
                                          },
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                (profile
                                                            .data!
                                                            .profilePictureUrl !=
                                                        "")
                                                    ? NetworkImage(
                                                      profile
                                                              .data!
                                                              .profilePictureUrl ??
                                                          "",
                                                    )
                                                    : AssetImage(logoAssets),
                                          ),

                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                text: profile.data!.name ?? "",
                                                fontSize: 17,
                                              ),
                                              CustomTextWidget(
                                                text: message.message ?? "",
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color!
                                                    .withAlpha(150),
                                              ),
                                            ],
                                          ),
                                          trailing: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.red,
                                            ),
                                            child: Center(
                                              child: CustomTextWidget(
                                                text: "$unReads",
                                                color: appWhiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                      ],
                                    );
                                  } else {
                                    return Skeletonizer(
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(radius: 20),

                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomTextWidget(
                                                  text: "profile.data!.name",
                                                  fontSize: 17,
                                                ),
                                                CustomTextWidget(
                                                  text: "message.message",
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color!
                                                      .withAlpha(150),
                                                ),
                                              ],
                                            ),
                                            trailing: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.red,
                                              ),
                                              child: Center(
                                                child: CustomTextWidget(
                                                  text: "$unReads",
                                                  color: appWhiteColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            } else {
                              return LoadingWidget();
                            }
                          },
                        );
                      },
                    )
                    : (state is FailureGetMyMessagesState)
                    ? EmptyWidget(
                      message: "Not messages yet!",
                      height: size(context).height - 280,
                    )
                    : LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
