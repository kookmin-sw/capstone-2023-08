import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  final String text;
  final BuildContext context;

  CustomSnackBar({
    required this.text,
    required this.context,
  });

  void renderSnackBar() {
    final width = MediaQuery.of(context).size.width;
    AnimatedSnackBar(
      duration: const Duration(seconds: 2),
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      builder: ((context) {
        return Container(
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xDD000000),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
              const SizedBox(
                width: 16.0,
              ),
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      }),
    ).show(context);
  }
}
