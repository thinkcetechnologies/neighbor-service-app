import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/constants/string_constants.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_request_detail_page.dart';
import 'package:nsapp/features/shared/presentation/widget/empty_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/models/request.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';

class ProviderMoreRequestsPage extends StatefulWidget {
  const ProviderMoreRequestsPage({super.key});

  @override
  State<ProviderMoreRequestsPage> createState() =>
      _ProviderMoreRequestsPageState();
}

class _ProviderMoreRequestsPageState extends State<ProviderMoreRequestsPage> {
  late ScrollController scrollController;
  DocumentSnapshot? documentSnapshot;

  @override
  void initState() {
    context.read<ProviderBloc>().add(
      GetRequestsEvent(documentSnapshot: documentSnapshot),
    );
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      context.read<ProviderBloc>().add(
        GetRequestsEvent(documentSnapshot: documentSnapshot),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProviderBloc, ProviderState>(
        listener: (context, state) {},
        builder: (context, state) {
          return StreamBuilder(
            stream: SuccessGetRequestsState.requests,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  documentSnapshot = snapshot.data!.docs.last;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Request request = Request.fromJson(snapshot.data!.docs[index]);
                      return FutureBuilder<Profile>(
                        future: Helpers.getSeekerProfile(request.userId!),
                        builder: (context, profile) {
                          if (profile.hasData) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(),
                                ListTile(
                                  onTap: (){
                                    context
                                        .read<ProviderBloc>()
                                        .add(
                                      RequestDetailEvent(
                                        request: request,
                                        profile: profile.data!,
                                      ),
                                    );
                                    context
                                        .read<ProviderBloc>()
                                        .add(
                                      ReloadProfileEvent(
                                        request: request.id!,
                                      ),
                                    );
                                    context
                                        .read<ProviderBloc>()
                                        .add(
                                      NavigateProviderEvent(
                                        page: 1,
                                        widget:
                                        ProviderRequestDetailPage(),
                                      ),
                                    );
                                  },
                                  leading:
                                      profile.data!.profilePictureUrl != ""
                                          ? Image.network(
                                            profile.data!.profilePictureUrl!,
                                             height: 240,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          )
                                          : Image.asset(
                                            logoAssets,
                                             height: 240,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),

                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextWidget(
                                        text: profile.data!.name!,
                                      ),
                                      SizedBox(height: 6),
                                      CustomTextWidget(text: request.service!),
                                      SizedBox(height: 6),
                                      CustomTextWidget(text: request.title!),
                                      SizedBox(height: 6),
                                      CustomTextWidget(
                                        text: DateFormat(
                                          "yyyy-MM-dd HH:mm",
                                        ).format(request.createAt!),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color: Theme.of(
                                          context,
                                        ).iconTheme.color!.withAlpha(120),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          } else {
                            return Skeletonizer(child: SizedBox());
                          }
                        },
                      );
                    },
                  );
                } else {
                  return EmptyWidget(
                    message: "No request available at the moment",
                    height: size(context).height - 230,
                  );
                }
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
