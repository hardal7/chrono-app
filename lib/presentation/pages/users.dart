import 'package:flutter/material.dart';

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
                padding: EdgeInsets.only(top: height / 40, left: 20, right: 20),
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
              UserCard(),
            ],
          ),
        );
      },
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: Text('1', style: labelMedium),
                ),
                ImageIcon(
                  AssetImage('assets/icons/triangle.png'),
                  color: greenColor,
                ),
                Text('7', style: labelMediumGreen),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: CircleAvatar(
                radius: 23,
                backgroundImage: AssetImage('avatar'),
              ),
            ),
          ),
          Expanded(flex: 2, child: Text('hardal', style: labelMedium)),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text('1107:32', style: labelMedium),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageIcon(
                      AssetImage('assets/icons/triangle.png'),
                      color: greenColor,
                    ),
                    Text('21:17', style: labelSmallGreen),
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
