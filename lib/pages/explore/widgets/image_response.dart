import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/bloc/action/action_bloc.dart';
import 'package:chat_gpt/bloc/login/login_bloc.dart';
import 'package:chat_gpt/helper/customWidgets.dart';
import 'package:chat_gpt/pages/explore/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class ImageResponse extends StatefulWidget {
  const ImageResponse({super.key});

  @override
  State<ImageResponse> createState() => _ImageResponseState();
}

class _ImageResponseState extends State<ImageResponse> {
  late ActionBloc actionBloc;
  late LoginBloc loginBloc;
  @override
  void initState() {
    super.initState();
    actionBloc = BlocProvider.of<ActionBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    actionBloc.response = actionBloc.state.opcionesLista!.initalResponse;
    actionBloc.lista = [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionBloc, ActionState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            CustomButton(
              texto: "Generate Image",
              state: state,
              onPressed: state.estaEscribiendo ? null : _submit,
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 20,
            ),
            if (actionBloc.lista.isEmpty) ...[
              _imageView(),
            ],
            if (actionBloc.lista.isNotEmpty) ...[
              _variationView(),
            ],
            const SizedBox(
              height: 15,
            ),
            if (actionBloc.response.isNotEmpty &&
                state.estaEscribiendo == false)
              TextButton(
                  onPressed: _variation, child: Text("Generate Variation")),
          ],
        );
      },
    );
  }

  Widget _imageView() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 250,
          width: 250,
          child: actionBloc.response.isEmpty
              ? Image.asset('assets/images/red.jpg')
              : GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'ImagePreview',
                      arguments: base64Decode(actionBloc.response)),
                  child: Image(
                      gaplessPlayback: true,
                      image: MemoryImage(base64Decode(actionBloc.response))),
                ),
        ));
  }

  Widget _variationView() {
    final lista = actionBloc.lista;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'ImagePreview',
                arguments: base64Decode(actionBloc.response)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                  height: size.height * 0.30,
                  gaplessPlayback: true,
                  image: MemoryImage(base64Decode(actionBloc.response))),
            ),
          ),
          SizedBox(
            width: size.height * 0.010,
          ),
          Column(
            children: [
              GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'ImagePreview',
                      arguments: base64Decode(lista[0]['b64_json'])),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                        height: size.height * 0.13,
                        gaplessPlayback: true,
                        image: MemoryImage(base64Decode(lista[0]['b64_json']))),
                  )),
              SizedBox(
                height: size.height * 0.040,
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'ImagePreview',
                    arguments: base64Decode(lista[1]['b64_json'])),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                        height: size.height * 0.13,
                        gaplessPlayback: true,
                        image:
                            MemoryImage(base64Decode(lista[1]['b64_json'])))),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!actionBloc.formKey.currentState!.validate()) return;
    actionBloc.formKey.currentState!.save();
    if (loginBloc.usuario!.tokens! <= 35 &&
        loginBloc.state.susActive == false) {
      Fluttertoast.showToast(msg: 'Low Tokens');
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      actionBloc.lista = [];
      await actionBloc.getImage(
          actionBloc.textController.text.trim(), loginBloc);
    }
  }

  void _variation() async {
    if (!actionBloc.formKey.currentState!.validate()) return;
    actionBloc.formKey.currentState!.save();
    if (loginBloc.usuario!.tokens! <= 35 &&
        loginBloc.state.susActive == false) {
      Fluttertoast.showToast(msg: 'Low Tokens');
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      await actionBloc.getImagesVariation(actionBloc.response, loginBloc);
    }
  }
}
