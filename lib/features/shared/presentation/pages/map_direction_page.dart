import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:nsapp/core/core.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/features/provider/presentation/bloc/provider_bloc.dart';

class MapDirectionPage extends StatefulWidget {
  const MapDirectionPage({super.key});

  @override
  State<MapDirectionPage> createState() => _MapDirectionPageState();
}

class _MapDirectionPageState extends State<MapDirectionPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: size(context).width,
        height: size(context).height,
        child: GoogleMapsWidget(
          defaultCameraZoom: 27.0,
          indoorViewEnabled: true,
          trafficEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          apiKey: mapAPIKey,
          compassEnabled: true,
          // mapType: MapType.hybrid,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          routeWidth: 2,
          sourceLatLng: LatLng(locationData.latitude!, locationData.longitude!),
          destinationLatLng: LatLng(
            RequestDetailState.request.latitude!,
            RequestDetailState.request.longitude!,
          ),
        ),
      ),
    );
  }
}
