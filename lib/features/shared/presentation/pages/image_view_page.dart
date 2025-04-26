import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/features/shared/presentation/bloc/shared_bloc.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({super.key});

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SharedBloc, SharedState>(
        listener: (context, state) {},
        builder: (context, state) {
          return InteractiveViewer(
            panEnabled: false, // Set it to false
            boundaryMargin: EdgeInsets.all(100),
            minScale: 1,
            maxScale: 10,
            child: Image.network(
              ViewImageState.url,
              height: size(context).height,
              width: size(context).width,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
