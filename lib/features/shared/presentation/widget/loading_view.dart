import 'package:flutter/material.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

class LoadingView extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const LoadingView({super.key, required this.child, required this.isLoading});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          widget.child,
          (widget.isLoading)
              ? Container(
                width: size(context).width,
                height: size(context).height,
                decoration: BoxDecoration(color: appBlackColor.withAlpha(230)),
                child: Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: appWhiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0).animate(controller),
                          child: Image.asset(logo2Assets, width: 100),
                        ),
                        CustomTextWidget(text: "Processing", fontSize: 12, color: appBlackColor.withAlpha(150),),
                      ],
                    ),
                  ),
                ),
              )
              : const SizedBox(),
        ],
      ),
    );
  }
}
