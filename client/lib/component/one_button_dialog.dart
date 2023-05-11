import 'package:flutter/material.dart';

import '../constant/colors.dart';

class OneButtonDialog extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const OneButtonDialog({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
            height: height * 0.15,
            width:  width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title),
                SizedBox(height: 24.0,),
                SizedBox(
                  width: width * 0.8,
                  height: 45.0,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    child: Text(
                      '확인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: PRIMARY_BLACK_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
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
}
