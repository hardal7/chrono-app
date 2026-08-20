import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../handler/profile.dart';
import '../../models/profile.dart';
import '../duration.dart';
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
  late UserProfile profile;
  bool isLoading = true;

  Future<void> loadProfile() async {
    // TODO: Use username
    final result = await getProfile('flutter');

    if (!mounted) return;

    setState(() {
      if (result != null) {
        profile = result;
        isLoading = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
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
                                '${dotenv.get('API_URL')}/${profile.avatarPath}',
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Total Time', style: bodyMediumGrey),
                                Text(
                                  Duration(
                                    seconds: profile.totalTime,
                                  ).toStopwatchString(),
                                  style: bodyMedium,
                                ),
                                TodayTime(todayTime: profile.todayTime),
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
                                Text(profile.username, style: bodyLarge),
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
                              Text(profile.country, style: bodyMediumGrey),
                            ],
                          ),
                          Text(profile.bestTopic, style: bodyMedium),
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
                              text: switch (profile.friendStatus) {
                                'none' => 'Invite',
                                'pending' => 'Sent',
                                'accepted' => 'Friends',
                                _ => 'Invite',
                              },
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
