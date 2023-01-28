import 'dart:io';

import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:chat_gpt/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String text = "";
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xff424549),
      appBar: AppBar(
        backgroundColor: const Color(0xff21232A),
        title: Text(
          resp.delete1,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                resp.delete2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                resp.delete3,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                resp.delete4,
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Tokens",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                resp.delete5,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                resp.delete6,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Enter CONFIRM to delete your account",
                style: TextStyle(color: Colors.white),
              ),
            ),
            _nombreTextField(),
            const SizedBox(
              height: 25,
            ),
            Center(
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    onPressed: _submit,
                    child: Text(resp.confirm)))
          ],
        ),
      ),
    );
  }

  Widget _nombreTextField() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: size.width * 0.80,
        child: TextFormField(
          autofocus: false,
          style: const TextStyle(color: Colors.white),
          onSaved: (newValue) => text = newValue!,
          validator: (value) {
            if (value == null || value.trim().length < 2) {
              return 'ERROR IN VALIDATION';
            }
            return null;
          },
          decoration: inputCustomDecoration(),
        ),
      ),
    );
  }

  _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    CustomWidgets.buildLoading(context);
    if (text != "CONFIRM") {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error in text try Again");
    } else if (Platform.isIOS) {
      await loginBloc.deleteAccountApple();
      if (mounted) {
        Navigator.pushReplacementNamed(context, 'login');
      }
    }
  }

  InputDecoration inputCustomDecoration() {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
