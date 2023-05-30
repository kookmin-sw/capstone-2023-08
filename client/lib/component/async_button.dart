import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'loading_screen.dart';

class AsyncButton extends StatefulWidget {
  final AsyncCallback? onPressed;
  final String text;
  final double height;
  final double? fontSize;
  final FontWeight? fontWeight;
  const AsyncButton({
    this.onPressed,
    required this.text,
    required this.height,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w400,
    Key? key}) : super(key: key);

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
      loadingWidget: const DefaultLoadingScreen(backgroundColor: Colors.black,),
      onPressed: widget.onPressed,
      builder: (context, child, callback, _) {
        return Expanded(
          child: SizedBox(
            height: widget.height,
            child: OutlinedButton(
              onPressed: callback,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.transparent,
                ),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: child,
            ),
          ),
        );
      },
      child: Text(
        widget.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
      ),
    );
  }
}
