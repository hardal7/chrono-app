import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/session.dart';
import '../duration.dart';
import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/settings.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
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
                SettingsButton(popup: settingsPopup),
                Padding(
                  padding: EdgeInsets.only(top: height / 24),
                  child: Text(
                    'Physics Students',
                    style: bodyLarge,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                Text('Members: 5/8', style: bodySmallGrey),
                Text(
                  Duration(hours: 45, minutes: 39).toHoursString(),
                  style: bodyMax,
                ),
                Text('Expires in 5 days', style: bodySmallGrey),
                Padding(
                  padding: EdgeInsets.only(top: height / 20),
                  child: UserCard(
                    user: SessionUser(
                      username: 'Guest',
                      totalTime: Duration(minutes: 1),
                      todayTime: Duration(hours: 1),
                      avatarPath: '',
                    ),
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

// TODO: Grey out the user that is you
class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final SessionUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(
                '${dotenv.get('API_URL')}/${user.avatarPath}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                user.username,
                style: bodyMedium,
                // TODO: text overflow
              ),
            ),
            Text(user.totalTime.toHoursString(), style: bodyMedium),
          ],
        ),
        Column(
          children: [
            Row(
              spacing: 5,
              children: [
                Icon(Icons.circle, color: greenColor, size: 10),
                Text('Online', style: bodyMinGreen),
              ],
            ),
            Row(
              children: [
                ImageIcon(
                  AssetImage('assets/icons/triangle.png'),
                  color: greenColor,
                ),
                Text(user.todayTime.toHoursString(), style: bodyMinGreen),
              ],
            ),
          ],
        ),
      ],
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
            Text('Session Settings', style: bodySmallGrey),
          ],
        ),
        content: Row(children: []),
        actions: [],
      );
    },
  );
}
