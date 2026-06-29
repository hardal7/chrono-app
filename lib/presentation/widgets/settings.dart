import 'package:flutter/material.dart';

import '../style.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.settingsPage});
  final Widget settingsPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: screenHeight / 50,
            right: screenWidth / 25,
          ),
          child: IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: foregroundColor,
              size: 36,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => settingsPage,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
