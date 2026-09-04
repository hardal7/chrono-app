import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

Future<void> initLinkHandler(BuildContext context) async {
  final AppLinks appLinks = AppLinks();

  // Handle the link that opened the app
  final initialLink = await appLinks.getInitialLink();
  if (initialLink != null) {
    _handleLink(context, initialLink.path);
  }

  // Handle links while the app is running
  appLinks.uriLinkStream.listen((Uri uri) {
    _handleLink(context, uri.path);
  });
}

void _handleLink(BuildContext context, String query) {
  debugPrint('Got link: $query');
}
