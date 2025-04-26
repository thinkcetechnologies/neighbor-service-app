import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/app_colors.dart';

import '../../../../core/constants/dimension.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';

class SenderChatTextWidget extends StatelessWidget {
  final String message;
  final DateTime dateTime;
  final VoidCallback onLongPressed;
  const SenderChatTextWidget({
    super.key,
    required this.message,
    required this.dateTime,
    required this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size(context).width,
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onLongPress: onLongPressed,
            child: Container(
              width: size(context).width * 0.70,
              padding: EdgeInsets.all(7),
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: appDeepBlueColor1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(text: message, color: appWhiteColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomTextWidget(
                        text: DateFormat("HH:mm").format(dateTime),
                        color: appWhiteColor.withAlpha(130),
                        fontSize: 7,
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
  }
}
