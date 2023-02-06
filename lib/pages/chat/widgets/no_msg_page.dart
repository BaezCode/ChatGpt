import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class NoMsgPage extends StatefulWidget {
  final ChatState state;
  const NoMsgPage({super.key, required this.state});

  @override
  State<NoMsgPage> createState() => _NoMsgPageState();
}

class _NoMsgPageState extends State<NoMsgPage> {
  late ChatBloc chatBloc;
  late LoginBloc loginBloc;
  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;
    return widget.state.modo == 0 ? _exampleTest(resp) : _imageMode(resp);
  }

  Widget _exampleTest(AppLocalizations resp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          "assets/images/logo.png",
          height: 50,
          width: 50,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(resp.consult,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            )),
      ],
    );
  }

  Widget _imageMode(AppLocalizations resp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          "assets/images/logo.png",
          height: 50,
          width: 50,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(resp.consult,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            )),
      ],
    );
  }
}
