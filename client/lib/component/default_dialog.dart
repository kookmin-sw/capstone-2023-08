import 'package:async_button_builder/async_button_builder.dart';
import 'package:client/component/loading_screen.dart';
import 'package:client/constant/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AlertButton extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final String label;
  final VoidCallback? onPressed;
  final AsyncCallback? onAsyncPressed;
  final Color borderColor;

  AlertButton({
    Key? key,
    required this.backgroundColor,
    required this.color,
    required this.label,
    this.onPressed,
    this.onAsyncPressed,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50.0,
        child: OutlinedButton(
          onPressed: onPressed?? onAsyncPressed,
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

class BasicAlertDialog extends StatefulWidget {
  final VoidCallback onLeftButtonPressed;
  final AsyncCallback? onRightButtonPressed;
  final String title;
  final String? bodyText;
  final String leftButtonText;
  final String rightButtonText;

  BasicAlertDialog({
    Key? key,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    required this.title,
    this.bodyText,
    required this.leftButtonText,
    required this.rightButtonText,
  }) : super(key: key);

  @override
  State<BasicAlertDialog> createState() => _BasicAlertDialogState();
}

class _BasicAlertDialogState extends State<BasicAlertDialog> {
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
            height: widget.bodyText == null ? height * 0.18 : height * 0.2,
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
                          label: widget.leftButtonText,
                          onPressed: this.widget.onLeftButtonPressed,
                          borderColor: BUTTON_BORDER_COLOR,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        AsyncButtonBuilder(
                          child: Text(
                            widget.rightButtonText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          loadingWidget: DefaultLoadingScreen(backgroundColor: Colors.black,),
                          onPressed: widget.onRightButtonPressed,
                          builder: (context, child, callback, _) {
                            return Expanded(
                              child: SizedBox(
                                height: 50.0,
                                child: OutlinedButton(
                                  onPressed: callback,
                                  child: child,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    backgroundColor: PRIMARY_BLACK_COLOR,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
    if (widget.bodyText == null) {
      return Center(
        child: Text(
          widget.title,
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
          widget.bodyText!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PRIMARY_BLACK_COLOR,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
          ),
        ],
      );
    }
  }
}
