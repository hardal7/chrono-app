import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../handler/user.dart';
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
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    height: height / 15,
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: secondaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: TextFormField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      style: bodySmallGrey,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: secondaryColor),
                        hintText: 'Search username',
                        hintStyle: bodySmallGrey,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: secondaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: secondaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height / 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GenericButton(
                        text: 'Friend',
                        size: Size(width / 3.7, 45),
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
                        text: 'Local',
                        textStyle: bodySmall,
                        size: Size(width / 3.7, 45),
                        isPressed: searchScope == 'local',
                        onPressed: () {
                          setState(() {
                            searchScope = 'local';
                            loadUsers();
                          });
                        },
                      ),
                      GenericButton(
                        text: 'Global',
                        textStyle: bodySmall,
                        size: Size(width / 3.7, 45),
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Rank', style: bodySmallGrey),
                    Text('User', style: bodySmallGrey),
                    Text('Time', style: bodySmallGrey),
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
      },
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final LeaderboardUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: username == user.username ? secondaryColor : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text('${user.rank}', style: bodyMedium),
                ),
                // TODO: rank changes
                ImageIcon(
                  AssetImage('assets/icons/triangle.png'),
                  color: greenColor,
                ),
                Text('7', style: bodyMediumGreen),
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
                    user.username,
                    style: bodyMedium,
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
                Text(user.totalTime.toHoursString(), style: bodyMedium),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageIcon(
                      AssetImage('assets/icons/triangle.png'),
                      color: greenColor,
                    ),
                    Text(
                      user.todayTime.toStopwatchString(),
                      style: bodyMinGreen,
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
            Text('Leaderboard Settings', style: bodySmallGrey),
          ],
        ),
        content: Row(children: []),
        actions: [],
      );
    },
  );
}
