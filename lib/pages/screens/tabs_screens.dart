import 'dart:convert';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:chat_gpt/bloc/chat/chat_bloc.dart';
import 'package:chat_gpt/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/bloc/pagos/pagos_bloc.dart';
import 'package:chat_gpt/pages/chat/chat_page.dart';
import 'package:chat_gpt/pages/chat/widgets/drawer_home.dart';
import 'package:chat_gpt/pages/chat/widgets/menu_pop_chat.dart';
import 'package:chat_gpt/pages/explore/explore_page.dart';
import 'package:chat_gpt/pages/premium/premium_page.dart';
import 'package:chat_gpt/pages/screens/widgets/custom_nav.dart';
import 'package:chat_gpt/services/ads_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class TabsScreens extends StatefulWidget {
  const TabsScreens({super.key});

  @override
  State<TabsScreens> createState() => _TabsScreensState();
}

class _TabsScreensState extends State<TabsScreens> {
  late LoginBloc loginBloc;
  late PagosBloc pagosBloc;
  late ConversacionesBloc conversacionesBloc;
  late ChatBloc chatBloc;

  RewardedAd? rewardedAd;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    pagosBloc = BlocProvider.of<PagosBloc>(context);
    chatBloc = BlocProvider.of<ChatBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);

    if (Platform.isIOS) {
      initPlugin();
    }
    checkSuscpricion();
    _createRewardedAd();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdMobService.rewardedAdunitIdGoogle!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) => setState(() {
            rewardedAd = ad;
          }),
          onAdFailedToLoad: (error) => setState(() {
            rewardedAd = null;
          }),
        ));
  }

  void _showRewardedAd() {
    final resp = AppLocalizations.of(context)!;

    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAd();
        },
      );
      rewardedAd!.show(
        onUserEarnedReward: (ad, reward) async {
          reward.amount;
          await loginBloc.getReward(reward.amount);
          Fluttertoast.showToast(msg: resp.rewward);
        },
      );
    }
  }

  Future<void> showCustomTrackingDialog() async {
    final resp = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(resp.dear1),
        content: Text(
          '${resp.dear2} '
          '${resp.dear3}\n\n${resp.dear4}'
          '${resp.dear5}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await showCustomTrackingDialog();
      await Future.delayed(const Duration(milliseconds: 200));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  void checkSuscpricion() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.activeSubscriptions.isEmpty) {
        loginBloc.add(SetSuscriptionActive(false));
      } else {
        loginBloc.add(SetSuscriptionActive(true));
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[900],
          bottomNavigationBar: CustomNav(index: state.indexHome),
          key: _scaffoldKey,
          drawer: const DrawerHome(),
          appBar: state.indexHome == 1
              ? AppBar(
                  title: loginBloc.state.susActive
                      ? const Text(
                          "Gipchat",
                          style: TextStyle(color: Colors.white),
                        )
                      : null,
                  backgroundColor: const Color(0xff21232A),
                  bottom: state.conectado
                      ? null
                      : PreferredSize(
                          preferredSize: const Size.fromHeight(4.0),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.red[700],
                            color: Colors.red[300],
                          )),
                  leading: IconButton(
                      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 25,
                      )),
                  actions: [
                    if (loginBloc.state.susActive == false) ...[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
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
                      ),
                      TextButton(
                          onPressed: _showRewardedAd,
                          child: const Text("+50 Tokens")),
                    ],
                    if (state.msg.isNotEmpty)
                      IconButton(
                          onPressed: () {
                            conversacionesBloc.updateConv(
                                jsonEncode([]), 'All Deleted');
                            chatBloc.clearData();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          )),
                    const MenuPopChat(),
                  ],
                )
              : null,
          body: _HomePageBody(state: state),
        );
      },
    );
  }
}

class _HomePageBody extends StatelessWidget {
  final ChatState state;
  const _HomePageBody({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.indexHome) {
      case 0:
        return const ExplorePage();
      case 1:
        return const ChatPage();
      case 2:
        return const PremiumPage();

      default:
        return const ChatPage();
    }
  }
}
