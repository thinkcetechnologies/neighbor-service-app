import 'package:flutter/material.dart';

class AppointmentInputFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final VoidCallback? onPressed;
  const AppointmentInputFieldWidget({super.key, required this.label, this.controller, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: TextFormField(
        controller: controller,
        onTap: onPressed,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          labelText: label,
        ),
      ),
    );
  }
}
