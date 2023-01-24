import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomWidgets {
  CustomWidgets._();

  static buildSliderRange(BuildContext context) {
    final prefs = PreferenciasUsuario();
    double limite = prefs.limiteToken;
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
                            "  Limite de uso de Tokens: ${prefs.limiteToken.toInt()}",
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
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Aqui puedes Establecer el Limite Maximo de uso Tokens por respuesta que pueden ser Utilizados en cada Respuesta',
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
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'El modelo se mueve a través de Tokens por la cual 1 Token equivalen a 5 Caracteres de respuesta Escrita por el Robot, cuando más tokens tenga configurado, más compleja y detallada será la respuesta dada por el modelo ,cuanto menos tokens tenga configurado más corta será la respuesta',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: const Color(0xff21232A),
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(msg: 'Alterado Correctamente');
                          Navigator.pop(context);
                          prefs.limiteToken = limite;
                        })
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
            height: size.height * 0.60,
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
                    duration: const Duration(milliseconds: 1000),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'Crea imágenes y Arte realistas a Partir de una Descripción en Lenguaje Natural Escribe lo que Piensas y la Imagen sera Creada',
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
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: const Color(0xff424549),
                      child: const Text(
                        'Comenzar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        prefs.vistoImagen = true;
                        Navigator.pop(context);
                      })
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
                        "  Modelo GPT-3",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Puede entender y Generar Lenguaje Natural Puedes hacer preguntas complejas por la cual le dará una respuesta concreta gracias al potente motor Davinci ",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      Text(
                        "  Tokens",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "El modelo se mueve a través de Tokens por la cual 1 Token equivalen a 5 Caracteres de respuesta de complejidad del modelo, cuando más tokens tenga configurado, más compleja y detallada será la respuesta dada por el modelo ,cuanto menos tokens tenga configurado más corta será la respuesta dada",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      Text(
                        "  ¿Como Adquirir Tokens?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Puedes adquirir Tokens gratuitamente viendo anuncios o de manera Paga de diferentes planos que tienes disponible en el aplicativo, esto nos ayuda a mantener el aplicativo en funcionamiento",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      Text(
                        "  Tokenes Gratuitos!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Como primera instalación del sistema tienes disponible 3.000 tókenes gratuitos para que puedas hacer sus primeras preguntas o genera sus primeras imágenes, Disfrútelo",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Limitar Tokens',
                          style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Aqui puedes Establecer el Limite Maximo de uso Tokens por respuesta que pueden ser Utilizados en cada Respuesta',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Token: 100 (Recomendado) , Token: 200 (Respuesta Detallada)',
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
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'El modelo se mueve a través de Tokens por la cual 1 Token equivalen a 5 Caracteres de respuesta Escrita por el Robot, cuando más tokens tenga configurado, más compleja y detallada será la respuesta dada por el modelo ,cuanto menos tokens tenga configurado más corta será la respuesta',
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
                            child: const Text(
                              'Comenzar!',
                              style: TextStyle(color: Colors.white),
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
