import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/about.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/contact_input_field_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/input_text_field_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_view.dart';

import '../../../../core/constants/dimension.dart';
import '../../../../core/helpers/helpers.dart';

class AddAboutPage extends StatefulWidget {
  const AddAboutPage({super.key});

  @override
  State<AddAboutPage> createState() => _AddAboutPageState();
}

class _AddAboutPageState extends State<AddAboutPage> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController specificationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  String countryCode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is SuccessAddAboutState) {
            Get.back();
            customAlert(
              context,
              AlertType.success,
              "Portfolio Created Successfully",
            );
          } else if (state is FailureAddAboutState) {
            customAlert(context, AlertType.error, "Failed To Create Portfolio");
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: LoadingView(
              isLoading: (state is LoadingProfileState),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: key,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      CustomTextWidget(
                        text: "Create Portfolio",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 30),
                      InputTextFieldWidget(
                        controller: companyNameController,
                        hintText: "Enter your company name!",
                        label: "Company name",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Company name is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      InputTextFieldWidget(
                        controller: addressController,
                        hintText: "Enter your company address!",
                        label: "Company address",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Company address is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ContactInputFieldWidget(
                        controller: contactController,
                        hintText: "45685454",
                        label: "Company contact",
                        onChange: (code) {
                          countryCode = code!.dialCode!;
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Company contact is required";
                          } else if (!val.isPhoneNumber) {
                            return "Please enter a valid phone number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      InputTextFieldWidget(
                        controller: websiteController,
                        hintText: "Enter your company Website!",
                        label: "Company Website",
                      ),
                      SizedBox(height: 20),
                      InputTextFieldWidget(
                        controller: specificationController,
                        hintText: "Enter your company specification!",
                        label: "Company specification",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Company specification is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      InputTextFieldWidget(
                        controller: descriptionController,
                        hintText: "Enter your company description!",
                        label: "Company description",
                        isMultiLine: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Company description is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      (ImagesProfileState.images == null)
                          ? GestureDetector(
                            onTap: () {
                              context.read<ProfileBloc>().add(
                                SelectImagesFromGalleryEvent(),
                              );
                            },
                            child: Container(
                              width: size(context).width,
                              height: 130,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).iconTheme.color!.withAlpha(100),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomTextWidget(text: "SELECT IMAGES"),
                                    SizedBox(height: 10),
                                    Icon(Icons.camera_alt, size: 50),
                                  ],
                                ),
                              ),
                            ),
                          )
                          : SizedBox(
                            height: 160,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: ImagesProfileState.images!.length + 1,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child:
                                      (index ==
                                              ImagesProfileState.images!.length)
                                          ? GestureDetector(
                                            onTap: () {
                                              context.read<ProfileBloc>().add(
                                                SelectImagesFromGalleryEvent(),
                                              );
                                            },
                                            child: Container(
                                              width: size(context).width * 0.50,
                                              height: 130,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color!
                                                      .withAlpha(100),
                                                ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomTextWidget(
                                                      text: "SELECT IMAGES",
                                                    ),
                                                    SizedBox(height: 10),
                                                    Icon(
                                                      Icons.camera_alt,
                                                      size: 50,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.file(
                                              File(
                                                ImagesProfileState
                                                    .images![index]
                                                    .path,
                                              ),
                                              height: 150,
                                              width: size(context).width * 0.50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                );
                              },
                            ),
                          ),
                      SizedBox(height: 20),
                      ButtonWithoutIconWidget(
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            context.read<ProfileBloc>().add(
                              AddAboutEvent(
                                about: About(
                                  name: companyNameController.text,
                                  address: addressController.text,
                                  contact: contactController.text,
                                  specification: specificationController.text,
                                  countryCode: countryCode,
                                  date: DateTime.now(),
                                  description: descriptionController.text,
                                  website: websiteController.text,
                                  user: user!.uid,
                                ),
                              ),
                            );
                          }
                        },
                        label: "SAVE",
                        color: appBlueCardColor,
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
