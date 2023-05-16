import 'package:camera/camera.dart';
import 'package:client/constant/colors.dart';
import 'package:client/screen/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../data/user_model.dart';

class OnBoardingPage extends StatefulWidget {
  final UserModel userInfo;
  OnBoardingPage({
    Key? key,
    required this.userInfo,
  }) : super(key: key);
  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const Text(
            '촬영하고 시작하기',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            List<CameraDescription> cameras = await availableCameras();

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CameraScreen(cameras: cameras)),
            );
          },
        ),
      ),
      pages: [
        PageViewModel(
          title: '무신사 옷 입어보기',
          body: '원하는 옷을 누른 후 피팅하기 버튼을 누릅니다. \n조금만 기다리면 피팅 결과를 확인할 수 있습니다.',
          image: Image.asset('asset/img/logo.png', fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: '갤러리 옷 입어보기',
          body: '자신의 휴대폰에 저장된 옷을 선택해주세요. \n이때, 배경이 없는 옷을 선택하면 더 나은 결과를 얻을 수 있습니다',
          image: Image.asset('asset/img/logo_white.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: '원하는 옷을 찜하기',
          body: '무신사 옷 중 마음에 드는 옷은 \n찜하기 버튼을 눌러 찜한 옷들을 확인할 수 있습니다',
          image: Center(child: Image.asset('asset/img/person_outline.png', fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,alignment: Alignment.center,)),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: '촬영하고 시작하세요!',
          body: '착붙에서 가상피팅 서비스를 이용하기 위해 \n먼저 가이드라인에 따라 본인의 모습을 촬영해주세요',
          image: Image.asset('asset/img/Animation4.gif', fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,alignment: Alignment.center,),
          decoration: getPageDecoration(),
        ),
      ],
      done: const Text('다음', style: TextStyle(color: PRIMARY_BLACK_COLOR),),
      onDone: () async {
        List<CameraDescription> cameras = await availableCameras();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CameraScreen(cameras: cameras)),
        );
      },
      showBackButton: true,
      showDoneButton: true,
      showNextButton: true,
      // showSkipButton: true,
      next: const Icon(Icons.keyboard_arrow_right, color: Color(0xFF474747),),
      back: const Icon(Icons.keyboard_arrow_left, color: Color(0xFF474747),),
      dotsDecorator: DotsDecorator(
          color: Colors.grey,
          activeColor: POINT_COLOR,
          activeSize: Size(22.0, 10.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  PageDecoration getPageDecoration() {
    return const PageDecoration(
      imageFlex: 5,
        bodyFlex: 2,
      titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(
        fontSize: 14.0,
        color: PRIMARY_BLACK_COLOR,
      ),
      imagePadding: EdgeInsets.zero,
      pageColor: Colors.white,
    );
  }
}
