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
                    style: bodyMedium,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: secondaryColor),
                      hintText: 'Search username',
                      hintStyle: bodyMedium,
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
                padding: EdgeInsets.only(
                  top: height / 40,
                  bottom: height / 40,
                  left: 20,
                  right: 20,
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
                  Text('Rank', style: bodyMedium),
                  Text('User', style: bodyMedium),
                  Text('Hours', style: bodyMedium),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
