import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/models/subscription.dart';
import 'package:nsapp/features/shared/presentation/bloc/shared_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimension.dart';
import '../../../../core/initialize/init.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    context.read<SharedBloc>().add(CheckUserSubscriptionEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SharedBloc, SharedState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Center(
            child:
                (ValidUserSubscriptionState.isValid)
                    ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextWidget(text: "You have already subscribe"),
                          SizedBox(height: 20),
                          ButtonWithoutIconWidget(
                            label: "CANCEL SUBSCRIPTION",
                            color: appBlueCardColor,
                            onPressed: () {
                              context.read<SharedBloc>().add(
                                DeleteUserSubscriptionEvent(),
                              );
                              context.read<SharedBloc>().add(
                                CheckUserSubscriptionEvent(),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // Get.bottomSheet(
                            //   const SubscriptionBottomSheet(
                            //     plan: "month",
                            //     amount: "19.99",
                            //   ),
                            // );
                            SubscriptionModel subscriptionModel =
                                SubscriptionModel(
                                  user: user!.uid,
                                  plan: "monthly",
                                );
                            final isSuccess =
                                await Helpers.addUserSubscriptionDetails(
                                  amount: "1999",
                                  context: context,
                                  subscriptionModel: subscriptionModel,
                                );
                            context.read<SharedBloc>().add(
                              CheckUserSubscriptionEvent(),
                            );
                            if (isSuccess) {
                              customAlert(
                                context,
                                AlertType.success,
                                "Subscription Successful",
                              );
                            } else {
                              customAlert(
                                context,
                                AlertType.error,
                                "Subscription Failed",
                              );
                            }
                          },
                          child: Container(
                            width: size(context).width * 0.42,
                            height: 200,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: appOrangeColor1,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextWidget(
                                  text: "Monthly Plan",
                                  color: appWhiteColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomTextWidget(
                                  text: "Auto Renewal",
                                  color: appWhiteColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomTextWidget(
                                  text: "\$19.99/mo",
                                  color: appWhiteColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.check, color: appWhiteColor),
                                    SizedBox(width: 10),
                                    CustomTextWidget(
                                      text: "First Month Free",
                                      color: appWhiteColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.check, color: appWhiteColor),
                                    SizedBox(width: 10),
                                    CustomTextWidget(
                                      text: "Unlimited for 1 month",
                                      color: appWhiteColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.check, color: appWhiteColor),
                                    SizedBox(width: 10),
                                    CustomTextWidget(
                                      text: "No commitments",
                                      color: appWhiteColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.check, color: appWhiteColor),
                                    SizedBox(width: 10),
                                    CustomTextWidget(
                                      text: "Cancel Anytime",
                                      color: appWhiteColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Get.bottomSheet(const SubscriptionBottomSheet(
                            //   plan: "year",
                            //   amount: "215.99",
                            // ));
                            SubscriptionModel subscriptionModel =
                                SubscriptionModel(
                                  user: user!.uid,
                                  plan: "yearly",
                                );
                            final isSuccess =
                                await Helpers.addUserSubscriptionDetails(
                                  amount: "21599",
                                  context: context,
                                  subscriptionModel: subscriptionModel,
                                );
                            context.read<SharedBloc>().add(
                              CheckUserSubscriptionEvent(),
                            );
                            if (isSuccess) {
                              customAlert(
                                context,
                                AlertType.success,
                                "Subscription Successful",
                              );
                            } else {
                              customAlert(
                                context,
                                AlertType.error,
                                "Subscription Failed",
                              );
                            }
                          },
                          child: Container(
                            width: size(context).width * 0.42,
                            height: 200,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: appDeepBlueColor1,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextWidget(
                                  text: "Yearly Plan",
                                  color: appWhiteColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomTextWidget(
                                  text: "Auto Renewal",
                                  color: appWhiteColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomTextWidget(
                                  text: "\$215.99/mo",
                                  color: appWhiteColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.check, color: appWhiteColor),
                                    SizedBox(width: 10),
                                    CustomTextWidget(
                                      text: "10% off",
                                      color: appWhiteColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.check, color: appWhiteColor),
                                    SizedBox(width: 10),
                                    CustomTextWidget(
                                      text: "Unlimited for 1 month",
                                      color: appWhiteColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.check, color: appWhiteColor),
                                    SizedBox(width: 10),
                                    CustomTextWidget(
                                      text: "Cancel Anytime",
                                      color: appWhiteColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
