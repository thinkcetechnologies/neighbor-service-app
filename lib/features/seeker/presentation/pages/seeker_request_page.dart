import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/models/request.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_request_details_page.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_update_request_page.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/empty_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';

import '../../../../core/core.dart';
import '../widgets/rating_review_form_widget.dart';

class SeekerRequestPage extends StatefulWidget {
  const SeekerRequestPage({super.key});

  @override
  State<SeekerRequestPage> createState() => _SeekerRequestPageState();
}

class _SeekerRequestPageState extends State<SeekerRequestPage> {
  @override
  void initState() {
    context.read<SeekerBloc>().add(GetMyRequestEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SeekerBloc, SeekerState>(
        listener: (context, state) {
          if (state is SuccessMarkAsDoneState) {
            showDialog(
              context: context,
              builder: (context) {
                return RatingReviewFormWidget();
              },
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(text: "MY REQUEST", fontSize: 20),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: SuccessGetMyRequestState.myRequests,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var request = snapshot.data!.docs[index];

                              return Column(
                                children: [
                                  Container(
                                    // padding: EdgeInsets.all(10),
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      child:
                                                          request["withImage"]
                                                              ? Image.network(
                                                                request["imageUrl"]!,
                                                                width: 100,
                                                                height: 116,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                                errorBuilder: (
                                                                  context,
                                                                  _,
                                                                  _,
                                                                ) {
                                                                  return Container();
                                                                },
                                                              )
                                                              : Image.asset(
                                                                logo2Assets,
                                                                width: 100,
                                                                height: 116,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                              ),
                                                    ),
                                                    Positioned(
                                                      child: Container(
                                                        width: 100,
                                                        height: 116,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                          color: appBlackColor
                                                              .withAlpha(150),
                                                        ),
                                                        child: Center(
                                                          child: CustomTextWidget(
                                                            text:
                                                                "${request["acceptedUsers"].length}",
                                                            fontSize: 35,
                                                            color:
                                                                appWhiteColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 10),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                      ),
                                                  child: SizedBox(
                                                    width:
                                                        size(context).width -
                                                        133,
                                                    height: 100,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              size(
                                                                context,
                                                              ).width -
                                                              133,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                    size(
                                                                      context,
                                                                    ).width -
                                                                    133,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        CustomTextWidget(
                                                                          text:
                                                                              request["service"].toString().toUpperCase(),
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                        CustomTextWidget(
                                                                          text: DateFormat(
                                                                            "EEEE yyyy-MMMM-dd",
                                                                          ).format(
                                                                            DateTime.parse(
                                                                              request["createAt"],
                                                                            ),
                                                                          ),
                                                                          fontSize:
                                                                              12,
                                                                          color: Theme.of(
                                                                            context,
                                                                          ).textTheme.bodyMedium!.color!.withAlpha(
                                                                            100,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    PopupMenuButton(
                                                                      onSelected: (
                                                                        val,
                                                                      ) {
                                                                        switch (val) {
                                                                          case 1:
                                                                            context
                                                                                .read<
                                                                                  SeekerBloc
                                                                                >()
                                                                                .add(
                                                                                  SeekerRequestDetailEvent(
                                                                                    request: Request.fromJson(
                                                                                      request,
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
                                                                                        3,
                                                                                    widget:
                                                                                        SeekerRequestDetailsPage(),
                                                                                  ),
                                                                                );

                                                                            break;
                                                                          case 2:
                                                                            context
                                                                                .read<
                                                                                  SeekerBloc
                                                                                >()
                                                                                .add(
                                                                                  SeekerRequestDetailEvent(
                                                                                    request: Request.fromJson(
                                                                                      request,
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
                                                                                        3,
                                                                                    widget:
                                                                                        const SeekerUpdateRequestPage(),
                                                                                  ),
                                                                                );
                                                                            break;
                                                                          case 3:
                                                                            context
                                                                                .read<
                                                                                  SeekerBloc
                                                                                >()
                                                                                .add(
                                                                                  DeleteRequestEvent(
                                                                                    request:
                                                                                        request.id,
                                                                                  ),
                                                                                );
                                                                            break;
                                                                          case 4:
                                                                            context
                                                                                .read<
                                                                                  SeekerBloc
                                                                                >()
                                                                                .add(
                                                                                  SetProviderToReviewEvent(
                                                                                    uid:
                                                                                        request["approvedUser"],
                                                                                  ),
                                                                                );
                                                                            if (!request["approved"]) {
                                                                              showDialog(
                                                                                context:
                                                                                    context,
                                                                                builder: (
                                                                                  context,
                                                                                ) {
                                                                                  return SizedBox(
                                                                                    height:
                                                                                        size(
                                                                                          context,
                                                                                        ).height,
                                                                                    width:
                                                                                        size(
                                                                                          context,
                                                                                        ).width,
                                                                                    child: Center(
                                                                                      child: Container(
                                                                                        height:
                                                                                            170,
                                                                                        width:
                                                                                            size(
                                                                                              context,
                                                                                            ).width *
                                                                                            0.80,
                                                                                        padding: EdgeInsets.all(
                                                                                          20,
                                                                                        ),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(
                                                                                            10,
                                                                                          ),
                                                                                          color:
                                                                                              Theme.of(
                                                                                                context,
                                                                                              ).scaffoldBackgroundColor,
                                                                                        ),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            CustomTextWidget(
                                                                                              text:
                                                                                                  "No user have been approved for this request",
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height:
                                                                                                  30,
                                                                                            ),
                                                                                            ButtonWithoutIconWidget(
                                                                                              onPressed: () {
                                                                                                Get.back();
                                                                                              },
                                                                                              color:
                                                                                                  appBlueCardColor,
                                                                                              label:
                                                                                                  "OK",
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            } else {
                                                                              showDialog(
                                                                                context:
                                                                                    context,
                                                                                builder: (
                                                                                  context,
                                                                                ) {
                                                                                  return SizedBox(
                                                                                    height:
                                                                                        size(
                                                                                          context,
                                                                                        ).height,
                                                                                    width:
                                                                                        size(
                                                                                          context,
                                                                                        ).width,
                                                                                    child: Center(
                                                                                      child: Container(
                                                                                        height:
                                                                                            170,
                                                                                        width:
                                                                                            size(
                                                                                              context,
                                                                                            ).width *
                                                                                            0.80,
                                                                                        padding: EdgeInsets.all(
                                                                                          20,
                                                                                        ),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(
                                                                                            10,
                                                                                          ),
                                                                                          color:
                                                                                              Theme.of(
                                                                                                context,
                                                                                              ).scaffoldBackgroundColor,
                                                                                        ),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            CustomTextWidget(
                                                                                              text:
                                                                                                  "This action cannot be undo. Do you want to continue?",
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height:
                                                                                                  30,
                                                                                            ),
                                                                                            Row(
                                                                                              mainAxisAlignment:
                                                                                                  MainAxisAlignment.end,
                                                                                              children: [
                                                                                                TextButton(
                                                                                                  onPressed: () {
                                                                                                    Get.back();
                                                                                                  },
                                                                                                  child: CustomTextWidget(
                                                                                                    text:
                                                                                                        "Cancel",
                                                                                                    color:
                                                                                                        Colors.red,
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width:
                                                                                                      20,
                                                                                                ),
                                                                                                TextButton(
                                                                                                  onPressed: () {
                                                                                                    context
                                                                                                        .read<
                                                                                                          SeekerBloc
                                                                                                        >()
                                                                                                        .add(
                                                                                                          MarkAsDoneEvent(
                                                                                                            request: Request.fromJson(
                                                                                                              request,
                                                                                                            ),
                                                                                                          ),
                                                                                                        );
                                                                                                    context
                                                                                                        .read<
                                                                                                          SeekerBloc
                                                                                                        >()
                                                                                                        .add(
                                                                                                          ReviewProviderEvent(
                                                                                                            canWriteReview:
                                                                                                                true,
                                                                                                          ),
                                                                                                        );
                                                                                                    Get.back();
                                                                                                  },
                                                                                                  child: CustomTextWidget(
                                                                                                    text:
                                                                                                        "Continue",
                                                                                                    color:
                                                                                                        Colors.green,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            }
                                                                            break;
                                                                        }
                                                                      },
                                                                      itemBuilder: (
                                                                        context,
                                                                      ) {
                                                                        return [
                                                                          PopupMenuItem(
                                                                            value:
                                                                                1,
                                                                            child: Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.remove_red_eye,
                                                                                  color:
                                                                                      appBlueCardColor,
                                                                                ),
                                                                                SizedBox(
                                                                                  width:
                                                                                      6,
                                                                                ),
                                                                                CustomTextWidget(
                                                                                  text:
                                                                                      "Details",
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          PopupMenuItem(
                                                                            value:
                                                                                2,
                                                                            child: Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.edit_document,
                                                                                  color:
                                                                                      appBlueCardColor,
                                                                                ),
                                                                                SizedBox(
                                                                                  width:
                                                                                      6,
                                                                                ),
                                                                                CustomTextWidget(
                                                                                  text:
                                                                                      "Edit",
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          PopupMenuItem(
                                                                            value:
                                                                                3,
                                                                            child: Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.delete,
                                                                                  color:
                                                                                      Colors.red,
                                                                                ),
                                                                                SizedBox(
                                                                                  width:
                                                                                      6,
                                                                                ),
                                                                                CustomTextWidget(
                                                                                  text:
                                                                                      "Delete",
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          (request["done"])
                                                                              ? PopupMenuItem(
                                                                                child: CustomTextWidget(
                                                                                  text:
                                                                                      "",
                                                                                ),
                                                                              )
                                                                              : PopupMenuItem(
                                                                                value:
                                                                                    4,
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.check_box,
                                                                                      color:
                                                                                          Colors.green[900],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width:
                                                                                          6,
                                                                                    ),
                                                                                    CustomTextWidget(
                                                                                      text:
                                                                                          "Done",
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
                                                              CustomTextWidget(
                                                                text:
                                                                    request["title"],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                color: Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .color!
                                                                    .withAlpha(
                                                                      150,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              );
                            },
                          );
                        } else {
                          return EmptyWidget(
                            message: "You don't have any request yet",
                            height: size(context).height - 250,
                          );
                        }
                      }
                      return LoadingWidget();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
