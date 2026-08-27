import 'package:flutter/material.dart';

import '../style.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.popup});
  final void Function(BuildContext context) popup;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: colors.onSurface,
              size: 36,
            ),
            onPressed: () {
              popup(context);
            },
          ),
        ),
      ],
    );
  }
}

class SettingsForm extends StatelessWidget {
  const SettingsForm({
    super.key,
    required this.label,
    required this.controller,
    this.isDate = false,
    this.isNumber = false,
  });

  final String label;
  final TextEditingController controller;
  final bool isDate;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return isDate
        ? InputDatePickerFormField(
            firstDate: DateTime.now(),
            lastDate: DateTime.now().copyWith(year: DateTime.now().year + 1),
            acceptEmptyDate: true,
            onDateSubmitted: (DateTime date) {
              controller.text = date.toIso8601String();
            },
            fieldLabelText: label,
          )
        : TextFormField(
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.secondary),
              ),
              border: OutlineInputBorder(),
            ),
            style: bodyMedium.copyWith(color: colors.secondary),
          );
  }
}
