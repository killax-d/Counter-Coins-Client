import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({ Key? key }) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  List<CameraDescription> _cameras = [];
  CameraDescription? camera;
  CameraPreview? preview;
  Image? image;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  void _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    camera = _cameras.first;

    _controller = CameraController(camera!, ResolutionPreset.high);
    await _controller.initialize();
    setState(() {
      preview = CameraPreview(_controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.takePhoto,
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          final filePath = join(
            (await getTemporaryDirectory()).path,
            '${DateTime.now()}.png',
          );
          await _controller.takePicture().then((XFile file) {
            file.saveTo(filePath);
            Navigator.pop(context, filePath);
          });
        },
      ),
      body: Material(
        color: Colors.black,
        child: 
          preview != null
            ? Transform.scale(
                scale: 1 / (_controller.value.aspectRatio * MediaQuery.of(context).size.aspectRatio),
                alignment: Alignment.topCenter,
                child: preview,
              )
            : Container(),
      ),
    );
  }
}