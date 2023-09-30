import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff21232A),
      body: FutureBuilder(
          future: checkLoginState(context),
          builder: (context, snapshot) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final chatbloc = BlocProvider.of<ChatBloc>(context);
    bool result = await InternetConnectionChecker().hasConnection;

    final autenticado = await loginBloc.isLoggedIn();
    if (result == false && mounted) {
      Navigator.pushReplacementNamed(context, 'offline');
    } else if (autenticado && mounted) {
      chatbloc.add(SetTokens(loginBloc.usuario!.tokens!));
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
