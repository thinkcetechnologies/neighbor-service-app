import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/app_colors.dart';

import '../../../../core/constants/dimension.dart';
import '../../../../core/initialize/init.dart';
import '../../../../core/models/appointment.dart';
import '../../../provider/presentation/bloc/provider_bloc.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';

class ReceiverAppointmentChatWidget extends StatelessWidget {
  final DateTime startTime;
  final DateTime appointmentDate;
  final DateTime endTime;
  final String message;
  final String from;

  const ReceiverAppointmentChatWidget({
    super.key,
    required this.startTime,
    required this.appointmentDate,
    required this.endTime,
    required this.message,
    required this.from,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size(context).width,
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size(context).width * 0.70,
            padding: EdgeInsets.only(top: 8, left: 2, bottom: 8, right: 8),
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: appOrangeColor1,
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
                            text: "Scheduled Appointment",
                            color: appWhiteColor,
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
                      iconColor: Theme.of(context).textTheme.bodyLarge!.color!,
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
                SizedBox(height: 20),
                CustomTextWidget(text: message, color: appWhiteColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
