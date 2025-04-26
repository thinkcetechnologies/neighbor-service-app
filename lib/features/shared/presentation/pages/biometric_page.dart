import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';

class BiometricPage extends StatefulWidget {
  const BiometricPage({super.key});

  @override
  State<BiometricPage> createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  final LocalAuthentication localAuthentication = LocalAuthentication();

  auth() async {
    final bool hasBiometric = await localAuthentication.canCheckBiometrics;
    if (hasBiometric) {
      final isAuthenticated = await localAuthentication.authenticate(
        localizedReason: "Unlock Neighbor Service",
        options: AuthenticationOptions(biometricOnly: true),
      );
      if (isAuthenticated) {
        Get.offAllNamed("/home");
      }
    } else {
      final isAuthenticated = await localAuthentication.authenticate(
        localizedReason: "Unlock Neighbor Service",
        options: AuthenticationOptions(biometricOnly: false),
      );
      if (isAuthenticated) {
        Get.offAllNamed("/home");
      }
    }
  }

  @override
  void initState() {
    auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: size(context).width,
        height: size(context).height,
        child: Column(
          children: [
            SizedBox(height: 70),
            CustomTextWidget(text: "Unlock Neighbor Service"),
            SizedBox(height: 30),
            Icon(Icons.lock, color: Colors.red, size: 80),
          ],
        ),
      ),
    );
  }
}
