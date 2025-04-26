import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/features/authentications/presentation/bloc/authentication_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/input_text_field_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_view.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailTextController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is SuccessResetPasswordAuthenticationState) {
            Get.snackbar(
              "Success",
              "Password change email is sent to ${emailTextController.text.trim()}",
              duration: Duration(seconds: 5),
            );
            Get.back();
          }
          if (state is FailureResetPasswordAuthenticationState) {
            Get.snackbar(
              "Error",
              "Unable to send email to ${emailTextController.text.trim()}",
              duration: Duration(seconds: 5),
            );
          }
        },
        builder: (context, state) {
          return LoadingView(
            isLoading: (state is LoadingAuthenticationState),
            child: Container(
              width: size(context).width,
              height: size(context).height,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    CustomTextWidget(
                      text: "Forgot Password?",
                      color: appDeepBlueColor1,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                    SizedBox(height: 20),
                    CustomTextWidget(
                      text:
                          "Please enter the email your registered your Neighbor Service account with to reset your password",
                      color: Theme.of(
                        context,
                      ).textTheme.bodyLarge!.color!.withAlpha(120),
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      resetPasswordLogo,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          InputTextFieldWidget(
                            controller: emailTextController,
                            hintText: "Enter your email here",
                            label: "Email",
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Email field is required";
                              } else if (!val.isEmail) {
                                return "Email is invalid";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 40),
                          ButtonWithoutIconWidget(
                            label: "RESET EMAIL",
                            color: appBlueCardColor,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthenticationBloc>().add(
                                  ResetPasswordAuthenticationEvent(
                                    email: emailTextController.text.trim(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
