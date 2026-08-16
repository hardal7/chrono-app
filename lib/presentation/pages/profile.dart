import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/back.dart';
import '../widgets/settings.dart';
import '../widgets/time.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        return Material(
          color: backgroundColor,
          child: Padding(
            padding: pageInset,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PageBackButton(),
                    // SettingsButton(popup: ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: height / 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(
                          '',
                          // '${dotenv.get('API_URL')}${user.avatarPath}',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total Time', style: bodyMediumGrey),
                          Text(
                            // '${user.totalTime} h',
                            '1107:32 h',
                            style: bodyMedium,
                          ),
                          TodayTime(todayTime: '37:08'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
