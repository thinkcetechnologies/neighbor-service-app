import 'package:flutter/material.dart';
import 'custom_text_widget.dart';

class InputDropdownWidget extends StatelessWidget {
  final List<DropdownMenuItem<String>> items;
  final Function(String?)? onChange;
  final String label;
  final String? value;
  const InputDropdownWidget({
    super.key,
    required this.items,
    required this.onChange,
    required this.label,
    this.value ,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(text: label),
          SizedBox(height: 10),
          DropdownButtonFormField(
            items: items,
            onChanged: onChange,
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
