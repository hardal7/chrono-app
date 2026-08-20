import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/back.dart';
import '../widgets/button.dart';
import '../widgets/settings.dart';
import '../widgets/streak.dart';
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
                    // TODO: Don't show back button if own profile
                    PageBackButton(),
                    SettingsButton(popup: settingsPopup),
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
                          // '${dotenv.get('API_URL')}/${user.avatarPath}',
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
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Text('hardal', style: bodyLarge),
                          Streak(streak: 1),
                        ],
                      ),
                      Text('Best Topic', style: bodyMediumGrey),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: secondaryColor,
                          size: 24,
                        ),
                        Text('Kenya', style: bodyMediumGrey),
                      ],
                    ),
                    Text('biology', style: bodyMedium),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GenericButton(
                        onPressed: () {},
                        text: 'Add Friend',
                        textStyle: bodySmall,
                        size: Size(width / 2.4, 40),
                      ),
                      GenericButton(
                        onPressed: () {},
                        text: 'Invite',
                        textStyle: bodySmall,
                        size: Size(width / 2.4, 40),
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

void settingsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: secondaryColor,
                size: 32,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text('Profile Settings', style: bodySmallGrey),
          ],
        ),
        content: Row(children: []),
        actions: [],
      );
    },
  );
}
