import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:chat_gpt/widgets/boton_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String nombre = "";
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff21232A),
      appBar: AppBar(
        backgroundColor: const Color(0xff21232A),
        title: const Text("Registro"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Registro de Cuenta",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              SizedBox(
                height: 25,
              ),
              _emailTextField(),
              SizedBox(
                height: 25,
              ),
              _passwordTextfield(),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: BotonLogin(
                  onPressed: _submit,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  color: Colors.blue[700],
                  icon: Icons.person,
                  texto: '       Crear Cuenta',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.80,
      child: TextFormField(
        autofocus: false,
        style: const TextStyle(color: Colors.white),
        onSaved: (newValue) => email = newValue!,
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

  Widget _passwordTextfield() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.80,
      child: TextFormField(
        autofocus: false,
        style: const TextStyle(color: Colors.white),
        onSaved: (newValue) => password = newValue!,
        validator: (value) {
          if (value == null || value.trim().length < 3) {
            return 'Password deve Contener almenos 3 Caracteres';
          }
          return null;
        },
        obscureText: true,
        decoration: inputCustomDecoration('Contrasenha', Icons.lock),
      ),
    );
  }

  _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    CustomWidgets.buildLoading(context);
    final respuesta = await loginBloc.register(
      email.trim(),
      password.trim(),
    );
    if (respuesta && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacementNamed(context, 'loading');
      Fluttertoast.showToast(msg: 'Bienvenido');
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: respuesta.toString());
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
