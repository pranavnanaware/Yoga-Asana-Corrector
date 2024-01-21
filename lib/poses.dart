import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:yoga_asana/inference.dart';
import 'package:yoga_asana/yoga_card.dart';
import 'package:card_swiper/card_swiper.dart';

class Poses extends StatelessWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final List<String> asanas;
  final Color color;

  const Poses({
    required this.cameras,
    required this.title,
    required this.model, // Ensure this is the correct model path if dynamic
    required this.asanas,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(title),
      ),
      body: Center(
        child: Container(
          height: 500,
          child: Swiper(
            itemCount: asanas.length,
            loop: false,
            viewportFraction: 0.8,
            scale: 0.82,
            outer: true,
            pagination: const SwiperPagination(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(32.0),
            ),
            onTap: (index) => _onSelect(context, asanas[index]),
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Container(
                  height: 360,
                  child: YogaCard(
                    asana: asanas[index],
                    color: color,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSelect(BuildContext context, String customModelName) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InferencePage(
          cameras: cameras,
          title: customModelName,
          model: model, // Use the model parameter passed to the Poses widget
          customModel: customModelName,
        ),
      ),
    );
  }
}
