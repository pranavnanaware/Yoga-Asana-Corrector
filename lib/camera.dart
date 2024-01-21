import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final Callback setRecognitions;

  const Camera({this.cameras, required this.setRecognitions});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras!.isEmpty) {
      print('No camera is found');
    } else {
      controller = CameraController(
        widget.cameras![0], // Change to [1] for front camera
        ResolutionPreset.high,
      );

      controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller?.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;

            int startTime = DateTime.now().millisecondsSinceEpoch;

            Tflite.runPoseNetOnFrame(
              bytesList: img.planes.map((plane) {
                return plane.bytes;
              }).toList(),
              imageHeight: img.height,
              imageWidth: img.width,
              numResults: 1,
              rotation: -90,
              threshold: 0.2,
              nmsRadius: 10,
            ).then((recognitions) {
              int endTime = DateTime.now().millisecondsSinceEpoch;
              print("Detection took ${endTime - startTime}");

              widget.setRecognitions(recognitions!, img.height, img.width);

              isDetecting = false;
            });
          }
        });
      }).catchError((e) {
        print(e); // Handle initialization error
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    var size = MediaQuery.of(context).size;
    var deviceRatio = size.width / size.height;
    var previewSize = controller!.value.previewSize!;
    var cameraRatio = previewSize.height / previewSize.width;

    return Transform.scale(
      scale: cameraRatio / deviceRatio,
      child: Center(
        child: CameraPreview(controller!),
      ),
    );
  }
}
