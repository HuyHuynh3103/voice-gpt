import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_gpt/pages/message_chat.dart';

final routers = GoRouter(
  initialLocation: '/message_chat',
  routes: <RouteBase>[
    GoRoute(
        path: '/message_chat',
        builder: (context, state) => const MessageChatPage() // builder: (context, state) => MessageChatPage(),
        ),
    GoRoute(path: '/settings', builder: (context, state) => Container()
        // builder: (context, state) => SettingsPage(),
        ),
  ],
);
