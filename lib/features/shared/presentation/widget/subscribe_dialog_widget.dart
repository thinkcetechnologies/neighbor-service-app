import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/constants/dimension.dart';
import '../../../provider/presentation/bloc/provider_bloc.dart';
import '../pages/subscription_page.dart';
import 'custom_text_widget.dart';

class SubscribeDialogWidget extends StatelessWidget {
  const SubscribeDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: size(context).height,
        width: size(context).width,
        child: Center(
          child: Container(
            height: 140,
            width: size(context).width * 0.80,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                CustomTextWidget(
                  text: "You must subscribe to use this feature",
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
                        Get.back();
                        context.read<ProviderBloc>().add(
                          NavigateProviderEvent(
                            page: NavigatorProviderState.page,
                            widget: SubscriptionPage(),
                          ),
                        );
                      },
                      child: CustomTextWidget(
                        text: "Subscribe",
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
  }
}
