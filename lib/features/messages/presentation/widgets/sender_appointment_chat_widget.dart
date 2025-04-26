import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/appointment.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

import '../../../provider/presentation/bloc/provider_bloc.dart';

class SenderAppointmentChatWidget extends StatelessWidget {
  final DateTime startTime;
  final DateTime appointmentDate;
  final DateTime endTime;
  final String message;
  final String from;
  final VoidCallback onLongPressed;

  const SenderAppointmentChatWidget({
    super.key,
    required this.startTime,
    required this.appointmentDate,
    required this.endTime,
    required this.message,
    required this.from,
    required this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size(context).width,
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onLongPress: onLongPressed,
            child: Container(
              width: size(context).width * 0.70,
              padding: EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 2),
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: appDeepBlueColor1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size(context).width * 0.50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              color: appWhiteColor,
                              text: "Scheduled Appointment",
                            ),
                            Divider(),
                            CustomTextWidget(
                              color: appWhiteColor,
                              text: DateFormat(
                                "EEEE MMMM-dd-yyyy",
                              ).format(appointmentDate),
                            ),
                            Divider(),
                            CustomTextWidget(
                              color: appWhiteColor,
                              text:
                                  "From ${DateFormat.jm().format(startTime)} To ${DateFormat.jm().format(endTime)}",
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        iconColor: appWhiteColor,
                        onSelected: (val) {
                          switch (val) {
                            case 1:
                              context.read<ProviderBloc>().add(
                                AddAppointmentEvent(
                                  appointment: Appointment(
                                    title: "Scheduled Appointment From Chat",
                                    description: message,
                                    startTime: startTime,
                                    endTime: endTime,
                                    appointmentDate: appointmentDate,
                                    from: from,
                                    fromChat: true,
                                    user: user!.uid,
                                  ),
                                ),
                              );
                              break;
                            case 2:
                              break;
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.schedule),
                                  SizedBox(width: 6),
                                  CustomTextWidget(text: "Add To Calender"),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomTextWidget(text: message, color: appWhiteColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
