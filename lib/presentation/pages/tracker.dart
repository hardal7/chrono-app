import '../../handler/track.dart';
import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/settings.dart';

TextStyle greyMedium = const TextStyle(
  color: secondaryColor,
  fontSize: 24,
  fontWeight: FontWeight.w500,
);

class TrackerSettingsPage extends StatelessWidget {
  const TrackerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TrackerPage extends StatelessWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Column(
        children: [
          SettingsButton(settingsPage: TrackerSettingsPage()),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5.0,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ImageIcon(
                      AssetImage('assets/icons/fire.png'),
                      size: 32,
                      color: Colors.red,
                    ),
                    Positioned(
                      top: 8.0,
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: foregroundColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Topic',
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.chevron_right, color: foregroundColor, size: 36),
              ],
            ),
          ),
          Text('307:52 overall', style: greyMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage('assets/icons/triangle.png'),
                color: greenColor,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '37:08',
                      style: TextStyle(
                        color: greenColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: ' today',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 75.0),
            child: Text(
              '45:00',
              style: TextStyle(
                color: foregroundColor,
                fontSize: 84,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text('Count 1', style: greyMedium),
          Padding(
            padding: const EdgeInsets.only(top: 125.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5.0,
              children: [
                Icon(Icons.circle, color: foregroundColor, size: 16.0),
                Icon(Icons.circle, color: secondaryColor, size: 16.0),
                Icon(Icons.circle, color: secondaryColor, size: 16.0),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: accentShadowColor,
                    blurRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: startTracker,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: foregroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fixedSize: Size(175.0, 45.0),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
