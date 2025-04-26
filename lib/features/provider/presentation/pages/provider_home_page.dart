import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/constants/string_constants.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_more_requests_page.dart';
import 'package:nsapp/features/provider/presentation/pages/provider_search_request_page.dart';
import 'package:nsapp/features/provider/presentation/widgets/provider_recent_request_widget.dart';
import 'package:nsapp/features/shared/presentation/bloc/shared_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

import '../../../shared/presentation/widget/subscribe_dialog_widget.dart';
import '../bloc/provider_bloc.dart';

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  State<ProviderHomePage> createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  @override
  void initState() {
    context.read<ProviderBloc>().add(SearchRequestEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProviderBloc, ProviderState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                CustomTextWidget(
                  text: "Hello \n${SuccessGetProfileState.profile.name}",
                  fontSize: 20,
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  width: size(context).width,
                  decoration: const BoxDecoration(),
                  child: Container(
                    width: size(context).width - 20,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(seekerProviderLogo),
                        fit: BoxFit.fill,
                        opacity: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomTextWidget(
                            text: "Search for projects requests",
                            // color: appWhiteColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            width: size(context).width - 20,
                            child: SearchBar(
                              leading: Icon(Icons.search),
                              hintText: "Search",
                              onTap: () {
                                if (ValidUserSubscriptionState.isValid) {
                                  context.read<ProviderBloc>().add(
                                    NavigateProviderEvent(
                                      page: 1,
                                      widget: ProviderSearchRequestPage(),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SubscribeDialogWidget();
                                    },
                                  );
                                }
                              },
                              backgroundColor: WidgetStatePropertyAll(
                                appWhiteColor,
                              ),
                              elevation: WidgetStatePropertyAll(0),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextWidget(text: "Recent Requests", fontSize: 20),
                const SizedBox(height: 20),
                SizedBox(
                  width: size(context).width,
                  height: 200,
                  child: ProviderRecentRequestWidget(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      text: "Requests From Nearby Seekers",
                      fontSize: 20,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (ValidUserSubscriptionState.isValid) {
                      context.read<ProviderBloc>().add(
                        NavigateProviderEvent(
                          page: 1,
                          widget: ProviderMoreRequestsPage(),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SubscribeDialogWidget();
                        },
                      );
                    }
                  },
                  child: Container(
                    width: size(context).width,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).iconTheme.color!,
                      ),
                      color: appBlueCardColor,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomTextWidget(
                            text: "Want to explore more jobs near by?",
                            color: appWhiteColor,
                          ),
                          SizedBox(height: 20),
                          CustomTextWidget(
                            text: "Click here",
                            color: appWhiteColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
