import 'dart:convert';

import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/helper/dialog.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/models/chat_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';
import 'package:uuid/uuid.dart';

class DrawerHome extends StatefulWidget {
  const DrawerHome({super.key});

  @override
  State<DrawerHome> createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  late PagosBloc pagosBloc;
  late LoginBloc loginBloc;
  late ConversacionesBloc conversacionesBloc;
  late ChatBloc chatBloc;
  var uid = const Uuid();

  @override
  void initState() {
    super.initState();
    pagosBloc = BlocProvider.of<PagosBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    chatBloc = BlocProvider.of<ChatBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,###,000');
    final size = MediaQuery.of(context).size;
    final resp = AppLocalizations.of(context)!;

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: const Color(0xfff20262e),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20))),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.white,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      LottieBuilder.asset(
                        'assets/images/premium.json',
                        height: 25,
                      ),
                      if (state.susActive == false)
                        Text(
                          formatter.format(loginBloc.usuario!.tokens),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                      if (state.susActive) ...[
                        const Text(
                          "Unlimited",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        const Text(
                          "  Tokens",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                      const Spacer(),
                      if (loginBloc.state.susActive == false)
                        Container(
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff3bbeca),
                                  Color(0xff4A78BD),
                                ],
                              ),
                            ),
                            child: MaterialButton(
                                onPressed: () {
                                  pagosBloc.add(SetCompra('', null));
                                  Navigator.pushNamed(context, 'premium');
                                },
                                child: Text(
                                  resp.pro,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ))),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Text(
                          "Chats",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const Spacer(),
                        MaterialButton(
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  "New Chat",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            onPressed: () async {
                              final uidCreated = uid.v4();
                              final chatRespose = ChatResponse(
                                  msg: jsonEncode([]),
                                  uid: uidCreated,
                                  lastMsg: 'New Chat');
                              conversacionesBloc.state.conversaciones
                                  .add(chatRespose);
                              conversacionesBloc.add(SetListConv(
                                conversacionesBloc.state.conversaciones,
                              ));
                            })
                      ],
                    )),
                BlocBuilder<ConversacionesBloc, ConversacionesState>(
                  builder: (context, state) {
                    return SizedBox(
                      height: size.height * 0.55,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: state.conversaciones.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) =>
                            _crearBody(state.conversaciones[i], context, state),
                      ),
                    );
                  },
                ),
                ListTile(
                  onTap: () async {
                    final action = await Dialogs.yesAbortDialog(
                        context, resp.logout1, resp.logout2);
                    if (action == DialogAction.yes) {
                      loginBloc.logout();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, 'login');
                    } else {}
                  },
                  trailing: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    final action =
                        // ignore: use_build_context_synchronously
                        await Dialogs.yesAbortDialog(context, "Delete Account",
                            "Are you sure to delete your account?");
                    if (action == DialogAction.yes) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, 'deleteAccount');
                    } else {}
                  },
                  trailing: Icon(
                    Icons.delete,
                    color: Colors.red[700],
                  ),
                  title: Text(
                    "Delete Account",
                    style: TextStyle(fontSize: 15, color: Colors.red[700]),
                  ),
                )
              ],
            ),
          )),
        );
      },
    );
  }

  Widget _crearBody(ChatResponse chatResponse, BuildContext context,
      ConversacionesState state) {
    return Dismissible(
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd &&
            chatResponse.uid != '0') {
          conversacionesBloc.state.conversaciones.remove(chatResponse);
          conversacionesBloc.add(SetListConv(
            conversacionesBloc.state.conversaciones,
          ));
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return false;
        }
        return true;
      },
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.delete,
          color: Colors.red[700],
        ),
      ),
      key: UniqueKey(),
      child: ListTile(
        onTap: () async {
          final parsed = json.decode(chatResponse.msg);
          final lista =
              List<ChatModel>.from(parsed.map((x) => ChatModel.fromJson(x)));
          chatBloc.chargeList(lista);
          conversacionesBloc.add(SetuidConv(chatResponse.uid));
        },
        trailing: Icon(
          chatResponse.uid == state.uidConv
              ? Icons.circle
              : Icons.circle_outlined,
          color: Colors.white,
          size: 20,
        ),
        title: Text(
          chatResponse.lastMsg,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
