import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../handler/top_users.dart';
import '../duration.dart';
import '../style.dart';
import '../widgets/button.dart';
import '../widgets/settings.dart';

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final searchController = TextEditingController();
  List<LeaderboardUser> users = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final result = await getTopUsers();

    if (!mounted) return;

    setState(() {
      users = result;
      isLoading = false;
    });
  }

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
              SettingsButton(settingsPage: UserSettingsPage()),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  height: height / 15,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(color: secondaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: TextFormField(
                    controller: searchController,
                    style: labelMediumGrey,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: secondaryColor),
                      hintText: 'Search username',
                      hintStyle: labelMediumGrey,
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
                padding: EdgeInsets.symmetric(
                  vertical: height / 40,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GenericButton(
                      text: 'Friends',
                      size: Size(width / 3.5, 45),
                      onPressed: () {},
                    ),
                    GenericButton(
                      text: 'Local',
                      size: Size(width / 3.5, 45),
                      onPressed: () {},
                    ),
                    GenericButton(
                      text: 'Global',
                      size: Size(width / 3.5, 45),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Rank', style: labelMediumGrey),
                  Text('User', style: labelMediumGrey),
                  Text('Hours', style: labelMediumGrey),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 10),
                  child: Text('${user.rank}', style: labelMedium),
                ),
                GestureDetector(
                  onTap: () {},
                  child: ImageIcon(
                    AssetImage('assets/icons/triangle.png'),
                    color: greenColor,
                  ),
                ),
                // TODO: Later implementation??
                Text('7', style: labelMediumGreen),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(
                    'http://${dotenv.get('API_URL')}${user.avatarPath}',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    user.username,
                    style: labelMedium,
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
                Text(user.totalTime.toStopwatchString(), style: labelMedium),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageIcon(
                      AssetImage('assets/icons/triangle.png'),
                      color: greenColor,
                    ),
                    Text(
                      user.todayTime.toStopwatchString(),
                      style: labelSmallGreen,
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
