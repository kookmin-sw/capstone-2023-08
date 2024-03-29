import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:client/constant/colors.dart';
import 'package:client/data/user_model.dart';
import 'package:client/layout/default_layout.dart';
import 'package:client/screen/camera_result.dart';
import 'package:client/screen/gallery_pick_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:image/image.dart' as img;

class CameraScreen extends StatefulWidget {
  List<CameraDescription> cameras;

  CameraScreen({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  // camera
  late CameraController _controller;
  late XFile picture;
  late int selectedCamera;

  // timer
  late bool isTimerStarted;
  Timer? countdownTimer;

  late int changedSeconds;
  late double percentage = 1.0;

  double percent = 0.0;

  Future<void> startTimer() async {
    isTimerStarted = true;
    setState(() {});
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = changedSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else if (seconds == 0) {
        percentage = 0.0;
      } else {
        percentage = seconds / 10.0;
      }
      changedSeconds = seconds;
    });
  }

  void initializeController(CameraDescription description) {
    _controller = CameraController(
      description,
      ResolutionPreset.medium,
    );
    _controller!.setFlashMode(FlashMode.off);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      print(_controller!.value.aspectRatio);
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  void updateController(CameraDescription description) {
    _controller?.dispose().then((value) {
      setState(() {});
      _controller = CameraController(description, ResolutionPreset.max);
      _controller!.setFlashMode(FlashMode.off);
      _controller!.initialize().then((_) {
        setState(() {});
      });
    });
  }

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeController(cameraController.description);
    }
  }

  @override
  void initState() {
    super.initState();
    isTimerStarted = false;
    selectedCamera = 0;

    changedSeconds = 10;
    percentage = 1.0;

    initializeController(widget.cameras[1]);

    // 카메라 화면 시작 시 안내문구 창
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5.0),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('가이드라인에 맞게 카메라를 이동해주세요'),
                          SizedBox(height: 8.0),
                          Text('촬영버튼을 누르면 타이머 시간 이후 촬영됩니다'),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_BLACK_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '확인',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    String strDigits(int n) => (n + 1 == 11) ? '10' : (n + 1).toString();
    String strSeconds = strDigits(changedSeconds);

    return DefaultLayout(
      appBarColor: Colors.black,
      appBarFontColor: Colors.white,
      title: '사진 저장하기',
      backgroundColor: PRIMARY_BLACK_COLOR,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.0,
            child: AspectRatio(
              aspectRatio: 3.0 / 4.0,
              child: OverflowBox(
                alignment: Alignment.center,
                child: Container(
                  width: width,
                  height: width / 1.333,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CameraPreview(_controller),
                      ),
                      // timer
                      if (isTimerStarted == true)
                        Positioned.fill(
                          child: SizedBox(
                            width: width,
                            height: height,
                            child: Center(
                              child: CircularPercentIndicator(
                                animateFromLastPercent: true,
                                reverse: true,
                                animation: true,
                                radius: 50.0,
                                lineWidth: 12.0,
                                animationDuration: 1000,
                                progressColor: Colors.white,
                                backgroundColor: Colors.transparent,
                                percent: percentage,
                                center: Text(
                                  strSeconds,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.8,
                          child: Image.asset(
                            'asset/img/user.png', // 사람 실루엣 사진
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      // get image from gallery
                      XFile? tempImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (tempImage == null) return;

                      File imageFile = File(tempImage!.path);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CameraResult(image: imageFile),
                        ),
                      );
                    },
                    iconSize: 40.0,
                    icon: const Icon(Icons.image),
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 75.0,
                    height: 75.0,
                    child: ElevatedButton(
                      // 카메라 촬영 버튼
                      onPressed: () async {
                        await startTimer();

                        Timer(const Duration(seconds: 11), () async {
                          final _picture = await _controller.takePicture();

                          if (_picture == null) {
                            return;
                          }
                          File _pictureFile = File(_picture.path);

                          if (selectedCamera == 1) {
                            final originalFile = _pictureFile;
                            Uint8List imageBytes =
                                await originalFile.readAsBytes();
                            final originalImage = img.decodeImage(imageBytes);

                            img.Image fixedImage;
                            fixedImage =
                                img.flipHorizontal(originalImage!); // 좌우 반전

                            File flipedImage = await originalFile.writeAsBytes(
                                img.encodePng(fixedImage)); // PNG 형태로 File 저장
                            _pictureFile = flipedImage;
                          }

                          setState(() {
                            isTimerStarted = false;
                            changedSeconds = 10;
                            percentage = 1.0;
                          });
                          //if (widget.userInfo != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CameraResult(image: _pictureFile),
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: const Size(28, 28),
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                      ),
                      child: Text(
                        isTimerStarted ? '' : '10',
                        style: const TextStyle(
                            color: PRIMARY_BLACK_COLOR, fontSize: 24.0),
                      ),
                    ),
                  ),
                  const IconButton(
                    iconSize: 40.0,
                    onPressed: /*() {
                      selectedCamera = selectedCamera == 0 ? 1 : 0;
                      updateController(widget.cameras[selectedCamera]);
                    }*/
                        null,
                    icon: Icon(
                      Icons.cameraswitch,
                      color: Colors.transparent,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
