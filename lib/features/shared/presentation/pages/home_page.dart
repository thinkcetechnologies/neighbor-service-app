import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_dashboard_page.dart';
import 'package:nsapp/features/provider/presentation/widgets/provider_drawer_widget.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_dashboard_page.dart';
import 'package:nsapp/features/seeker/presentation/widgets/seeker_drawer_widget.dart';
import 'package:nsapp/features/shared/presentation/bloc/shared_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/home_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Helpers.createStripeCustomer();
    context.read<SharedBloc>().add(CheckUserSubscriptionEvent());
    super.initState();
    InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          Helpers.getLocation();

          break;
        case InternetStatus.disconnected:
          Future.delayed(Duration(seconds: 3), () {
            Get.snackbar("Warning", "Please check your internet connection");
          });

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SharedBloc, SharedState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          key: scaffold,
          appBar: homeAppBar(
            context: context,
            color:
                DashboardState.isProvider ? appBlueCardColor : appOrangeColor1,
            title:
                DashboardState.isProvider
                    ? 'PROVIDER DASHBOARD'
                    : 'SEEKER DASHBOARD',
            actions: [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(
                        SuccessGetProfileState.profile.profilePictureUrl ?? "",
                      ),
                    ),
                    const SizedBox(width: 10),
                    CustomTextWidget(
                      text: SuccessGetProfileState.profile.name ?? "",
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.dark_mode, size: 30),
                    const SizedBox(width: 10),
                    CustomTextWidget(text: "Dark Mode"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.light_mode, size: 30),
                    const SizedBox(width: 10),
                    CustomTextWidget(text: "Light Mode"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 30),
                    const SizedBox(width: 10),
                    CustomTextWidget(text: "Logout"),
                  ],
                ),
              ),
            ],
            value: DashboardState.isProvider,
            onToggle: (val) {
              context.read<SharedBloc>().add(
                ToggleDashboardEvent(isProvider: val),
              );
            },
          ),
          drawer:
              (DashboardState.isProvider)
                  ? ProviderDrawerWidget()
                  : SeekerDrawerWidget(),
          body: Center(
            child:
                (DashboardState.isProvider)
                    ? ProviderDashboardPage()
                    : SeekerDashboardPage(),
          ),
        );
      },
    );
  }
}
