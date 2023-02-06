import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/ChatGpt-master.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int data = 0;

  final List<String> image = [
    'assets/images/astronaut.jpg',
    'assets/images/2.png'
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resp = AppLocalizations.of(context)!;

    return Column(
      children: [
        SizedBox(
          height: size.height * 0.60,
          child: Swiper(
            onIndexChanged: (value) {
              setState(() {
                data = value;
              });
            },
            itemCount: image.length,
            itemBuilder: (context, index) => _buildBody(image[index]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              data == 1 ? resp.helloWorld2 : resp.helloWorld,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(String image) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(20),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          )),
    );
  }
}
