import 'package:flutter/material.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/constants/string_constants.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  final double height;
  const EmptyWidget({super.key, required this.message, required this.height, });

  @override
  Widget build(BuildContext context) {
    return  Container(
        width: size(context).width,
        height: height,
        decoration: BoxDecoration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(emptyLogo, width: 150, height: 150, fit: BoxFit.cover,),
              SizedBox(height: 30,),
              CustomTextWidget(text: message, textAlign: TextAlign.center,),
            ],
          ),
        ),

    );
  }
}
