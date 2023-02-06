import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class CustomWidgets {
  CustomWidgets._();

  static buildSliderRange(BuildContext context) {
    final prefs = PreferenciasUsuario();
    double limite = prefs.limiteToken;
    final resp = AppLocalizations.of(context)!;

    showModalBottomSheet(
        backgroundColor: const Color(0xff424549),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          Text(
                            "  ${resp.tokenLimit}: ${prefs.limiteToken.toInt()}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                          const Spacer(),
                          if (prefs.vistoTexto)
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                )),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        resp.tokenLimitDescrp,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Slider(
                        value: limite,
                        min: 35,
                        max: 300,
                        divisions: 100,
                        label: limite.round().toString(),
                        onChanged: (data) {
                          setState(() {
                            limite = data;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        resp.tokenLimitDescrp2,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SafeArea(
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: const Color(0xff21232A),
                          child: Text(
                            resp.confirm,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Fluttertoast.showToast(msg: 'Saved OK');
                            Navigator.pop(context);
                            prefs.limiteToken = limite;
                          }),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  static buildLoading(BuildContext context) {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (bc) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xffA11216),
            ),
          );
        });
  }

  static crearBuildImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final prefs = PreferenciasUsuario();
    final resp = AppLocalizations.of(context)!;

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isDismissible: false,
        backgroundColor: const Color(0xff21232A),
        isScrollControlled: true,
        context: context,
        builder: (bc) {
          return SizedBox(
            height: size.height * 0.80,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FadeIn(
                        duration: const Duration(milliseconds: 1000),
                        child: const Image(
                          image: AssetImage("assets/images/astronaut.jpg"),
                          height: 250,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeIn(
                    duration: Duration(milliseconds: 1000),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(resp.imageInfo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SafeArea(
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: const Color(0xff424549),
                        child: Text(
                          resp.start,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          prefs.vistoImagen = true;
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  static crearBuildText(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final prefs = PreferenciasUsuario();
    double limite = prefs.limiteToken;
    final resp = AppLocalizations.of(context)!;

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isDismissible: false,
        backgroundColor: const Color(0xff21232A),
        isScrollControlled: true,
        context: context,
        builder: (bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SizedBox(
                height: size.height * 0.95,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "  ${resp.model}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          resp.davinci,
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      Text(
                        "  Tokens",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          resp.caracter,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                      ),
                      Text(
                        "  ${resp.adTokens}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          resp.tokenCer,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          resp.limitTokens,
                          style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          resp.limitTokensDescripc,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Token: 100 (Recomended) , Token: 200 (Detailed Answer)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Slider(
                          value: limite,
                          min: 35,
                          max: 300,
                          divisions: 100,
                          label: limite.round().toString(),
                          onChanged: (data) {
                            setState(() {
                              limite = data;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          resp.finalDescrip,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: const Color(0xff424549),
                            child: Text(
                              resp.start,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              prefs.vistoTexto = true;
                              Navigator.pop(context);
                              prefs.limiteToken = limite;
                            }),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
