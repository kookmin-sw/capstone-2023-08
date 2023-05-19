import 'package:client/constant/colors.dart';
import 'package:flutter/material.dart';

class AlertButton extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final String label;
  final VoidCallback onPressed;
  final Color borderColor;

  const AlertButton({
    Key? key,
    required this.backgroundColor,
    required this.color,
    required this.label,
    required this.onPressed,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50.0,
        child: OutlinedButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: borderColor,
            ),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }
}

class BasicAlertDialog extends StatelessWidget {
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;
  final String title;
  final String? bodyText;
  final String leftButtonText;
  final String rightButtonText;

  const BasicAlertDialog({
    Key? key,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    required this.title,
    this.bodyText,
    required this.leftButtonText,
    required this.rightButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
            height: bodyText == null ? height * 0.18 : height * 0.2,
            width: width,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: renderText(),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AlertButton(
                          backgroundColor: Colors.white70,
                          color: PRIMARY_BLACK_COLOR,
                          label: leftButtonText,
                          onPressed: this.onLeftButtonPressed,
                          borderColor: BUTTON_BORDER_COLOR,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        AlertButton(
                          backgroundColor: PRIMARY_BLACK_COLOR,
                          color: Colors.white,
                          label: rightButtonText,
                          onPressed: this.onRightButtonPressed,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget renderText() {
    if (bodyText == null) {
      return Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
          bodyText!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PRIMARY_BLACK_COLOR,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
          ),
        ],
      );
    }
  }
}
