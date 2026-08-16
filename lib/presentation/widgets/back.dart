import 'package:flutter/material.dart';

import '../style.dart';

class PageBackButton extends StatelessWidget {
  const PageBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Icon(Icons.chevron_left, color: foregroundColor, size: 48),
    );
  }
}
