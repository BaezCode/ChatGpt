
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/l10n/l10n.dart';
import 'package:chat_gpt/routes/routes.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

final _configuration =
    PurchasesConfiguration('appl_qGzUoiUHsZSFFGNrnFBVvujDOQQ');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Purchases.configure(_configuration);
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
      supportedLocales: L10n.all,
      debugShowCheckedModeBanner: false,
      title: 'Gipchat',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: appRoutes,
      initialRoute: 'loading',
    );
  }
}
