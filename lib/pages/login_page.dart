import 'dart:io';

import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:chat_gpt/services/apple_signin_service.dart';
import 'package:chat_gpt/widgets/boton_login.dart';
import 'package:chat_gpt/widgets/home_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resp = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xff21232A),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HomeSlider(),
          SizedBox(
            height: size.height * 0.080,
          ),
          if (Platform.isAndroid)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: BotonLogin(
                onPressed: () async {
                  CustomWidgets.buildLoading(context);

                  final resp = await loginBloc.loginGoogle();
                  if (resp && mounted) {
                    Navigator.pushReplacementNamed(context, 'loading');
                  } else {
                    Fluttertoast.showToast(msg: "Error");
                    Navigator.pop(context);
                  }
                },
                textColor: Colors.white,
                iconColor: Colors.white,
                color: const Color(0xffA11216),
                icon: FontAwesomeIcons.google,
                texto: '       ${resp.googla}',
              ),
            ),
          if (Platform.isIOS)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: BotonLogin(
                onPressed: () async {
                  CustomWidgets.buildLoading(context);
                  final result = await AppleSignInService.sigIn(context);
                  if (result && mounted) {
                    Fluttertoast.showToast(msg: resp.welcome);
                    Navigator.pushReplacementNamed(context, 'loading');
                  } else {
                    Fluttertoast.showToast(msg: resp.error);
                    Navigator.pop(context);
                  }
                },
                textColor: Colors.black,
                iconColor: Colors.black,
                color: Colors.white,
                icon: FontAwesomeIcons.apple,
                texto: '       ${resp.loginApple}',
              ),
            ),
        ],
      ),
    );
  }
}
