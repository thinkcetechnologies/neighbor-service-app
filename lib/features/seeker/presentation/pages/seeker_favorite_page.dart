import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/constants/string_constants.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/empty_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';

import '../../../../core/initialize/init.dart';
import '../../../messages/presentation/bloc/message_bloc.dart';
import '../../../messages/presentation/pages/chat_page.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/pages/about_page.dart';

class SeekerFavoritePage extends StatefulWidget {
  const SeekerFavoritePage({super.key});

  @override
  State<SeekerFavoritePage> createState() => _SeekerFavoritePageState();
}

class _SeekerFavoritePageState extends State<SeekerFavoritePage> {
  @override
  void initState() {
    context.read<SeekerBloc>().add(GetMyFavoritesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SeekerBloc, SeekerState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: "MY FAVORITE PROVIDERS",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                SizedBox(height: 20),
                Divider(),
                StreamBuilder(
                  stream: SuccessGetMyFavoritesState.profiles,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Profile profile = Profile.fromJson(
                              snapshot.data!.docs[index],
                            );

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.color!.withAlpha(140),
                                ),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            (profile.profilePictureUrl! != "")
                                                ? NetworkImage(
                                                  profile.profilePictureUrl!,
                                                )
                                                : AssetImage(logoAssets),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomTextWidget(text: profile.name!),
                                          CustomTextWidget(
                                            text: profile.service!,
                                            fontSize: 10,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color!
                                                .withAlpha(140),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
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
                                        },
                                        child: Icon(Icons.chat),
                                      ),
                                      PopupMenuButton(
                                        iconColor:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge!.color!,
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
                                              context.read<SeekerBloc>().add(
                                                RemoveFromFavoriteEvent(
                                                  userId: profile.id!,
                                                ),
                                              );

                                              break;
                                            case 3:
                                              context.read<SeekerBloc>().add(
                                                AddToFavoriteEvent(
                                                  userId: profile.id!,
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
                                                  Icon(Icons.person),
                                                  SizedBox(width: 6),
                                                  CustomTextWidget(
                                                    text: "About",
                                                  ),
                                                ],
                                              ),
                                            ),
                                            (profile.favorites!.contains(
                                                  user!.uid,
                                                ))
                                                ? PopupMenuItem(
                                                  value: 2,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.favorite_border,
                                                      ),
                                                      SizedBox(width: 6),
                                                      CustomTextWidget(
                                                        text: "Remove Favorite",
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                : PopupMenuItem(
                                                  value: 3,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.favorite_border,
                                                      ),
                                                      SizedBox(width: 6),
                                                      CustomTextWidget(
                                                        text: "Add Favorite",
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
                            );
                          },
                        );
                      } else {
                        return EmptyWidget(
                          message: "You don't have favorite provider yet!",
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
