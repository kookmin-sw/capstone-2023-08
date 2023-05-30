import 'package:client/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  const String SPLASH_SCREEN = '/';

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: '착붙',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'pretendard',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SPLASH_SCREEN,
        routes: {
          SPLASH_SCREEN: (context) => SplashScreen(),
      },
      ),
    ),
  );
}
