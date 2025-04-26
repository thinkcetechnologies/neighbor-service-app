
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/string_constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/models/profile.dart';
import '../../../../core/models/request.dart';
import '../../../shared/presentation/widget/empty_widget.dart';
import '../../../shared/presentation/widget/loading_widget.dart';
import '../bloc/provider_bloc.dart';

class ProviderRequestPostFeedWidget extends StatefulWidget {
  const ProviderRequestPostFeedWidget({super.key});

  @override
  State<ProviderRequestPostFeedWidget> createState() =>
      _ProviderRequestPostFeedWidgetState();
}

class _ProviderRequestPostFeedWidgetState
    extends State<ProviderRequestPostFeedWidget> {
  @override
  void initState() {
    context.read<ProviderBloc>().add(GetRequestsEvent(documentSnapshot: null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProviderBloc, ProviderState>(
        builder: (context, state) {
          return StreamBuilder(
            stream: SuccessGetRequestsState.requests,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    primary: false,
                    itemBuilder: (context, index) {
                      Request request = Request.fromJson(snapshot.data!.docs[index]);
                      return FutureBuilder<Profile>(
                        future: Helpers.getSeekerProfile(request.userId!),
                        builder: (context, profile) {
                          if (profile.hasData) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        profile.data!.profilePictureUrl != ""
                                            ? NetworkImage(
                                              profile.data!.profilePictureUrl!,
                                            )
                                            : AssetImage(logoAssets),
                                  ),
                                  title: Column(
                                    children: [
                                      CustomTextWidget(
                                        text: profile.data!.name!,
                                      ),
                                      CustomTextWidget(text: request.service!),
                                      CustomTextWidget(text: request.title!),
                                      CustomTextWidget(
                                        text: DateFormat(
                                          "yyyy-MM-dd HH:mm",
                                        ).format(request.createAt!),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Skeletonizer(child: ListTile());
                          }
                        },
                      );
                    },
                  );
                } else {
                  return EmptyWidget(
                    message: "No requests available",
                    height: 200,
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
