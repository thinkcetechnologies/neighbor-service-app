import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/features/shared/presentation/widget/button_without_icon_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';

import '../../../../core/initialize/init.dart';
import '../../../../core/models/appointment.dart';
import '../../../shared/presentation/widget/appointment_input_field_widget.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';
import '../bloc/provider_bloc.dart';

class ProviderAppointmentCalenderPage extends StatefulWidget {
  const ProviderAppointmentCalenderPage({super.key});

  @override
  State<ProviderAppointmentCalenderPage> createState() =>
      _ProviderAppointmentCalenderPageState();
}

class _ProviderAppointmentCalenderPageState
    extends State<ProviderAppointmentCalenderPage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime today = DateTime.now();
  DateTime? appointmentDate;
  DateTime? appointmentStartTime;
  DateTime? appointmentEndTime;
  List<CalendarEventData> events = [];

  @override
  void initState() {
    context.read<ProviderBloc>().add(GetAppointmentsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProviderBloc, ProviderState>(
        listener: (context, state) {},
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: SuccessGetAppointmentsState.appointments,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for (var data in snapshot.data!.docs) {
                  Appointment appointment = Appointment.fromJSON(data);
                  events.add(
                    CalendarEventData(
                      title: appointment.title!,
                      date: appointment.appointmentDate!,
                      description: appointment.description!,
                      startTime: appointment.startTime!,
                      endTime: appointment.endTime,
                    ),
                  );
                }
                return CalendarControllerProvider(
                  controller: EventController()..addAll(events),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size(context).height - 190,
                          child: DayView(
                            onEventTap: (data, dateTime) {
                              Get.bottomSheet(
                                Container(
                                  height: 250,
                                  padding: EdgeInsets.all(20),
                                  width: size(context).width,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextWidget(
                                        text: "Scheduled Appointment",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      Divider(),
                                      CustomTextWidget(text: data[0].title),
                                      Divider(),
                                      CustomTextWidget(
                                        text: DateFormat(
                                          "EEEE MMMM-dd-yyyy",
                                        ).format(data[0].date),
                                      ),
                                      Divider(),
                                      CustomTextWidget(
                                        text: data[0].description ?? "",
                                      ),
                                      Divider(),
                                      CustomTextWidget(
                                        text:
                                            "From ${DateFormat.jm().format(data[0].startTime!)} To ${DateFormat.jm().format(data[0].endDate)}",
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            headerStyle: HeaderStyle(
                              leftIconConfig: IconDataConfig(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.color!,
                              ),

                              rightIconConfig: IconDataConfig(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.color!,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return LoadingWidget();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            Container(
              width: size(context).width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    CustomTextWidget(text: "Send Appointment"),
                    SizedBox(height: 20),
                    AppointmentInputFieldWidget(
                      controller: titleController,
                      label: "Title",
                    ),
                    SizedBox(height: 20),
                    AppointmentInputFieldWidget(
                      controller: dateController,
                      label: "Appointment Date",
                      onPressed: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          appointmentDate = date;
                          dateController.text = DateFormat(
                            "EEEE yyyy-MMMM-dd",
                          ).format(date);
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size(context).width * 0.45,
                          child: AppointmentInputFieldWidget(
                            controller: startTimeController,
                            onPressed: () async {
                              DateTime today = DateTime.now();
                              TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                DateTime date = DateTime(
                                  today.year,
                                  today.month,
                                  today.day,
                                  time.hour,
                                  time.minute,
                                );
                                appointmentStartTime = date;
                                startTimeController.text = DateFormat.jm()
                                    .format(date);
                              }
                            },
                            label: "Start At",
                          ),
                        ),
                        SizedBox(
                          width: size(context).width * 0.45,
                          child: AppointmentInputFieldWidget(
                            controller: endTimeController,
                            onPressed: () async {
                              DateTime today = DateTime.now();
                              TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                DateTime date = DateTime(
                                  today.year,
                                  today.month,
                                  today.day,
                                  time.hour,
                                  time.minute,
                                );
                                appointmentEndTime = date;
                                endTimeController.text = DateFormat.jm().format(
                                  date,
                                );
                              }
                            },
                            label: "End At",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    AppointmentInputFieldWidget(
                      controller: descriptionController,
                      label: "Description",
                    ),
                    SizedBox(height: 20),
                    ButtonWithoutIconWidget(
                      label: "SAVE",
                      onPressed: () {
                        if (titleController.text.trim() == "" ||
                            descriptionController.text.trim() == "" ||
                            appointmentEndTime == null ||
                            appointmentStartTime == null ||
                            appointmentDate == null) {
                          return;
                        }
                        context.read<ProviderBloc>().add(
                          AddAppointmentEvent(
                            appointment: Appointment(
                              title: titleController.text,
                              description: descriptionController.text,
                              startTime: appointmentStartTime,
                              endTime: appointmentEndTime,
                              appointmentDate: appointmentDate,
                              from: null,
                              fromChat: true,
                              user: user!.uid,
                            ),
                          ),
                        );
                        Get.back();
                      },
                      color: appBlueCardColor,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
