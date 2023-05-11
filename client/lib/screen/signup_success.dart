import 'dart:async';

import 'package:client/constant/colors.dart';
import 'package:client/layout/default_layout.dart';
import 'package:confetti/confetti.dart';

import '../constant/page_name.dart';
import 'package:flutter/material.dart';

class SignupSuccess extends StatefulWidget {
  const SignupSuccess({Key? key}) : super(key: key);

  @override
  State<SignupSuccess> createState() => _SignupSuccessState();
}

class _SignupSuccessState extends State<SignupSuccess> {
  final controller = ConfettiController();
  final BlastDirectionality direction = BlastDirectionality.directional;

  @override
  void initState() {
    controller.play();

    Timer(const Duration(milliseconds: 4000), () {
      Navigator.of(context).pushNamed(HOME_SCREEN);
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_BLACK_COLOR,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                numberOfParticles: 10,
                confettiController: controller,
                shouldLoop: false,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  Color(0xFFFFC671),
                  Color(0xFFFFAA29),
                  Color(0xFF94ABFF),
                  Color(0xFFC8FF53),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '착붙의 회원이 되신 것을 환영합니다',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '언제, 어디서든',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '가상피팅으로 옷의 느낌을 확인해보세요.',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
