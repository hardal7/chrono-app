import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../style.dart';
import '../widgets/button.dart';

class SessionsListPage extends StatefulWidget {
  const SessionsListPage({super.key});

  @override
  State<SessionsListPage> createState() => _SessionsListPageState();
}

class _SessionsListPageState extends State<SessionsListPage> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
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
                      Icon(Icons.add, color: colors.onSurface, size: 48),
                    ],
                  ),
                ),
                SessionCard(height: height, width: width),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: height / 5,
      width: width,
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
                Text('Biology', style: bodySmall),
                Text(
                  'Expires in 5 days',
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
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        '${dotenv.get('API_URL')}/avatarPath',
                      ),
                    ),
                    Text('username', style: bodySmall),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: [
                    ...avatars.map(
                      (path) => CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          '${dotenv.get('API_URL')}$path',
                        ),
                      ),
                    ),
                  ],
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
                      '307:32 h',
                      style: bodySmall.copyWith(color: greenColor),
                    ),
                  ],
                ),
                Row(
                  spacing: 7.5,
                  children: [
                    Text('3/8', style: bodySmall),
                    GenericButton(
                      text: 'Join',
                      size: Size(100, 30),
                      textStyle: bodySmall,
                      onPressed: () {},
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

final avatars = ['/avatarPath1', '/avatarPath2', '/avatarPath3'];
