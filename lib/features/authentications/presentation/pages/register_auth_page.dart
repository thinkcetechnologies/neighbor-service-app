import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/features/authentications/presentation/bloc/authentication_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/button_with_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/input_text_field_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_view.dart';

class RegisterAuthPage extends StatefulWidget {
  const RegisterAuthPage({super.key});

  @override
  State<RegisterAuthPage> createState() => _RegisterAuthPageState();
}

class _RegisterAuthPageState extends State<RegisterAuthPage> {
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;
  late TextEditingController confirmPasswordTextController;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  initControllers() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
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
          if(state is FailureRegisterAuthenticationState){
           // Get.snackbar("Error", "Could not register an account. Try again");
          }
          if(state is SuccessRegisterAuthenticationState){
            Get.snackbar("Success", "Email verification is send to ${emailTextController.text}");
            Get.toNamed("/login");
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
                        text: "Sign up for a Neighbor Service account",
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
                      SizedBox(height: 20),
                      InputTextFieldWidget(
                        controller: confirmPasswordTextController,
                        hintText: "Confirm your password!",
                        label: "Confirm Password",
                        obscureText: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Password is required";
                          } else if (val != passwordTextController.text) {
                            return "Passwords don't match";
                          }else if (val.length < 6) {
                            return "Password must be a minimum of six characters";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      ButtonWithoutIconWidget(
                        color: appOrangeColor1,
                        label: "SIGN UP",
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            context.read<AuthenticationBloc>().add(
                              RegisterAuthenticationEvent(
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
                        label: "SIGN UP WITH GOOGLE",
                        onPressed: (){
                          context.read<AuthenticationBloc>().add(LoginWithGoogleAuthenticationEvent());
                        },
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextWidget(
                            text: "Already having an account?",
                            fontSize: 15,
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("/login");
                            },
                            child: CustomTextWidget(
                              text: "Login",
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
