import 'package:chat_gpt/pages/chat/widgets/image_preview_page.dart';
import 'package:chat_gpt/pages/delete_account_page.dart';
import 'package:chat_gpt/pages/loading_page.dart';
import 'package:chat_gpt/pages/login_page.dart';
import 'package:chat_gpt/pages/premium/premium_page.dart';
import 'package:chat_gpt/pages/premium/widgets/thanks_you_page.dart';
import 'package:chat_gpt/pages/screens/tabs_screens.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'home': (_) => const TabsScreens(),
  'ImagePreview': (_) => const ImagePreview(),
  'loading': (_) => const LoadingPage(),
  'login': (_) => const LoginPage(),
  'premium': (_) => const PremiumPage(),
  'thanks': (_) => const ThanksYouPage(),
  'deleteAccount': (_) => const DeleteAccountPage(),
};
