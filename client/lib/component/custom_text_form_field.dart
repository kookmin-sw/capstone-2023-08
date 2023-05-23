import 'package:flutter/material.dart';

import '../constant/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final double width;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool isFocused;
  final TextEditingController controller;
  final ValueKey? myKey;
  final String? labelText;
  final ValueChanged<String>? onTextChanged; // text
  final FormFieldValidator? validator; // function
  final bool obscureText;

  const CustomTextFormField({
    Key? key,
    this.textInputAction,
    required this.width,
    this.focusNode,
    this.isFocused = false,
    required this.controller,
    this.myKey,
    this.labelText,
    this.onTextChanged,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isObscure;
  @override
  void initState() {
    super.initState();
    isObscure = widget.obscureText;
  }
  @override
  Widget build(BuildContext context) {
    Widget renderObscureButton() {
      return IconButton(
        onPressed: () {
          setState(() {
            isObscure = !isObscure;
          });
        },
        icon: isObscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off),// <-> Icons.visibility_off
        color: Colors.grey,
      );
    }

    return SizedBox(
      width: widget.width,
      child: TextFormField(
        scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.top + 45.0 * 2),
        key: widget.myKey,
        focusNode: widget.focusNode,
        controller: widget.controller,
        obscureText: isObscure,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: POINT_COLOR)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: POINT_COLOR)),
          errorStyle: TextStyle(color: POINT_COLOR),
          fillColor: INPUT_BG_COLOR,
          filled: true,
          labelText: widget.labelText,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          labelStyle: TextStyle(
            color: widget.isFocused ? Colors.black : Colors.grey,
            fontSize: 12.0,
          ),
          focusColor: Colors.black,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: PRIMARY_BLACK_COLOR,
              width: 1.3,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
          ),
          suffixIcon: widget.obscureText? renderObscureButton() : null,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: Colors.black,
        onChanged: widget.onTextChanged,
        validator: widget.validator,
      ),
    );
  }
}
