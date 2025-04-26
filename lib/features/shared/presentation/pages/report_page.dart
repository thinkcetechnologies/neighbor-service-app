import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/report.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/input_dropdown_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/input_text_field_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_view.dart';

import '../bloc/shared_bloc.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController descriptionController = TextEditingController();
  String title = "";
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SharedBloc, SharedState>(
        listener: (context, state) {
          if (state is SuccessAddReportState) {
            customAlert(context, AlertType.success, "Report Sent Successfully");
            Get.back();
          } else if (state is FailureAddReportState) {
            customAlert(context, AlertType.error, "Failed To Send Report");
          }
        },
        builder: (context, state) {
          return LoadingView(
            isLoading: (state is SharedLoadingState),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: key,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomTextWidget(text: "Report An Issue"),
                    SizedBox(height: 20),
                    InputDropdownWidget(
                      items: [
                        DropdownMenuItem(
                          value: "Fraud Issue",
                          child: CustomTextWidget(text: "Fraud Issue"),
                        ),
                        DropdownMenuItem(
                          value: "Scam Issue",
                          child: CustomTextWidget(text: "Scam Issue"),
                        ),
                        DropdownMenuItem(
                          value: "Unsatisfied Work",
                          child: CustomTextWidget(text: "Unsatisfied Work"),
                        ),
                        DropdownMenuItem(
                          value: "In app issues",
                          child: CustomTextWidget(text: "In app issues"),
                        ),
                        DropdownMenuItem(
                          value: "Others",
                          child: CustomTextWidget(text: "Others"),
                        ),
                      ],
                      onChange: (val) {
                        title = val!;
                      },
                      label: "Title",
                    ),
                    SizedBox(height: 20),
                    InputTextFieldWidget(
                      controller: descriptionController,
                      hintText: "Enter your issue",
                      label: "Issue",
                      isMultiLine: true,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please this field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ButtonWithoutIconWidget(
                      onPressed: () {
                        if (key.currentState!.validate()) {
                          if (title != "") {
                            context.read<SharedBloc>().add(
                              AddReportEvent(
                                report: Report(
                                  user: user!.uid,
                                  title: title,
                                  description: descriptionController.text,
                                  date: DateTime.now(),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      label: "REPORT",
                      color: appBlueCardColor,
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
