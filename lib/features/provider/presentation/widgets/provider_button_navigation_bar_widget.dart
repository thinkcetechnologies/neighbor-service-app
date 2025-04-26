import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/features/messages/presentation/pages/my_messages_page.dart';
import 'package:nsapp/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_accepted_request_page.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_appointment_calender_pagee.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_home_page.dart';
import 'package:nsapp/features/shared/presentation/pages/notifications_page.dart';

class ProviderButtonNavigationBarWidget extends StatelessWidget {
  const ProviderButtonNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProviderBloc, ProviderState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: appGreyColor,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color:
                      (NavigatorProviderState.page == 1)
                          ? appDeepBlueColor1
                          : Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  context.read<ProviderBloc>().add(
                    NavigateProviderEvent(page: 1, widget: ProviderHomePage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.notifications, size: 30,color:
                (NavigatorProviderState.page == 2)
                    ? appDeepBlueColor1
                    : Theme.of(context).iconTheme.color,),
                onPressed: () {
                  context.read<ProviderBloc>().add(
                    NavigateProviderEvent(page: 2, widget: NotificationsPage()),
                  );
                },
              ),
              IconButton(
                icon: Image.asset(providerJobLogo, width: 60),
                onPressed: () {
                  context.read<ProviderBloc>().add(
                    NavigateProviderEvent(page: 3, widget: ProviderAcceptedRequestPage()),
                  );
                },
              ),
              IconButton(icon: Icon(Icons.chat, size: 30, color: (NavigatorProviderState.page == 4)
                  ? appDeepBlueColor1
                  : Theme.of(context).iconTheme.color,), onPressed: () {
                context.read<ProviderBloc>().add(
                  NavigateProviderEvent(page: 4, widget: MyMessagesPage()),
                );
              }),
              IconButton(
                icon: Icon(Icons.calendar_month, size: 30, color: (NavigatorProviderState.page == 5)
        ? appDeepBlueColor1
            : Theme.of(context).iconTheme.color,),
                onPressed: () {
                  context.read<ProviderBloc>().add(
                    NavigateProviderEvent(page: 5, widget: ProviderAppointmentCalenderPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
