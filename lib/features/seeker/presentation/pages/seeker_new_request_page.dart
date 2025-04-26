import 'dart:io';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/request.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_request_page.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/input_dropdown_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/input_text_field_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_view.dart';

import '../../../shared/presentation/bloc/shared_bloc.dart';

class SeekerNewRequestPage extends StatefulWidget {
  const SeekerNewRequestPage({super.key});

  @override
  State<SeekerNewRequestPage> createState() => _SeekerNewRequestPageState();
}

class _SeekerNewRequestPageState extends State<SeekerNewRequestPage> {
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController categoryTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController minimumPriceTextController = TextEditingController();
  TextEditingController maximumPriceTextController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  String serviceType = "";

  void clear() {
    titleTextController.text = "";
    descriptionTextController.text = "";

    priceTextController.text = "";
    minimumPriceTextController.text = "";
    maximumPriceTextController.text = "";
  }

  @override
  void initState() {
    if (UseMapState.useMap) {
      locController.text = MapLocationState.address;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SeekerBloc, SeekerState>(
        listener: (context, state) {
          if (state is SuccessCreateRequestState) {
            clear();
            customAlert(
              context,
              AlertType.success,
              "Request updated successfully",
            );
            context.read<SeekerBloc>().add(
              NavigateSeekerEvent(
                page: NavigatorSeekerState.page,
                widget: SeekerRequestPage(),
              ),
            );
          }
          if (state is FailureCreateRequestState) {
            customAlert(context, AlertType.error, "Request update failed");
          }
          if (state is MapLocationState) {
            locController.text = MapLocationState.address;
          }
        },
        builder: (context, state) {
          if (UseMapState.useMap) {
            locController.text = MapLocationState.address;
          }
          return LoadingView(
            isLoading: (state is LoadingSeekerState),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(text: "NEW REQUEST", fontSize: 19),
                    const SizedBox(height: 46.0),
                    InputDropdownWidget(
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
                      label: "SELECT SERVICE TYPE",
                    ),
                    SizedBox(height: 30),
                    InputTextFieldWidget(
                      controller: titleTextController,
                      hintText: "Enter request title!",
                      label: "REQUEST TITLE",
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Title is required";
                        } else if (containSpecial(val)) {
                          return "Please special characters is not allowed";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size(context).width * 0.70,
                          child: InputTextFieldWidget(
                            controller: locController,
                            hintText: "Set location",
                            label: "LOCATION",
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
                    InputTextFieldWidget(
                      controller: descriptionTextController,
                      hintText: "Enter request description!",
                      label: "REQUEST DESCRIPTION",
                      isMultiLine: true,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Description is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(text: "SET PRICE"),
                        SizedBox(height: 10),
                        CustomRadioButton(
                          buttonLables: ["FIXED PRICE", "PRICE RANGE"],
                          defaultSelected: "FIXED PRICE",
                          width: size(context).width * 0.43,
                          height: 50,
                          wrapAlignment: WrapAlignment.spaceBetween,
                          elevation: 0,
                          buttonValues: ["FIXED PRICE", "PRICE RANGE"],
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
                            if (val == "FIXED PRICE") {
                              context.read<SeekerBloc>().add(
                                RequestPriceEvent(fixedPrice: true),
                              );
                            } else {
                              context.read<SeekerBloc>().add(
                                RequestPriceEvent(fixedPrice: false),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    (RequestPriceState.fixedPrice)
                        ? InputTextFieldWidget(
                          controller: priceTextController,
                          hintText: "Enter price!",
                          label: "SET PRICE",
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "price is required";
                            } else if (!val.isNum) {
                              return "Please enter a valid price";
                            }
                            return null;
                          },
                        )
                        : Column(
                          children: [
                            InputTextFieldWidget(
                              controller: minimumPriceTextController,
                              hintText: "Enter minimum price!",
                              label: "SET MINIMUM PRICE",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "price is required";
                                } else if (!val.isNum) {
                                  return "Please enter a valid price";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            InputTextFieldWidget(
                              controller: maximumPriceTextController,
                              hintText: "Enter maximum price!",
                              label: "SET MAXIMUM PRICE",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "price is required";
                                } else if (!val.isNum) {
                                  return "Please enter a valid price";
                                } else if (double.parse(
                                      minimumPriceTextController.text.trim(),
                                    ) >=
                                    double.parse(val)) {
                                  return "Maximum price must be more that minimum price";
                                }
                                return null;
                              },
                            ),
                          ],
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
                                    Get.back();
                                    context.read<SeekerBloc>().add(
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
                                    Get.back();
                                    context.read<SeekerBloc>().add(
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
                        child:
                            (ImageSeekerState.picture == null)
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomTextWidget(text: "SELECT IMAGE"),
                                      SizedBox(height: 10),
                                      Icon(Icons.camera_alt, size: 50),
                                    ],
                                  ),
                                )
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(ImageSeekerState.picture!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                      ),
                    ),
                    (ImageSeekerState.picture != null)
                        ? Column(
                          children: [
                            SizedBox(height: 20),
                            ButtonWithoutIconWidget(
                              onPressed: () {
                                context.read<SeekerBloc>().add(
                                  ClearImageEvent(),
                                );
                              },
                              color: Colors.red,
                              label: "Remove Image",
                            ),
                          ],
                        )
                        : SizedBox(),
                    SizedBox(height: 30),
                    ButtonWithoutIconWidget(
                      color: appDeepBlueColor1,
                      label: "SAVE",
                      onPressed: () {
                        if (!RequestPriceState.fixedPrice) {
                          final minVal = double.tryParse(
                            minimumPriceTextController.text,
                          );
                          final maxVal = double.tryParse(
                            maximumPriceTextController.text,
                          );
                          if (minVal != null) {
                            minimumPriceTextController.text = minVal
                                .toStringAsFixed(2);
                          }
                          if (maxVal != null) {
                            maximumPriceTextController.text = maxVal
                                .toStringAsFixed(2);
                          }
                          if (maxVal == null || minVal == null) {
                            customAlert(
                              context,
                              AlertType.error,
                              "Please enter a valid prices",
                            );

                            return;
                          }
                        } else {
                          final val = double.tryParse(priceTextController.text);
                          if (val != null) {
                            priceTextController.text = val.toStringAsFixed(2);
                          } else {
                            customAlert(
                              context,
                              AlertType.error,
                              "Please enter a valid price",
                            );
                            return;
                          }
                        }
                        Request request = Request(
                          title: titleTextController.text.trim(),
                          description: descriptionTextController.text.trim(),
                          acceptedUsers: [],
                          approved: false,
                          approvedUser: "",
                          done: false,
                          service: serviceType,
                          price:
                              (RequestPriceState.fixedPrice)
                                  ? priceTextController.text.trim()
                                  : "${minimumPriceTextController.text.trim()}-${maximumPriceTextController.text.trim()}",
                          isRangePrice: (!RequestPriceState.fixedPrice),
                          locationAddress: locController.text.trim(),
                          latitude:
                              (UseMapState.useMap)
                                  ? MapLocationState.location.latitude
                                  : locationData.latitude,
                          longitude:
                              (UseMapState.useMap)
                                  ? MapLocationState.location.longitude
                                  : locationData.longitude,
                          withImage: (ImageSeekerState.picture != null),
                        );
                        if (key.currentState!.validate()) {
                          context.read<SeekerBloc>().add(
                            CreateRequestEvent(request: request),
                          );
                        }
                      },
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
