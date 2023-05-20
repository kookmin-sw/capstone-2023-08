import 'package:client/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

class DefaultLoadingScreen extends StatefulWidget {
  final Color? backgroundColor;

  const DefaultLoadingScreen({
    Key? key,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<DefaultLoadingScreen> createState() => _DefaultLoadingScreenState();
}

class _DefaultLoadingScreenState extends State<DefaultLoadingScreen>
    with SingleTickerProviderStateMixin {
  late FlutterGifController controller;

  @override
  void initState() {
    super.initState();

    controller = FlutterGifController(vsync: this);
    controller.repeat(
        min: 0, max: 69, period: const Duration(milliseconds: 1500));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading_name = widget.backgroundColor == Colors.black
        ? 'loading_color'
        : 'loading_white';
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        height: 200,
        child: GifImage(
          width: width * 0.4,
          controller: controller,
          image: AssetImage('asset/img/${loading_name}.gif'),
        ),
      ),
    );
  }
}
