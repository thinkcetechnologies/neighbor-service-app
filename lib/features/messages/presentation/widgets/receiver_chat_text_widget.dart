import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

class ReceiverChatTextWidget extends StatelessWidget {
  final String message;
  final DateTime dateTime;

  const ReceiverChatTextWidget({
    super.key,
    required this.message,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size(context).width,
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size(context).width * 0.70,
            padding: EdgeInsets.all(7),
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: appOrangeColor1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(text: message, color: appWhiteColor),
                CustomTextWidget(
                  text: DateFormat("HH:mm").format(dateTime),
                  color: appWhiteColor.withAlpha(130),
                  fontSize: 7,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
