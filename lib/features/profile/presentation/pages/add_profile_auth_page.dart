import 'dart:io';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/contact_input_field_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/input_dropdown_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/input_text_field_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_view.dart';

import '../../../shared/presentation/bloc/shared_bloc.dart';

class AddProfileAuthPage extends StatefulWidget {
  const AddProfileAuthPage({super.key});

  @override
  State<AddProfileAuthPage> createState() => _AddProfileAuthPageState();
}

class _AddProfileAuthPageState extends State<AddProfileAuthPage> {
  late TextEditingController nameTextController;
  late TextEditingController dateOfBirthTextController;

  late TextEditingController contactTextController;
  String gender = "Male";
  String countryCode = "";
  int provider = 1;
  String serviceType = "";
  late GlobalKey<FormState> key;
  bool isImage = true;

  @override
  void initState() {
    nameTextController = TextEditingController();
    dateOfBirthTextController = TextEditingController();

    contactTextController = TextEditingController();
    key = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    locController.text = MapLocationState.address;
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is DateOfBirthProfileState) {
            dateOfBirthTextController.text = DateFormat(
              "MMMM-dd-yyyy",
            ).format(DateOfBirthProfileState.dob);
          }
          if (state is SuccessCreateProfileState) {
            context.read<ProfileBloc>().add(GetProfileEvent());
            Get.snackbar("Success", "Profile Added");
            user = auth.currentUser!;
            Get.offAllNamed("/home");
          }
        },
        builder: (context, state) {
          return LoadingView(
            isLoading: (state is LoadingProfileState),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: size(context).width,
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      CustomTextWidget(
                        text: "ADD PROFILE",
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: appDeepBlueColor1,
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              width: size(context).width,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                              ),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.read<ProfileBloc>().add(
                                        SelectImageFromGalleryEvent(),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomTextWidget(
                                          text: "CHOOSE IMAGE FROM GALLERY",
                                          // color: appDeepBlueColor1,
                                        ),
                                        Icon(
                                          Icons.browse_gallery,
                                          size: 30,
                                          // color: appDeepBlueColor1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  GestureDetector(
                                    onTap: () {
                                      context.read<ProfileBloc>().add(
                                        SelectImageFromCameraEvent(),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomTextWidget(
                                          text: "CHOOSE IMAGE FROM CAMERA",
                                          // color: appDeepBlueColor1,
                                        ),
                                        Icon(
                                          Icons.camera_alt,
                                          size: 30,
                                          // color: appDeepBlueColor1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              (ImageProfileState.profilePicture != null)
                                  ? FileImage(
                                    File(
                                      ImageProfileState.profilePicture!.path,
                                    ),
                                  )
                                  : AssetImage(logo2Assets),

                          backgroundColor: appCardFooterColor,
                        ),
                      ),
                      SizedBox(height: 30),
                      InputTextFieldWidget(
                        controller: nameTextController,
                        hintText: "Enter your name!",
                        label: "Full name",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Name is required";
                          } else if (containSpecial(val)) {
                            return "Please special characters is not allowed";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextWidget(text: "Gender"),
                          SizedBox(height: 10),
                          CustomRadioButton(
                            buttonLables: ["Male", "Female"],
                            defaultSelected: "Male",
                            width: size(context).width * 0.43,
                            height: 50,
                            wrapAlignment: WrapAlignment.spaceBetween,
                            elevation: 0,
                            buttonValues: ["Male", "Female"],
                            unSelectedColor: Theme.of(context).cardColor,
                            unSelectedBorderColor: Colors.transparent,
                            selectedBorderColor: Colors.transparent,
                            selectedColor: appOrangeColor1,
                            radius: 10,
                            buttonTextStyle: ButtonTextStyle(
                              unSelectedColor:
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                            ),
                            radioButtonValue: (val) {
                              gender = val;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size(context).width * 0.70,
                            child: InputTextFieldWidget(
                              controller: dateOfBirthTextController,
                              hintText: "Date of birth",
                              label: "Date Of Birth",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Date of Birth is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 30),
                              GestureDetector(
                                onTap: () {
                                  context.read<ProfileBloc>().add(
                                    SelectDateOfBirthEvent(context: context),
                                  );
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: appOrangeColor1,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.calendar_view_week_sharp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextWidget(text: "User Type"),
                          SizedBox(height: 10),
                          CustomRadioButton(
                            buttonLables: ["JOB SEEKER", "JOB PROVIDER"],
                            defaultSelected: "JOB PROVIDER",
                            width: size(context).width * 0.43,
                            height: 50,
                            wrapAlignment: WrapAlignment.spaceBetween,
                            elevation: 0,
                            buttonValues: ["JOB SEEKER", "JOB PROVIDER"],
                            unSelectedColor: Theme.of(context).cardColor,
                            unSelectedBorderColor: Colors.transparent,
                            selectedBorderColor: Colors.transparent,
                            selectedColor: appOrangeColor1,
                            radius: 10,
                            buttonTextStyle: ButtonTextStyle(
                              unSelectedColor:
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                            ),
                            radioButtonValue: (val) {
                              if (val == "JOB PROVIDER") {
                                context.read<ProfileBloc>().add(
                                  SetUserTypeEvent(userType: 'provider'),
                                );
                              } else {
                                context.read<ProfileBloc>().add(
                                  SetUserTypeEvent(userType: 'seeker'),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size(context).width * 0.70,
                            child: InputTextFieldWidget(
                              controller: locController,
                              hintText: "Location",
                              label: "Select location",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Location is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 30),
                              GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(
                                    Container(
                                      width: size(context).width,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              context.read<SharedBloc>().add(
                                                UseMapEvent(useMap: false),
                                              );
                                              Helpers.getLocation();
                                              locController.text = myAddress;
                                              Get.back();
                                            },
                                            title: CustomTextWidget(
                                              text: "USE CURRENT LOCATION",
                                              // color: appDeepBlueColor1,
                                            ),
                                            trailing: Icon(
                                              Icons.location_on,
                                              size: 30,
                                              // color: appDeepBlueColor1,
                                            ),
                                          ),
                                          Divider(),
                                          ListTile(
                                            onTap: () {
                                              Get.back();
                                              context.read<SharedBloc>().add(
                                                UseMapEvent(useMap: true),
                                              );
                                              Helpers.getLocation();
                                              Get.toNamed("map-location");
                                            },

                                            title: CustomTextWidget(
                                              text: "CHOOSE FROM MAP",
                                              // color: appDeepBlueColor1,
                                            ),
                                            trailing: Icon(
                                              Icons.map,
                                              size: 30,
                                              // color: appDeepBlueColor1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: appOrangeColor1,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.location_pin,
                                      color: appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      ContactInputFieldWidget(
                        controller: contactTextController,
                        hintText: "023456789",
                        label: "Phone number",
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Phone number is required";
                          } else if (containSpecial(val)) {
                            return "Please special characters is not allowed";
                          } else if (!val.isPhoneNumber) {
                            return "Please enter a valid phone number";
                          }
                          return null;
                        },
                        onChange: (val) {
                          countryCode = val!.dialCode!;
                        },
                      ),
                      SizedBox(
                        height:
                            (UserTypeProfileState.userType == 'provider')
                                ? 30
                                : 0,
                      ),
                      (UserTypeProfileState.userType == 'provider')
                          ? InputDropdownWidget(
                            items: [
                              DropdownMenuItem(
                                value: "Developer",
                                child: CustomTextWidget(text: "Developer"),
                              ),
                              DropdownMenuItem(
                                value: "Carpentry",
                                child: CustomTextWidget(text: "Carpentry"),
                              ),
                              DropdownMenuItem(
                                value: "Designer",
                                child: CustomTextWidget(text: "Designer"),
                              ),
                            ],
                            onChange: (val) {
                              serviceType = val!;
                            },
                            label: "Select Your Service type",
                          )
                          : SizedBox(height: 0),
                      SizedBox(height: 40),
                      ButtonWithoutIconWidget(
                        color: appDeepBlueColor1,
                        label: "ADD PROFILE",
                        onPressed: () {
                          if ((UserTypeProfileState.userType == 'provider') &&
                              serviceType == "") {
                            customAlert(
                              context,
                              AlertType.warning,
                              "Please select your service",
                            );
                            return;
                          }
                          Profile profile = Profile(
                            name: nameTextController.text.trim(),
                            email: user!.email,
                            phone: contactTextController.text.trim(),
                            city: city,
                            rating: "0.0",
                            country: country,
                            ratings: [],
                            address: locController.text,
                            gender: gender,
                            myFavorites: [],
                            favorites: [],

                            acceptedRequests: [],
                            birthDate: DateOfBirthProfileState.dob,
                            createdAt: DateTime.now(),
                            zipCode: zipCode,
                            state: countryState,
                            countryCode: countryCode,
                            updatedAt: DateTime.now(),
                            service: serviceType,
                            userType: UserTypeProfileState.userType,
                            latitude:
                                (UseMapState.useMap)
                                    ? MapLocationState.location.latitude
                                    : locationData.latitude,
                            longitude:
                                (UseMapState.useMap)
                                    ? MapLocationState.location.longitude
                                    : locationData.longitude,
                          );
                          if (key.currentState!.validate()) {
                            context.read<ProfileBloc>().add(
                              AddProfileEvent(profile: profile),
                            );
                          } else {}
                        },
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
