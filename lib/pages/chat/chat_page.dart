import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/pages/chat/widgets/account_menu_pop.dart';
import 'package:chat_gpt/pages/chat/widgets/menu_pop_chat.dart';
import 'package:chat_gpt/pages/chat/widgets/input_chat.dart';
import 'package:chat_gpt/pages/chat/widgets/no_msg_page.dart';
import 'package:chat_gpt/services/ads_service.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:chat_gpt/widgets/image_bubble.dart';
import 'package:chat_gpt/widgets/msg_bubble.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../helper/customWidgets.dart';

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
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  RewardedAd? _rewardedAd;
  bool isDeviceConecte = false;
  var formatter = NumberFormat('###,###,000');

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    pagosBloc = BlocProvider.of<PagosBloc>(context);

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

    _createRewardedAd();
    Future.delayed(Duration.zero, () {
      _confirIntro();
    });
  }

  void _confirIntro() {
    if (prefs.vistoTexto == false) {
      CustomWidgets.crearBuildText(context);
    }
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdMobService.rewardedAdUnitId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) => setState(() {
                  _rewardedAd = ad;
                }),
            onAdFailedToLoad: (error) {
              _rewardedAd = null;
            }));
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      try {
        _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _createRewardedAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _createRewardedAd();
          },
        );
        _rewardedAd!.show(onUserEarnedReward: (ad, reward) async {
          final resp = AppLocalizations.of(context)!;

          loginBloc.getReward(reward.amount);
          Fluttertoast.showToast(msg: resp.rewward);
          setState(() {});
        });
      } catch (e) {
        return;
      }
    } else {
      _createRewardedAd();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xff424549),
          appBar: AppBar(
            bottom: state.conectado
                ? null
                : PreferredSize(
                    preferredSize: const Size.fromHeight(4.0),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.red[700],
                      color: Colors.red[300],
                    )),
            leading: const AccountMenuPop(),
            centerTitle: false,
            title: Text(
              state.modo == 0 ? resp.header : resp.header2,
              style: const TextStyle(fontSize: 15),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.purpleAccent,
                          Colors.indigoAccent,
                        ],
                      ),
                    ),
                    child: MaterialButton(
                        onPressed: _showRewardedAd,
                        child: const Text(
                          "+50 Tokens",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ))),
              ),
              if (state.msg.isNotEmpty)
                IconButton(
                    onPressed: () {
                      chatBloc.clearData();
                    },
                    icon: const Icon(Icons.delete)),
              const MenuPopChat(),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/fondo.png"),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                pagosBloc.add(SetCompra(0, ''));
                                Navigator.pushNamed(context, 'premium');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.purpleAccent,
                                      Colors.indigoAccent,
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      LottieBuilder.asset(
                                        'assets/images/premium.json',
                                        height: 25,
                                      ),
                                      Text(
                                        formatter
                                            .format(loginBloc.usuario!.tokens),
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color:
                                    state.modo == 0 ? Colors.blue[700] : null,
                                child: const Text(
                                  "Chat",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  chatBloc.clearData();
                                  chatBloc.add(SetModo(0));
                                  if (prefs.vistoImagen == false) {
                                    CustomWidgets.crearBuildImage(context);
                                  }
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color:
                                    state.modo == 1 ? Colors.blue[700] : null,
                                child: const Text(
                                  "Images",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  chatBloc.clearData();
                                  chatBloc.add(SetModo(1));
                                  if (prefs.vistoImagen == false) {
                                    CustomWidgets.crearBuildImage(context);
                                  }
                                }),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                      const Divider(),
                      if (state.msg.isEmpty)
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: FadeInLeft(
                            child: NoMsgPage(
                              state: state,
                            ),
                          ),
                        ),
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
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _crearBody(ChatModel msg) {
    switch (msg.tipo) {
      case 0:
        return MessageBubble(
            de: msg.de, para: msg.para, tokens: msg.tokens, texto: msg.mensaje);
      case 1:
        return ImageBubble(
          de: msg.de,
          para: msg.para,
          texto: msg.mensaje,
          tokens: msg.tokens,
        );
      default:
        return MessageBubble(
            de: msg.de, para: msg.para, tokens: msg.tokens, texto: msg.mensaje);
    }
  }
}
