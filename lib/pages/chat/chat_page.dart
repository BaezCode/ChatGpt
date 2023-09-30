import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/models/chat_response.dart';
import 'package:chat_gpt/pages/chat/widgets/input_chat.dart';
import 'package:chat_gpt/pages/chat/widgets/no_msg_page.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:chat_gpt/widgets/image_bubble.dart';
import 'package:chat_gpt/widgets/msg_bubble.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:rate_my_app/rate_my_app.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final prefs = PreferenciasUsuario();

  late ChatBloc chatBloc;
  late LoginBloc loginBloc;
  late PagosBloc pagosBloc;
  late ConversacionesBloc conversacionesBloc;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  // RewardedAd? _rewardedAd;
  bool isDeviceConecte = false;
  var formatter = NumberFormat('###,###,000');
  // final _adsConfig = Platform.isIOS ? '5159208' : '5159209';
  RateMyApp? rateMyApp;
  RewardedAd? rewardedAd;
  static const playStoreid = 'baez.code.Gip_chat22';
  static const appstoreId = 'baez.code.chatGpt';
  @override
  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    pagosBloc = BlocProvider.of<PagosBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);

    init();
    /*
    UnityAds.init(
      gameId: _adsConfig,
      onComplete: () {
        _loadAd();
      },
    );
    */
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        isDeviceConecte = await InternetConnectionChecker().hasConnection;
        chatBloc.add(SetConectado(isDeviceConecte));
      } else {
        chatBloc.add(SetConectado(false));
      }
    });
  }

  void init() async {
    if (conversacionesBloc.state.conversaciones.isEmpty) {
      final lista = List.generate(
          1,
          (index) =>
              ChatResponse(msg: jsonEncode([]), uid: '0', lastMsg: 'New Chat'));
      conversacionesBloc.add(SetListConv(
        lista,
      ));
      conversacionesBloc.add(SetuidConv('0'));
    } else {
      final index = conversacionesBloc.state.conversaciones.indexWhere(
          (element) => element.uid == conversacionesBloc.state.uidConv);

      final parsed =
          json.decode(conversacionesBloc.state.conversaciones[index].msg);
      final lista =
          List<ChatModel>.from(parsed.map((x) => ChatModel.fromJson(x)));

      chatBloc.chargeList(lista);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return RateMyAppBuilder(
            rateMyApp: RateMyApp(
                minDays: 7,
                minLaunches: 10,
                remindDays: 7,
                remindLaunches: 10,
                googlePlayIdentifier: playStoreid,
                appStoreIdentifier: appstoreId),
            onInitialized: ((context, rate) {
              setState(() {
                rateMyApp = rate;
              });

              if (rateMyApp!.shouldOpenDialog) {
                rateMyApp!.showRateDialog(context);
              }
            }),
            builder: (context) => rateMyApp == null
                ? const Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Column(
                      children: [
                        if (state.msg.isEmpty) ...[
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: FadeIn(
                              child: NoMsgPage(
                                state: state,
                              ),
                            ),
                          ),
                        ],
                        Flexible(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: state.msg.length,
                            itemBuilder: (ctx, i) => _crearBody(state.msg[i]),
                          ),
                        ),
                        const InputChat()
                      ],
                    ),
                  ));
      },
    );
  }

  Widget _crearBody(ChatModel msg) {
    switch (msg.tipo) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: MessageBubble(
              de: msg.de,
              para: msg.para,
              tokens: msg.tokens,
              texto: msg.mensaje),
        );

      case 1:
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ImageBubble(
            lista: msg.list,
            de: msg.de,
            para: msg.para,
            texto: msg.mensaje,
            tokens: msg.tokens,
          ),
        );

      default:
        return MessageBubble(
            de: msg.de, para: msg.para, tokens: msg.tokens, texto: msg.mensaje);
    }
  }
}
