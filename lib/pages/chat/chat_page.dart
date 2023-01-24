import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/pages/chat/widgets/account_menu_pop.dart';
import 'package:chat_gpt/pages/chat/widgets/menu_pop_chat.dart';
import 'package:chat_gpt/pages/chat/widgets/input_chat.dart';
import 'package:chat_gpt/pages/chat/widgets/no_msg_page.dart';
import 'package:chat_gpt/pages/chat/widgets/robot_chat.dart';
import 'package:chat_gpt/services/ads_service.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:chat_gpt/widgets/image_bubble.dart';
import 'package:chat_gpt/widgets/msg_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
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
        loginBloc.getReward(reward.amount);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xff424549),
          appBar: AppBar(
            leading: const AccountMenuPop(),
            centerTitle: false,
            title: Text(
              state.modo == 0 ? "Modo Texto" : "Modo Imagen",
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
              return Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: Row(
                      children: [
                        FadeInLeft(
                            duration: const Duration(milliseconds: 900),
                            child: RobotChat(
                              state: state,
                            )),
                      ],
                    ),
                  ),
                  const Divider(),
                  Flexible(
                    child: state.msg.isEmpty
                        ? NoMsgPage(
                            state: state,
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: state.msg.length,
                            itemBuilder: (ctx, i) => _crearBody(state.msg[i]),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const InputChat()
                ],
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
