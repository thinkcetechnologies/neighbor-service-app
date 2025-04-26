// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimension.dart';
import '../../../../core/initialize/init.dart';
import '../../../../core/models/notification.dart' as not;
import '../../../../core/models/rate.dart';
import '../../../../core/models/review.dart';
import '../../../shared/presentation/bloc/shared_bloc.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';

class RatingReviewFormWidget extends StatefulWidget {
  const RatingReviewFormWidget({super.key});

  @override
  State<RatingReviewFormWidget> createState() => _RatingReviewFormWidgetState();
}

class _RatingReviewFormWidgetState extends State<RatingReviewFormWidget> {
  double rate = RatingValueState.rate;
  TextEditingController reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeekerBloc, SeekerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Material(
          color: Colors.transparent,
          child: SizedBox(
            height: size(context).height,
            width: size(context).width,
            child: Center(
              child: Container(
                height: 290,
                width: size(context).width * 0.80,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
                  children: [
                    CustomTextWidget(
                      text: "Rate ${ProviderToReviewState.profile.name}",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    StarRating(
                      rating: RatingValueState.rate,
                      size: 50,
                      color: appOrangeColor1,
                      emptyIcon: Icons.star_border,
                      filledIcon: Icons.star,
                      onRatingChanged: (val) async {
                        rate = await Helpers.averageRate(
                          ProviderToReviewState.profile.id!,
                          val,
                        );
                        context.read<SeekerBloc>().add(
                          SetRatingValueEvent(rate: val),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      minLines: 1,
                      maxLines: 20,
                      controller: reviewTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color!,
                          ),
                        ),
                        hintText: "Type your review...",
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: CustomTextWidget(
                            text: "Cancel",
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            context.read<SeekerBloc>().add(
                              RateEvent(
                                rate: Rate(
                                  id: ProviderToReviewState.profile.id,
                                  rate: RatingValueState.rate,
                                  averageRate: rate,
                                ),
                              ),
                            );
                            if (reviewTextController.text != "") {
                              context.read<ProfileBloc>().add(
                                AddReviewEvent(
                                  review: Review(
                                    message: reviewTextController.text,
                                    user: user!.uid,
                                    to: ProviderToReviewState.profile.id,
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
                            }
                            Get.back();
                          },
                          child: CustomTextWidget(
                            text: "Send",
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
