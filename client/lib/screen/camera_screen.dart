import 'dart:async';

import 'package:client/constant/colors.dart';
import 'package:client/data/account.dart';
import 'package:client/layout/default_layout.dart';
import 'package:client/screen/camera_result.dart';
import 'package:client/screen/signup_success.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:client/component/default_dialog.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  Account userInfo;
  CameraDescription camera;

  CameraScreen({
    Key? key,
    required this.userInfo,
    required this.camera,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // camera
  late CameraController _controller;
  late XFile picture;

  // timer
  late bool isTimerStarted;
  Timer? countdownTimer;

  late int changedSeconds;
  late double percentage = 1.0;

  @override
  void initState() {
    super.initState();
    changedSeconds = 10;
    percentage = 1.0;
    isTimerStarted = false;

    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.transparent,
            child: Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('가이드라인에 맞게 카메라를 이동해주세요'),
                            SizedBox(height: 8.0),
                            Text('촬영버튼을 누르면 타이머 시간 이후 촬영됩니다'),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('확인'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    String strDigits(int n) => (n+1 == 11) ?  '10': (n + 1).toString();
    String strSeconds = strDigits(changedSeconds);

    return DefaultLayout(
      child: Stack(
        children: [
          Positioned.fill(
            child: SizedBox(
              width: width,
              height: height,
              child: CameraPreview(_controller),
            ),
          ),
          // timer
          if (isTimerStarted == true)
            Positioned.fill(
              child: Container(
                width: width,
                height: height,
                child: Center(
                  child: CircularPercentIndicator(
                    animateFromLastPercent: true,
                    reverse: true,
                    animation: true,
                    radius: 60.0,
                    lineWidth: 20.0,
                    animationDuration: 1000,
                    progressColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    percent: percentage,
                    center: Text(
                      strSeconds,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'asset/img/user.png', // 사람 실루엣 사진
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: height * 0.2,
              color: Color(0x55000000),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      // 카메라 촬영 버튼
                      onPressed: () async {
                        try {
                          await startTimer();

                          Timer(Duration(seconds: 11), () async {
                            final _picture = await _controller.takePicture();
                            if (_picture == null) {
                              return;
                            }

                            setState(() {
                              isTimerStarted = false;
                              changedSeconds = 10;
                              percentage = 1.0;
                            });
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CameraResult(
                                    userInfo: widget.userInfo, image: _picture),
                              ),
                            );
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color(0xFFFFFFFF),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
