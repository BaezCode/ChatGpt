import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';

class NoConexionPage extends StatefulWidget {
  const NoConexionPage({super.key});

  @override
  State<NoConexionPage> createState() => _NoConexionPageState();
}

class _NoConexionPageState extends State<NoConexionPage> {
  bool isDeviceConecte = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        isDeviceConecte = await InternetConnectionChecker().hasConnection;
        if (isDeviceConecte && mounted) {
          Navigator.pushReplacementNamed(context, 'loading');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff21232A),
        title: const Text("Sin Conexion"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'images/offline.json',
              height: 250,
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "Check your Internet Connection",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }
}
