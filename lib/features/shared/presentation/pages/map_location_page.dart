import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/initialize/init.dart';

import '../bloc/shared_bloc.dart';
import '../widget/search_location_map_widget.dart';

class MapLocationPage extends StatefulWidget {
  const MapLocationPage({super.key});

  @override
  State<MapLocationPage> createState() => _MapLocationPageState();
}

class _MapLocationPageState extends State<MapLocationPage> {
  TextEditingController locationTextController = TextEditingController();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(locationData.latitude!, locationData.longitude!),
    zoom: 15,
  );
  LatLng? pos;

  CameraPosition initialCameraPosition2 = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(locationData.latitude!, locationData.longitude!),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  void initState() {
    super.initState();
  }

  // Future<void> moveCamera() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //     target: LatLng(..., ...),
  //     zoom: 18,
  //   )));
  // }

  @override
  Widget build(BuildContext context) {
    pos = initialCameraPosition.target;
    return Scaffold(
      body: BlocConsumer<SharedBloc, SharedState>(
        listener: (context, state) async {
          if (state is SuccessPlaceState) {
            context.read<SharedBloc>().add(
              MapLocationEvent(
                location: LatLng(
                  SuccessPlaceState.places.lat!,
                  SuccessPlaceState.places.lng!,
                ),
              ),
            );
            pos = LatLng(
              SuccessPlaceState.places.lat!,
              SuccessPlaceState.places.lng!,
            );
            GoogleMapController con = await _controller.future;
            con.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(
                    SuccessPlaceState.places.lat!,
                    SuccessPlaceState.places.lng!,
                  ),
                  zoom: 15,
                ),
              ),
            );
            setState(() {});
          }
        },
        builder: (context, state) {
          return Container(
            width: size(context).width,
            height: size(context).height,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(),
                  child: GoogleMap(
                    myLocationEnabled: true,
                    mapType: MapType.hybrid,
                    initialCameraPosition: initialCameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraMove: (position) async {
                      context.read<SharedBloc>().add(
                        MapLocationEvent(location: position.target),
                      );
                      pos = position.target;
                      locationTextController.text =
                          await Helpers.getAddressFromMap(position.target);
                      locController.text = locationTextController.text;
                      setState(() {});
                    },
                    onTap: (position) {
                      context.read<SharedBloc>().add(
                        MapLocationEvent(location: position),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: (size(context).width / 2) - 75,
                  top: (size(context).height / 2) - 75,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: appBlueCardColor.withAlpha(50),
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: Icon(Icons.location_on, size: 50, color: Colors.red),
                  ),
                ),
                Positioned(
                  left: size(context).width * 0.05,
                  top: 50,
                  child: Container(
                    width: size(context).width * 0.90,
                    decoration: BoxDecoration(),
                    child: SearchBar(
                      controller: locationTextController,
                      leading: Icon(Icons.location_on),
                      hintText: "Search location!",
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            padding: EdgeInsets.all(20),
                            width: size(context).width,
                            height: size(context).height - 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: SearchLocationMapWidget(),
                          ),
                          isScrollControlled: true,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          locController.text = locationTextController.text;
          await Helpers.getAddressFromMap(pos!);
          Get.back();
        },
        child: Icon(Icons.arrow_forward_ios),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
