import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/string_constants.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/review.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/empty_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/dimension.dart';
import '../../../../core/models/notification.dart' as not;
import '../../../../core/models/notify.dart';
import '../../../shared/presentation/bloc/shared_bloc.dart';

class ReviewsWidget extends StatefulWidget {
  const ReviewsWidget({super.key});

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  TextEditingController reviewTextController = TextEditingController();

  @override
  void initState() {
    context.read<ProfileBloc>().add(
      GetReviewsEvent(user: PortfolioUserState.userId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: size(context).height - 240,
            width: size(context).width,
            decoration: BoxDecoration(),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        height: size(context).height - 260,
                        decoration: BoxDecoration(),
                        child: StreamBuilder<
                          QuerySnapshot<Map<String, dynamic>>
                        >(
                          stream: SuccessGetReviewStreamState.reviews,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.isNotEmpty) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Review review = Review.fromJson(
                                      snapshot.data!.docs[index],
                                    );
                                    return FutureBuilder(
                                      future: Helpers.getSeekerProfile(
                                        review.to!,
                                      ),
                                      builder: (context, profile) {
                                        if (profile.hasData) {
                                          return Column(
                                            children: [
                                              ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage:
                                                      (profile
                                                                  .data!
                                                                  .profilePictureUrl !=
                                                              "")
                                                          ? NetworkImage(
                                                            profile
                                                                .data!
                                                                .profilePictureUrl!,
                                                          )
                                                          : AssetImage(
                                                            logoAssets,
                                                          ),
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomTextWidget(
                                                      text: profile.data!.name!,
                                                    ),
                                                    CustomTextWidget(
                                                      text: review.message!,
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color!
                                                          .withAlpha(150),
                                                    ),
                                                    CustomTextWidget(
                                                      text: DateFormat(
                                                        "EEEE MMMM-dd-yyyy",
                                                      ).format(review.date!),
                                                      fontSize: 9,
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
                                        } else {
                                          return Skeletonizer(
                                            child: ListTile(
                                              leading: CircleAvatar(radius: 30),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomTextWidget(
                                                    text: "profile.data!.name!",
                                                  ),
                                                  CustomTextWidget(
                                                    text: " review.message!",
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color!
                                                        .withAlpha(150),
                                                  ),
                                                  CustomTextWidget(
                                                    text: "gfgdf trerer",
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
                                  message: "There is no any review yet!",
                                  height: size(context).height - 350,
                                );
                              }
                            } else {
                              return LoadingWidget();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: size(context).width - 20,

                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: size(context).width - 80,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 20,
                              controller: reviewTextController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyLarge!.color!,
                                  ),
                                ),
                                hintText: "Type your review...",
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (reviewTextController.text.trim() == "") {
                                return;
                              }
                              context.read<ProfileBloc>().add(
                                AddReviewEvent(
                                  review: Review(
                                    message: reviewTextController.text,
                                    user: user!.uid,
                                    to: PortfolioUserState.userId,
                                    date: DateTime.now(),
                                  ),
                                ),
                              );
                              context.read<SharedBloc>().add(
                                AddNotificationEvent(
                                  notification: not.Notification(
                                    title: "New Review",
                                    description:
                                        "${SuccessGetProfileState.profile.name} sent '${reviewTextController.text}'",
                                    seen: false,
                                    aboutId: PortfolioUserState.userId,
                                    about: "request",
                                    date: DateTime.now(),
                                    from: user!.uid,
                                    user: PortfolioUserState.userId,
                                  ),
                                ),
                              );
                              context.read<SharedBloc>().add(
                                SendNotificationEvent(
                                  notify: Notify(
                                    userId: PortfolioUserState.userId,
                                    title: "New Review",
                                    body:
                                        "${SuccessGetProfileState.profile.name} sent '${reviewTextController.text}'",
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.send, size: 35),
                          ),
                        ],
                      ),
                    ),
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
