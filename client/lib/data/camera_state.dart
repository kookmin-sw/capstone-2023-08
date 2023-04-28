import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraState extends ChangeNotifier {
  CameraController? _controller;
  CameraDescription? _cameraDescription;
  bool _readyTakePhoto = false;

  void getReadyToTakePhoto() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras != null && cameras.isNotEmpty) {
      setCameraDescription(cameras[0]);
    }

    bool init = false;
    while (!init) {
      init = await initialize();
    }
    _readyTakePhoto = true;
    notifyListeners();
  }

  void setCameraDescription(CameraDescription cameraDescription) {
    _cameraDescription = cameraDescription;
    _controller = CameraController(_cameraDescription!, ResolutionPreset.max);
  }

  Future<bool> initialize() async {
    try {
      await _controller!.initialize();
      return true;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    _controller = null;
    _cameraDescription = null;
    _readyTakePhoto = false;
    notifyListeners();
  }

  CameraController get controller => _controller!;
  CameraDescription get description => _cameraDescription!;
  bool get isReadyToTakePhoto => _readyTakePhoto;
}
