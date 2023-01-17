import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWidgets {
  CustomWidgets._();

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
                        image: AssetImage("images/astronaut.jpg"),
                        height: 250,
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                FadeIn(
                  duration: const Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                    color: Color(0xff424549),
                    child: Text(
                      'Comenzar',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      prefs.vistoImagen = true;
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }

  static crearBuildText(BuildContext context) {
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
                        image: AssetImage("images/astronaut.jpg"),
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
                      prefs.vistoTexto = true;
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }
}
