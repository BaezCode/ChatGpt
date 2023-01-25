import 'dart:io';

import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:chat_gpt/services/apple_signin_service.dart';
import 'package:chat_gpt/widgets/boton_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc loginBloc;
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff21232A),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                ),
                SizedBox(
                  height: size.height * 0.030,
                ),
                _emailTextField(context),
                const SizedBox(
                  height: 25,
                ),
                _passwordTextfield(context),
                SizedBox(
                  height: size.height * 0.020,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: BotonLogin(
                    onPressed: _submit,
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    color: Colors.blue[700],
                    icon: Icons.login,
                    texto: '       Hacer Login',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: BotonLogin(
                    onPressed: () => Navigator.pushNamed(context, 'registro'),
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    color: Colors.white,
                    icon: Icons.email,
                    texto: '       Crear Nueva Cuenta',
                  ),
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
                          Fluttertoast.showToast(msg: "Error Intente de Nuevo");
                          Navigator.pop(context);
                        }
                      },
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      color: const Color(0xffA11216),
                      icon: FontAwesomeIcons.google,
                      texto: '       Continuar con Google',
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
                          Fluttertoast.showToast(msg: "Bienvenido");
                          Navigator.pushReplacementNamed(context, 'loading');
                        } else {
                          Fluttertoast.showToast(
                              msg: "Error Del Login Intente de Nuevo");
                          Navigator.pop(context);
                        }
                      },
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      color: Colors.white,
                      icon: FontAwesomeIcons.apple,
                      texto: '       Login con Apple',
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.80,
      child: TextFormField(
        autofocus: false,
        style: const TextStyle(color: Colors.white),
        onChanged: (newValue) => email = newValue,
        validator: (value) {
          String pattern =
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?)*$";
          RegExp regex = RegExp(pattern);
          if (value == null || value.isEmpty || !regex.hasMatch(value)) {
            return 'Ingrese un E-mail Valido';
          }
          return null;
        },
        decoration: inputCustomDecoration('Email', Icons.email),
      ),
    );
  }

  Widget _passwordTextfield(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.80,
      child: TextFormField(
        autofocus: false,
        style: TextStyle(color: Colors.white),
        onChanged: (newValue) => password = newValue,
        validator: (value) {
          if (value == null || value.trim().length < 3) {
            return 'Password deve Contener almenos 3 Caracteres';
          }
          return null;
        },
        obscureText: true,
        decoration: inputCustomDecoration('Contraseña', Icons.lock),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    CustomWidgets.buildLoading(context);
    final bool respuesta = await loginBloc.login(
      email.trim(),
      password.trim(),
    );
    if (respuesta && mounted) {
      Fluttertoast.showToast(
        msg: 'Bienvenido de Vuelta',
      );
      Navigator.pushReplacementNamed(context, 'loading');
    } else {
      Fluttertoast.showToast(
        msg: 'Login Incorrecto, Revise Sus Credenciales',
      );
      Navigator.pop(context);
    }
  }

  InputDecoration inputCustomDecoration(String label, IconData icon) {
    return InputDecoration(
      labelStyle: TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      labelText: label,
    );
  }
}
