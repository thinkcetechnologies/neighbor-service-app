import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import '../../../../core/constants/dimension.dart';
import '../../../../core/models/appointment.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';
import '../../../shared/presentation/widget/loading_widget.dart';

class SeekerAppointmentPage extends StatefulWidget {
  const SeekerAppointmentPage({super.key});

  @override
  State<SeekerAppointmentPage> createState() => _SeekerAppointmentPageState();
}

class _SeekerAppointmentPageState extends State<SeekerAppointmentPage> {
  List<CalendarEventData> events = [];
  @override
  void initState() {
    context.read<SeekerBloc>().add(GetAppointmentsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SeekerBloc, SeekerState>(
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
                                            "From ${DateFormat.jms().format(data[0].startTime!)} To ${DateFormat.jms().format(data[0].endDate)}",
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
    );
  }
}
