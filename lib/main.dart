import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/routes/routes.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  InAppPurchase.instance;

  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xff21232A),
  ));
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => LoginBloc(),
      ),
      BlocProvider(
        create: (context) => ChatBloc(),
      ),
      BlocProvider(
        create: (context) => PagosBloc(),
      ),
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gipchat',
      routes: appRoutes,
      initialRoute: 'loading',
    );
  }
}
