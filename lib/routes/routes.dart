import 'package:chat_gpt/pages/chat/chat_page.dart';
import 'package:chat_gpt/pages/chat/widgets/image_preview_page.dart';
import 'package:chat_gpt/pages/loading_page.dart';
import 'package:chat_gpt/pages/login_page.dart';
import 'package:chat_gpt/pages/register_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'chat': (_) => const ChatPage(),
  'ImagePreview': (_) => const ImagePreview(),
  'loading': (_) => const LoadingPage(),
  'login': (_) => const LoginPage(),
  'registro': (_) => const RegisterPage(),
};
