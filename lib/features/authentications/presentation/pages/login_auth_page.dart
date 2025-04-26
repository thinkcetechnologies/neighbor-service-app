import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/features/authentications/presentation/bloc/authentication_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/button_with_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/input_text_field_widget.dart';
import 'package:get/get.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_view.dart';

import '../../../profile/presentation/bloc/profile_bloc.dart';

class LoginAuthPage extends StatefulWidget {
  const LoginAuthPage({super.key});

  @override
  State<LoginAuthPage> createState() => _LoginAuthPageState();
}

class _LoginAuthPageState extends State<LoginAuthPage> {
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  initControllers() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  @override
  void initState() {
    super.initState();
    initControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is SuccessLoginAuthenticationState) {
            user = auth.currentUser!;
            context.read<ProfileBloc>().add(GetProfileEvent());
            Future.delayed(Duration(seconds: 2), () {
              if (SuccessGetProfileState.profile.name != null) {
                Get.offAllNamed("/home");
              } else {
                Get.offAllNamed("/add-profile");
              }
            });
          }
        },
        builder: (context, state) {
          return LoadingView(
            isLoading: (state is LoadingAuthenticationState),
            child: Container(
              width: size(context).width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextWidget(
                        text: "Welcome Back",
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: appDeepBlueColor1,
                      ),
                      SizedBox(height: 20),
                      CustomTextWidget(
                        text: "Login to your Neighbor Service account",
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(height: 60),
                      InputTextFieldWidget(
                        controller: emailTextController,
                        hintText: "Enter your email",
                        label: "Email",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Email is required";
                          } else if (!val.isEmail) {
                            return "Invalid email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      InputTextFieldWidget(
                        controller: passwordTextController,
                        hintText: "Enter your password!",
                        label: "Password",
                        obscureText: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Password is required";
                          } else if (val.length < 6) {
                            return "Password must be a minimum of six characters";
                          }
                          return null;
                        },
                      ),
                      (state is FailureLoginAuthenticationState)
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              CustomTextWidget(
                                text:
                                    "Email or password is incorrect, please try again",
                                color: Colors.red,
                              ),
                            ],
                          )
                          : const SizedBox(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("/reset-password");
                            },
                            child: CustomTextWidget(
                              text: "Forgot Password?",
                              color: appDeepBlueColor1,
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ButtonWithoutIconWidget(
                        color: appOrangeColor1,
                        label: "LOGIN",
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            context.read<AuthenticationBloc>().add(
                              LoginAuthenticationEvent(
                                email: emailTextController.text.trim(),
                                password: passwordTextController.text.trim(),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 30),
                      ButtonWithIconWidget(
                        color: appShadowColor,
                        logo: googleLogo,
                        label: "SIGN IN WITH GOOGLE",
                        onPressed: () {
                          context.read<AuthenticationBloc>().add(
                            LoginWithGoogleAuthenticationEvent(),
                          );
                        },
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextWidget(
                            text: "Not having an account yet?",
                            fontSize: 15,
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("/register");
                            },
                            child: CustomTextWidget(
                              text: "Sign Up",
                              color: appOrangeColor1,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
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
      ),
    );
  }
}
