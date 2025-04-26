import 'package:flutter/material.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/seeker/presentation/pages/seeker_provider_search_page.dart';
import 'package:nsapp/features/seeker/presentation/widgets/popular_provider_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeekerHomePage extends StatefulWidget {
  const SeekerHomePage({super.key});

  @override
  State<SeekerHomePage> createState() => _SeekerHomePageState();
}

class _SeekerHomePageState extends State<SeekerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            CustomTextWidget(
              text: "Hello \n${SuccessGetProfileState.profile.name}",
              fontSize: 20,
            ),
            Container(
              height: 200,
              width: size(context).width,
              decoration: const BoxDecoration(),
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    child: Container(
                      width: size(context).width - 20,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: appDeepBlueColor1,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomTextWidget(
                                text: "Find Professional \nService Providers",
                                color: appWhiteColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 200,
                                height: 45,
                                child: SearchBar(
                                  onTap: () {
                                    context.read<SeekerBloc>().add(
                                      NavigateSeekerEvent(
                                        page: 1,
                                        widget: SeekerProviderSearchPage(),
                                      ),
                                    );
                                  },
                                  leading: const Icon(Icons.search),
                                  hintText: "Search",
                                  backgroundColor: const WidgetStatePropertyAll(
                                    appWhiteColor,
                                  ),
                                  elevation: const WidgetStatePropertyAll(0),
                                  shape: const WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 1,
                    right: 10,
                    child: Image(
                      image: AssetImage(seekerDoctorLogo),
                      height: 230,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomTextWidget(text: "Popular Service Provider", fontSize: 20),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              width: size(context).width,
              child: PopularProviderWidget(),
            ),
            SizedBox(height: 20),
            CustomTextWidget(text: "Available Services", fontSize: 20),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
