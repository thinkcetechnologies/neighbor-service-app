import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nsapp/features/shared/presentation/bloc/shared_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

class SearchLocationMapWidget extends StatefulWidget {
  const SearchLocationMapWidget({super.key});

  @override
  State<SearchLocationMapWidget> createState() =>
      _SearchLocationMapWidgetState();
}

class _SearchLocationMapWidgetState extends State<SearchLocationMapWidget> {
  TextEditingController locationTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SharedBloc, SharedState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 30),
            SearchBar(
              elevation: WidgetStatePropertyAll(0),
              controller: locationTextController,
              autoFocus: true,
              leading: Icon(Icons.location_on, color: Colors.red),
              hintText: "Search location!",
              onChanged: (val) {
                context.read<SharedBloc>().add(SearchPlacesEvent(input: val));
              },
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: SuccessPlacesState.places.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        context.read<SharedBloc>().add(
                          SearchPlaceEvent(
                            placeId: SuccessPlacesState.places[index].placeId!,
                          ),
                        );
                        Get.back();
                      },
                      leading: Icon(
                        Icons.location_on,
                        size: 35,
                        color: Colors.green,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextWidget(
                            text: SuccessPlacesState.places[index].name,
                          ),
                          CustomTextWidget(
                            text:
                                SuccessPlacesState.places[index].description ??
                                "",
                            color: Theme.of(
                              context,
                            ).iconTheme.color!.withAlpha(140),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
