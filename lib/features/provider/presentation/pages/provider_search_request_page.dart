import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/core/models/request.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_request_detail_page.dart';
import 'package:nsapp/features/shared/presentation/widget/empty_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/string_constants.dart';
import '../../../messages/presentation/bloc/message_bloc.dart';
import '../../../messages/presentation/pages/chat_page.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';
import '../bloc/provider_bloc.dart';

class ProviderSearchRequestPage extends StatefulWidget {
  const ProviderSearchRequestPage({super.key});

  @override
  State<ProviderSearchRequestPage> createState() =>
      _ProviderSearchRequestPageState();
}

class _ProviderSearchRequestPageState extends State<ProviderSearchRequestPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> requests = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> searchedRequests = [];

  Request search = Request();

  @override
  void initState() {
    context.read<ProviderBloc>().add(SearchRequestEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProviderBloc, ProviderState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SearchBar(
                  leading: Icon(Icons.search),
                  hintText: "Search Request",
                  backgroundColor: WidgetStatePropertyAll(appWhiteColor),
                  onChanged: (value) {
                    searchedRequests = [];
                    if (value.isNotEmpty) {
                      context.read<ProviderBloc>().add(
                        SearchEvent(isSearching: true),
                      );
                      for (var req in requests) {
                        Request rq = Request.fromJson(req);

                        if (rq.title!.toLowerCase().contains(
                              value.toLowerCase(),
                            ) ||
                            rq.service!.toLowerCase().contains(
                              value.toLowerCase(),
                            ) ||
                            rq.description!.toLowerCase().contains(
                              value.toLowerCase(),
                            )) {
                          searchedRequests.add(req);
                        }
                      }
                    } else {
                      context.read<ProviderBloc>().add(
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
                StreamBuilder(
                  stream: SuccessSearchRequestState.requests,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        requests = snapshot.data!.docs;
                        return Center(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                ),

                            itemCount:
                                (SearchingState.isSearching)
                                    ? searchedRequests.length
                                    : snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Request request = Request.fromJson(
                                snapshot.data!.docs[index],
                              );
                              if (SearchingState.isSearching) {
                                search = Request.fromJson(
                                  searchedRequests[index],
                                );
                              }
                              return FutureBuilder<Profile>(
                                future: Helpers.getSeekerProfile(
                                  request.userId!,
                                ),
                                builder: (context, profile) {
                                  if (profile.hasData) {
                                    if (SearchingState.isSearching) {
                                      return Container(
                                        height: 200,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 150,

                                              decoration: BoxDecoration(),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: Image.asset(
                                                  logoAssets,

                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              child: Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: appBlackColor
                                                      .withAlpha(160),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              child: Container(
                                                height: 50,

                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Center(
                                                  child: CustomTextWidget(
                                                    text:
                                                        (SearchingState
                                                                .isSearching)
                                                            ? search.service ??
                                                                ""
                                                            : request.service ??
                                                                "",
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

                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: appBlueCardColor
                                                      .withAlpha(200),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 110,
                                                          child: CustomTextWidget(
                                                            text:
                                                                profile
                                                                    .data!
                                                                    .name ??
                                                                "",
                                                            color:
                                                                appWhiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        CustomTextWidget(
                                                          text: "1.2 km away",
                                                          color: appWhiteColor
                                                              .withAlpha(120),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ],
                                                    ),
                                                    PopupMenuButton(
                                                      iconColor: appWhiteColor,
                                                      onSelected: (val) {
                                                        switch (val) {
                                                          case 1:
                                                            context.read<ProviderBloc>().add(
                                                              RequestDetailEvent(
                                                                request:
                                                                    (SearchingState
                                                                            .isSearching)
                                                                        ? search
                                                                        : request,
                                                                profile:
                                                                    profile
                                                                        .data!,
                                                              ),
                                                            );
                                                            context.read<ProviderBloc>().add(
                                                              ReloadProfileEvent(
                                                                request:
                                                                    (SearchingState
                                                                            .isSearching)
                                                                        ? search
                                                                            .id!
                                                                        : request
                                                                            .id!,
                                                              ),
                                                            );
                                                            context
                                                                .read<
                                                                  ProviderBloc
                                                                >()
                                                                .add(
                                                                  NavigateProviderEvent(
                                                                    page: 1,
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
                                      return Container(
                                        height: 200,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 150,

                                              decoration: BoxDecoration(),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: Image.asset(
                                                  logoAssets,

                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              child: Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: appBlackColor
                                                      .withAlpha(160),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              child: Container(
                                                height: 50,

                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Center(
                                                  child: CustomTextWidget(
                                                    text:
                                                        (SearchingState
                                                                .isSearching)
                                                            ? search.service ??
                                                                ""
                                                            : request.service ??
                                                                "",
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
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: appBlueCardColor
                                                      .withAlpha(200),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 110,
                                                          child: CustomTextWidget(
                                                            text:
                                                                profile
                                                                    .data!
                                                                    .name ??
                                                                "",
                                                            color:
                                                                appWhiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        CustomTextWidget(
                                                          text: "1.2 km away",
                                                          color: appWhiteColor
                                                              .withAlpha(120),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ],
                                                    ),
                                                    PopupMenuButton(
                                                      iconColor: appWhiteColor,
                                                      onSelected: (val) {
                                                        switch (val) {
                                                          case 1:
                                                            context.read<ProviderBloc>().add(
                                                              RequestDetailEvent(
                                                                request:
                                                                    (SearchingState
                                                                            .isSearching)
                                                                        ? search
                                                                        : request,
                                                                profile:
                                                                    profile
                                                                        .data!,
                                                              ),
                                                            );
                                                            context.read<ProviderBloc>().add(
                                                              ReloadProfileEvent(
                                                                request:
                                                                    (SearchingState
                                                                            .isSearching)
                                                                        ? search
                                                                            .id!
                                                                        : request
                                                                            .id!,
                                                              ),
                                                            );
                                                            context
                                                                .read<
                                                                  ProviderBloc
                                                                >()
                                                                .add(
                                                                  NavigateProviderEvent(
                                                                    page: 1,
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
                                    }
                                  } else {
                                    return Skeletonizer(
                                      child: Container(
                                        height: 200,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 150,

                                              decoration: BoxDecoration(),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: Image.asset(
                                                  logoAssets,

                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              child: Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: appBlackColor
                                                      .withAlpha(160),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              child: Container(
                                                height: 50,

                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Center(
                                                  child: CustomTextWidget(
                                                    text: " request.service ??",
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

                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  // color: appBlueCardColor
                                                  //     .withAlpha(200),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 110,
                                                          child: CustomTextWidget(
                                                            text:
                                                                " profile.data!.name ??",
                                                            color:
                                                                appWhiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        CustomTextWidget(
                                                          text: "1.2 km away",
                                                          color: appWhiteColor
                                                              .withAlpha(120),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ],
                                                    ),
                                                    PopupMenuButton(
                                                      iconColor: appWhiteColor,
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
                                                        ];
                                                      },
                                                    ),
                                                  ],
                                                ),
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
