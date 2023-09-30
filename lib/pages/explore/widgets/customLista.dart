// ignore: file_names
import 'package:chat_gpt/models/lista_datos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class CustomLista {
  static listReturn(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    final List<OpcionesLista> lista = [
      OpcionesLista(
          'assets/images/translation.png',
          resp.tap1,
          resp.tap2,
          'Translate this into: \n1. French, \n2. Spanish and \n3. Japanese, \n\nWhat rooms do you have available?',
          'Quels sont les chambres que vous avez disponibles?\n2.¿Qué habitaciones tienes disponibles?\n3.どの部屋が利用可能ですか',
          0.3,
          100,
          1.0,
          0.0,
          0.0,
          0),
      OpcionesLista('assets/images/imagen.png', resp.tap3, resp.tap4,
          'Realistic Red Monkey', '', 0.3, 100, 1.0, 0.0, 0.0, 1),
      OpcionesLista(
          'assets/images/graduation.png',
          resp.tap5,
          resp.tap6,
          'Correct this to standard English:\n\nShe no went to the market.',
          'She did not go to the market.',
          0,
          60,
          1.0,
          0.0,
          0.0,
          0),
      OpcionesLista(
          'assets/images/enviar.png',
          resp.tap7,
          resp.tap8,
          'What are 5 key points I should know when studying Ancient Rome?',
          '1. Understand the Roman Republic and its political and social structures.\n2. Learn about the major events and people of the Roman Empire, including the Pax Romana.\n3. Familiarize yourself with Roman culture and society, including language, art, architecture, literature, law, and religion.\n4. Study the Roman military, its tactics and organization, and its effects on the empire.\n5. Examine the decline of the Roman Empire, its eventual fall, and its legacy.',
          0.3,
          150,
          1.0,
          0.0,
          0.0,
          0),
      OpcionesLista(
          'assets/images/twitter.png',
          resp.tap9,
          resp.tap10,
          'Give me 5 ideas for Sentimental tweets with emojis',
          '1. 💗 Missing you so much today! 💔\n2. 💞 Thinking of all the good times we shared together 🤗\n3. 💝 Wishing you were here to share this moment with me 🤗\n4. 💛 Sending you lots of love and hugs 🤗\n5. 💙 Cherishing all the memories we made together 🤗',
          0,
          60,
          1.0,
          0.0,
          0.0,
          0),
      OpcionesLista(
          'assets/images/parlante.png',
          resp.tap11,
          resp.tap12,
          'Write a creative ad for the following product to run on Facebook aimed at parents:\n\nProduct: Learning Room is a virtual environment to help students from kindergarten to high school excel in school.',
          'Are you looking for a way to give your child a head start in school? Look no further than Learning Room! Our virtual environment is designed to help students from kindergarten to high school excel in their studies. Our unique platform offers personalized learning plans, interactive activities, and real-time feedback to ensure your child is getting the most out of their education. Give your child the best chance to succeed in school with Learning Room!',
          0.5,
          100,
          1.0,
          0.0,
          0.0,
          0),
      OpcionesLista(
          'assets/images/maletin.png',
          resp.tap13,
          resp.tap14,
          'Create a list of 8 questions for my interview with a developer:',
          '1. What experience do you have in software development?\n2. What programming languages are you most familiar with?\n3. What have been some of the most challenging development projects you have worked on?\n4. How do you stay up to date with the latest technology trends?\n5. What methods do you use to troubleshoot and debug code?\n6. How do you handle working in a team environment?\n7. How do you prioritize tasks when faced with multiple deadlines?\n8. What do you consider to be your greatest accomplishment in software development?',
          0.5,
          150,
          1.0,
          0.0,
          0.0,
          0),
    ];
    return lista;
  }
}
