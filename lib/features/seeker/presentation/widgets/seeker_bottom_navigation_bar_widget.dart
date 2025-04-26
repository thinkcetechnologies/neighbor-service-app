import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/features/messages/presentation/pages/my_messages_page.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_favorite_page.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_home_page.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_new_request_page.dart';
import 'package:nsapp/features/shared/presentation/pages/notifications_page.dart';

class SeekerBottomNavigationBarWidget extends StatelessWidget {
  const SeekerBottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeekerBloc, SeekerState>(
      listener: (context, state) {},
      builder: (context, snapshot) {
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
                      NavigatorSeekerState.page == 1
                          ? appOrangeColor1
                          : Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  context.read<SeekerBloc>().add(
                    NavigateSeekerEvent(
                      page: 1,
                      widget: const SeekerHomePage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.notifications, size: 30,color:
                NavigatorSeekerState.page == 2
                    ? appOrangeColor1
                    : Theme.of(context).iconTheme.color,),
                onPressed: () {
                  context.read<SeekerBloc>().add(
                    NavigateSeekerEvent(
                      page: 2,
                      widget: const NotificationsPage(),
                    ),
                  );
                },
              ),
              GestureDetector(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: appOrangeColor1,
                  ),
                  child: Center(child: Icon(Icons.add, size: 30)),

                ),
                onTap: () {
                  context.read<SeekerBloc>().add(
                    NavigateSeekerEvent(
                      page: 3,
                      widget: const SeekerNewRequestPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.chat,
                  size: 30,
                  color:
                      NavigatorSeekerState.page == 4
                          ? appOrangeColor1
                          : Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  context.read<SeekerBloc>().add(
                    NavigateSeekerEvent(
                      page: 4,
                      widget: const MyMessagesPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite, size: 30, color:  NavigatorSeekerState.page == 5
                    ? appOrangeColor1
                    : Theme.of(context).iconTheme.color,),
                onPressed: () {
                  context.read<SeekerBloc>().add(
                    NavigateSeekerEvent(
                      page: 5,
                      widget: const SeekerFavoritePage(),
                    ),
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
