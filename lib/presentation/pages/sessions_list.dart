import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../handler/session.dart';
import '../../l10n/app_localizations.dart';
import '../../models/session.dart';
import '../duration.dart';
import '../style.dart';
import '../widgets/button.dart';
import '../widgets/settings.dart';
import 'profile.dart';
import 'session.dart';

class SessionsListPage extends StatefulWidget {
  const SessionsListPage({super.key});

  @override
  State<SessionsListPage> createState() => _SessionsListPageState();
}

class _SessionsListPageState extends State<SessionsListPage> {
  List<SessionSelection> sessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    final result = await getSessions();

    if (!mounted) return;
    setState(() {
      sessions = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      child: Padding(
        padding: pageInset,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Icon(Icons.add, color: colors.onSurface, size: 48),
                    onTap: () {
                      settingsPopup(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : sessions.isEmpty
                  ? Center(
                      child: Text(
                        'No session found',
                        style: bodySmall.copyWith(color: colors.secondary),
                      ),
                    )
                  : ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        return SessionCard(session: sessions[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session});
  final SessionSelection session;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.secondary.withAlpha(25),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(session.name, style: bodySmall),
                if (session.expiresAt != null)
                  Text(
                    'Expires in ${session.expiresAt} days',
                    style: bodySmall.copyWith(color: colors.secondary),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(username: session.ownerUsername),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          '${dotenv.get('API_URL')}/${session.ownerAvatarPath}',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: List.generate(session.totalParticipants, (index) {
                    final participant = session.participants[index];
                    return CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        '${dotenv.get('API_URL')}/${participant.avatarPath}',
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 7.5,
                  children: [
                    Text(
                      'Total Time:',
                      style: bodySmall.copyWith(color: colors.secondary),
                    ),
                    Text(
                      Duration(seconds: session.totalTime).toHoursString(),
                      style: bodySmall.copyWith(color: greenColor),
                    ),
                  ],
                ),
                Row(
                  spacing: 7.5,
                  children: [
                    if (session.maxParticipants == 0)
                      Text('${session.totalParticipants}', style: bodySmall),
                    if (session.maxParticipants != 0)
                      Text(
                        '${session.totalParticipants}/${session.maxParticipants}',
                        style: bodySmall,
                      ),
                    Icon(Icons.group, color: colors.secondary, size: 24),
                    GenericButton(
                      text: 'Join',
                      textStyle: bodySmall,
                      onPressed: () async {
                        await joinSession(session.name, session.ownerUsername);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SessionPage(
                              name: session.name,
                              ownerUsername: session.ownerUsername,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void settingsPopup(BuildContext context) {
  final nameController = TextEditingController();
  final maxParticipantsController = TextEditingController();
  final expiresAtController = TextEditingController();
  final topicController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      final colors = Theme.of(context).colorScheme;
      final l10n = AppLocalizations.of(context)!;

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
              'Create Session',
              style: bodySmall.copyWith(color: colors.secondary),
            ),
          ],
        ),
        content: Column(
          children: [
            Expanded(
              child: SettingsForm(
                label: 'Session Name',
                controller: nameController,
              ),
            ),
            Text(
              'Optional Settings',
              style: bodySmall.copyWith(color: colors.secondary),
            ),
            Row(
              children: [
                Expanded(
                  child: SettingsForm(
                    label: 'Topic',
                    controller: topicController,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: SettingsForm(
                    label: 'Max Participants',
                    controller: maxParticipantsController,
                    isNumber: true,
                  ),
                ),
                Expanded(
                  child: SettingsForm(
                    label: 'Expires At',
                    controller: expiresAtController,
                    isDate: true,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          GenericButton(
            text: l10n.create,
            textStyle: bodySmall,
            onPressed: () {
              createSession(
                CreateSessionRequest(
                  name: nameController.text,
                  topic: topicController.text,
                  expiresAt: DateTime.tryParse(expiresAtController.text),
                  maxParticipants: int.tryParse(maxParticipantsController.text),
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
