import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class camera extends StatefulWidget {
  List<CameraDescription> cameras;
  camera(this.cameras);
  @override
  State<StatefulWidget> createState() {
    return new CameraState();
  }
}

class CameraState extends State<camera> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
      controller!.initialize().then((_) {
        if (mounted) return;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return controller != null
        ? new Container(
            child: new AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: CameraPreview(controller!),
          ))
        : SizedBox();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
