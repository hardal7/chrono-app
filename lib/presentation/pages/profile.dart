import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../handler/friend.dart';
import '../../handler/user.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../services/imagepicker.dart';
import '../duration.dart';
import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/back.dart';
import '../widgets/button.dart';
import '../widgets/settings.dart';
import '../widgets/streak.dart';
import '../widgets/time.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.username});
  final String username;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProfile profile;
  bool isLoading = true;
  bool isSelf = false;

  Future<void> loadProfile() async {
    final result = await getProfile(widget.username);

    if (!mounted) return;
    setState(() {
      if (result != null) {
        profile = result;
        isLoading = false;
        if (profile.username == username) {
          isSelf = true;
        }
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
    final colors = Theme.of(context).colorScheme;

    return Material(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // TODO: Try
                      GestureDetector(
                        onTap: () async {
                          if (isSelf) {
                            final avatar = await pickImage();
                            if (avatar != null) {
                              await uploadAvatar(avatar);
                            }
                          }
                        },
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(
                            '${dotenv.get('API_URL')}/${profile.avatarPath}',
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total Time',
                            style: bodyMedium.copyWith(color: colors.secondary),
                          ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Text(profile.username, style: bodyLarge),
                          Streak(streak: profile.streak),
                        ],
                      ),
                      Text(
                        'Best Topic',
                        style: bodyMedium.copyWith(color: colors.secondary),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: colors.secondary,
                            size: 24,
                          ),
                          // TODO: Show country flag ??
                          Text(
                            profile.country,
                            style: bodyMedium.copyWith(color: colors.secondary),
                          ),
                        ],
                      ),
                      Text(profile.bestTopic, style: bodyMedium),
                    ],
                  ),
                  if (profile.username != username)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: GenericButton(
                              onPressed: () {
                                if (profile.friendStatus == 'none') {
                                  () async {
                                    await sendFriendRequest(profile.username);
                                    await loadProfile();
                                  }();
                                }
                              },
                              text: switch (profile.friendStatus) {
                                'none' => 'Add Friend',
                                'pending' => 'Sent Request',
                                'accepted' => 'Friends',
                                _ => 'Invite',
                              },
                              textStyle: bodySmall,
                              isPressed: profile.friendStatus == 'none'
                                  ? false
                                  : true,
                            ),
                          ),
                          Spacer(flex: 1),
                          Expanded(
                            flex: 10,
                            child: GenericButton(
                              onPressed: () {
                                // TODO: Make this work
                              },
                              text: 'Invite',
                              textStyle: bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

void settingsPopup(BuildContext context) {
  final colors = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: colors.secondary, size: 32),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Profile Settings',
              style: bodySmall.copyWith(color: colors.secondary),
            ),
          ],
        ),
        content: Row(children: []),
        actions: [],
      );
    },
  );
}
