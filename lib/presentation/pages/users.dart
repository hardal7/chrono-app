import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../handler/user.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user.dart';
import '../duration.dart';
import '../style.dart';
import '../widgets/button.dart';
import '../widgets/settings.dart';
import 'profile.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

late String username;

class _UsersPageState extends State<UsersPage> {
  final searchController = TextEditingController();
  List<LeaderboardUser> users = [];
  bool isLoading = true;
  String searchScope = 'global';
  String? searchQuery;
  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final result = await getTopUsers(searchScope, matchName: searchQuery);

    await loadUsername();

    if (!mounted) return;
    setState(() {
      users = result;
      isLoading = false;
    });
  }

  Timer? searchDebounce;
  void onSearchChanged(String query) {
    searchDebounce?.cancel();

    if (query.length <= 3) {
      searchQuery = null;
    } else {
      searchQuery = query;
    }

    searchDebounce = Timer(const Duration(milliseconds: 200), () {
      loadUsers();
    });
  }

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  @override
  void dispose() {
    searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      child: Padding(
        padding: pageInset,
        child: Column(
          spacing: 10,
          children: [
            SettingsButton(popup: settingsPopup),
            Container(
              decoration: BoxDecoration(
                border: BoxBorder.all(color: colors.secondary),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: TextFormField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: bodySmall.copyWith(color: colors.secondary),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: colors.secondary),
                  hintText: l10n.searchUsername,
                  hintStyle: bodySmall.copyWith(color: colors.secondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.secondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.secondary),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GenericButton(
                  text: l10n.friend,
                  textStyle: bodySmall,
                  isPressed: searchScope == 'friends',
                  onPressed: () {
                    setState(() {
                      searchScope = 'friends';
                      loadUsers();
                    });
                  },
                ),
                GenericButton(
                  text: l10n.local,
                  textStyle: bodySmall,
                  isPressed: searchScope == 'local',
                  onPressed: () {
                    setState(() {
                      searchScope = 'local';
                      loadUsers();
                    });
                  },
                ),
                GenericButton(
                  text: l10n.global,
                  textStyle: bodySmall,
                  isPressed: searchScope == 'global',
                  onPressed: () {
                    setState(() {
                      searchScope = 'global';
                      loadUsers();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  l10n.rank,
                  style: bodySmall.copyWith(color: colors.secondary),
                ),
                Text(
                  l10n.user,
                  style: bodySmall.copyWith(color: colors.secondary),
                ),
                Text(
                  l10n.time,
                  style: bodySmall.copyWith(color: colors.secondary),
                ),
              ],
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return UserCard(user: users[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final LeaderboardUser user;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: username == user.username
            ? colors.secondary.withAlpha(25)
            : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text('${user.rank}', style: bodyMedium),
                ),
                Transform.rotate(
                  angle: user.rankChange > 0 ? 0 : math.pi,
                  child: ImageIcon(
                    AssetImage('assets/icons/triangle.png'),
                    color: user.rankChange > 0 ? greenColor : colors.error,
                  ),
                ),
                Text(
                  '${user.rankChange}',
                  style: bodyMedium.copyWith(
                    color: user.rankChange > 0 ? greenColor : colors.error,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(username: user.username),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      '${dotenv.get('API_URL')}/${user.avatarPath}',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    maxLines: 1,
                    user.username.length < 10
                        ? user.username
                        : '${user.username.substring(0, 8)}...',
                    style: user.username.length < 10 ? bodySmall : bodyMin,
                    // TODO: text overflow
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(user.totalTime.toHoursString(), style: bodySmall),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageIcon(
                      AssetImage('assets/icons/triangle.png'),
                      color: greenColor,
                    ),
                    Text(
                      user.todayTime.toStopwatchString(),
                      style: bodyMin.copyWith(color: greenColor),
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
  final colors = Theme.of(context).colorScheme;
  final l10n = AppLocalizations.of(context)!;

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
              l10n.leaderboardSettings,
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
