import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../handler/session.dart';
import '../../models/session.dart';
import '../duration.dart';
import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/back.dart';
import '../widgets/settings.dart';
import 'users.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({
    super.key,
    required this.name,
    required this.ownerUsername,
  });
  final String name, ownerUsername;

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  bool isLoading = true;
  late SessionData session;

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    final result = await getSession(widget.name, widget.ownerUsername);

    if (!mounted) return;
    setState(() {
      if (result != null) {
        session = result;
        isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Material(
      child: Padding(
        padding: pageInset,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PageBackButton(),
                SettingsButton(popup: settingsPopup),
              ],
            ),
            Text(
              session.name,
              style: bodyLarge,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            Text(
              'Members: ${session.totalParticipants}/${session.maxParticipants}',
              style: bodySmall.copyWith(color: colors.secondary),
            ),
            Text(
              Duration(seconds: (session.totalTime)).toHoursString(),
              style: bodyLarge,
            ),
            if (session.expiresAt != null)
              Text(
                'Expires in ${session.expiresAt} days',
                style: bodySmall.copyWith(color: colors.secondary),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: session.participants.length,
                itemBuilder: (context, index) {
                  return ParticipantCard(
                    participant: session.participants[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticipantCard extends StatelessWidget {
  const ParticipantCard({super.key, required this.participant});
  final Participant participant;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: username == participant.name
            ? colors.secondary.withAlpha(25)
            : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                      '${dotenv.get('API_URL')}/${participant.avatarPath}',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    participant.name.length < 8
                        ? participant.name
                        : '${participant.name.substring(0, 8)}...',
                    style: participant.name.length < 8 ? bodyMedium : bodySmall,
                  ),
                ),
                Text(
                  Duration(seconds: participant.sessionTime).toHoursString(),
                  style: bodyMedium,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Column(
                children: [
                  Row(
                    spacing: 5,
                    children: [
                      Icon(Icons.circle, color: greenColor, size: 10),
                      Text(
                        participant.lastOnline.toString(),
                        // 'Online',
                        style: bodySmall.copyWith(color: greenColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage('assets/icons/triangle.png'),
                        color: greenColor,
                      ),
                      Text(
                        Duration(
                          seconds: participant.sessionTimeToday,
                        ).toHoursString(),
                        style: bodyMin.copyWith(color: greenColor),
                      ),
                    ],
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
              'Session Settings',
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
