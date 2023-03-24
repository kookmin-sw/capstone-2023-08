import 'dart:io';

import 'package:client/screen/signup_success.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraResult extends StatelessWidget {
  final CameraDescription camera;
  
  final String imagePath;

  const CameraResult({
    required this.camera,
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Stack(
      children: [
        Image.file(File(imagePath)),
        Positioned(
          bottom: 0,
          child: Container(
            width: width,
            height: height * 0.22,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        children: const [
                          Text(
                            '이 사진으로 저장할까요?',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.autorenew,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () {
                          // 저장 요청하는 코드 필요
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupSuccess(),
                            ),
                          );
                        },
                        child: const Text(
                          '저장',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
