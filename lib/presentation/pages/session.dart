import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../handler/session.dart';
import '../../l10n/app_localizations.dart';
import '../../models/session.dart';
import '../../services/app.dart';
import '../duration.dart';
import '../style.dart';
import '../widgets/back.dart';
import '../widgets/button.dart';
import '../widgets/settings.dart';
import 'home.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
                SettingsButton(
                  popup: (context) =>
                      settingsPopup(context, widget.name, widget.ownerUsername),
                ),
              ],
            ),
            Text(
              session.name,
              style: bodyLarge,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Text(
                  session.maxParticipants == 0
                      ? '${l10n.members}: ${session.totalParticipants}'
                      : '${l10n.members}: ${session.totalParticipants}/${session.maxParticipants}',
                  style: bodySmall.copyWith(color: colors.secondary),
                ),
                Icon(Icons.group, color: colors.secondary, size: 24),
              ],
            ),
            Text(
              Duration(seconds: (session.totalTime)).toHoursString(),
              style: bodyLarge,
            ),
            if (session.expiresAt != null)
              Text(
                '${l10n.expiresIn} ${session.expiresAt!.day} ${l10n.days}',
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
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: appNotifier.value.username == participant.name
            ? colors.secondary.withAlpha(25)
            : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                    '${dotenv.get('API_URL')}/${participant.avatarPath}',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  participant.name.length < 8
                      ? participant.name
                      : '${participant.name.substring(0, 8)}...',
                  style: participant.name.length < 8 ? bodyMedium : bodySmall,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                Duration(seconds: participant.sessionTime).toHoursString(),
                style: bodyMedium,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.circle,
                          color: participant.lastOnline == 0
                              ? greenColor
                              : colors.secondary,
                          size: 10,
                        ),
                        Text(
                          participant.lastOnline == 0
                              ? l10n.online
                              : l10n.offline,
                          style: participant.lastOnline == 0
                              ? bodySmall.copyWith(color: greenColor)
                              : bodySmall.copyWith(color: colors.secondary),
                        ),
                      ],
                    ),
                    if (participant.lastOnline == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 2,
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/triangle.png'),
                            size: 12,
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
            ),
          ],
        ),
      ),
    );
  }
}

void settingsPopup(BuildContext context, String name, String ownerUsername) {
  final l10n = AppLocalizations.of(context)!;
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
              l10n.sessionSettings,
              style: bodySmall.copyWith(color: colors.secondary),
            ),
          ],
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GenericButton(
              onPressed: () async {
                await leaveSession(name, ownerUsername);
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                }
              },
              text: l10n.leave,
              color: colors.error,
            ),
          ],
        ),
        actions: [],
      );
    },
  );
}
