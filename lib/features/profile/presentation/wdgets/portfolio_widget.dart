import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/models/about.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/empty_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';

class PortfolioWidget extends StatefulWidget {
  const PortfolioWidget({super.key});

  @override
  State<PortfolioWidget> createState() => _PortfolioWidgetState();
}

class _PortfolioWidgetState extends State<PortfolioWidget> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(
      GetAboutEvent(user: PortfolioUserState.userId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: SuccessGetAboutStreamState.about,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.data != null && snapshot.data!.data() != null){
                  About about = About.fromJson(snapshot.data!);
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      CustomTextWidget(
                        text: "COMPANY NAME",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      SizedBox(height: 10),
                      CustomTextWidget(
                        text: (about.name ?? "Not Set").toUpperCase(),
                        color: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.color!.withAlpha(150),
                      ),
                      Divider(),
                      CustomTextWidget(
                        text: "COMPANY ADDRESS",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      SizedBox(height: 10),
                      CustomTextWidget(
                        text: (about.address ?? "Not Set").toUpperCase(),
                        color: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.color!.withAlpha(150),
                      ),
                      Divider(),
                      CustomTextWidget(
                        text: "COMPANY WEBSITE",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      SizedBox(height: 10),
                      (about.website != "")
                          ? CustomTextWidget(
                        text: (about.website ?? "Not Set"),
                        color: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.color!.withAlpha(150),
                      )
                          : CustomTextWidget(text: ("Not Set").toUpperCase()),
                      Divider(),
                      CustomTextWidget(
                        text: "COMPANY CONTACT",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      SizedBox(height: 10),
                      CustomTextWidget(
                        text: (about.contact ?? "Not Set".toUpperCase()),
                        color: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.color!.withAlpha(150),
                      ),
                      Divider(),
                      CustomTextWidget(
                        text: "COMPANY SPECIFICATION",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      SizedBox(height: 10),
                      CustomTextWidget(
                        text: (about.specification ?? "Not Set").toUpperCase(),
                        color: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.color!.withAlpha(150),
                      ),
                      Divider(),
                      CustomTextWidget(
                        text: "COMPANY DESCRIPTION",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      SizedBox(height: 10),
                      CustomTextWidget(
                        text: (about.description ?? "Not Set".toUpperCase()),
                        color: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.color!.withAlpha(150),
                      ),
                      Divider(),
                      (about.imageUrls != null)
                          ? SizedBox(
                        child:
                        (about.imageUrls!.isNotEmpty)
                            ? Row(
                          children: [
                            SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                child: Image.network(
                                  about.imageUrls![0],
                                  height: 140,
                                  width: size(context).width * 0.45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              child: Container(
                                height: 140,
                                width: size(context).width * 0.45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      about.imageUrls![0],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  height: 140,
                                  width: size(context).width * 0.45,
                                  decoration: BoxDecoration(
                                    color: appBlackColor.withAlpha(
                                      200,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: CustomTextWidget(
                                      text:
                                      "+ ${about.imageUrls!.length - 1}",
                                      color: appWhiteColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                            : SizedBox(),
                      )
                          : SizedBox(),
                    ],
                  );
                }else{
                  return EmptyWidget(message: "Portfolio not available", height: size(context).height - 230);
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
