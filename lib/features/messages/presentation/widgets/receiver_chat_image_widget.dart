import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/features/shared/presentation/bloc/shared_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimension.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';

class ReceiverChatImageWidget extends StatelessWidget {
  final String message;
  final DateTime dateTime;
  final bool withText;
  final String imageUrl;

  const ReceiverChatImageWidget({
    super.key,
    required this.message,
    required this.dateTime,
    required this.withText,
    required this.imageUrl,
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
            padding: EdgeInsets.all(2),
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
                GestureDetector(
                  onTap: () {
                    context.read<SharedBloc>().add(
                      SetViewImageEvent(url: imageUrl),
                    );
                    Get.toNamed("/image");
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      width: size(context).width * 0.70,
                    ),
                  ),
                ),
                (withText)
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        CustomTextWidget(text: message, color: appWhiteColor),
                        SizedBox(height: 5),
                      ],
                    )
                    : SizedBox(),
                CustomTextWidget(
                  text: DateFormat("HH:mm").format(dateTime),
                  color: appWhiteColor.withAlpha(130),
                  fontSize: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
