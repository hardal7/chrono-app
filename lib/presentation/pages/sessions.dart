import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../duration.dart';
import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/settings.dart';

class SessionsSettingsPage extends StatelessWidget {
  const SessionsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

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
          child: Column(
            children: [
              SettingsButton(settingsPage: SessionsSettingsPage()),
              Padding(
                padding: EdgeInsets.only(top: height / 16),
                child: Text('Physics Students', style: bodyLarge),
              ),
              Text('Members: 5/8', style: bodyMediumGrey),
              Text('45:39', style: bodyMax),
              Padding(
                padding: EdgeInsets.only(bottom: height / 20),
                child: Text('Expires in 5 days', style: bodyMediumGrey),
              ),
              UserCard(
                user: SessionUser(
                  username: 'Guest',
                  totalTime: Duration(minutes: 1),
                  todayTime: Duration(hours: 1),
                  avatarPath: '',
                ),
              ),
            ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                  '${dotenv.get('API_URL')}${user.avatarPath}',
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
                  Text('Online', style: bodySmallGreen),
                ],
              ),
              Row(
                children: [
                  ImageIcon(
                    AssetImage('assets/icons/triangle.png'),
                    color: greenColor,
                  ),
                  Text(user.todayTime.toHoursString(), style: bodySmallGreen),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SessionUser {
  factory SessionUser.fromJson(Map<String, dynamic> json) {
    return SessionUser(
      username: json['username'] as String,
      totalTime: Duration(seconds: json['total_time'] as int),
      todayTime: Duration(seconds: json['today_time'] as int),
      avatarPath: json['avatar_path'] as String,
    );
  }
  const SessionUser({
    required this.username,
    required this.totalTime,
    required this.todayTime,
    required this.avatarPath,
  });
  final String username;
  final Duration totalTime;
  final Duration todayTime;
  final String avatarPath;
}
