import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unisba_sisfo2/config/constanta.dart' as cs;
import 'package:unisba_sisfo2/pages/splashscreen.dart';

void main() {
  // memastikan posisi device hanya potrait up saja
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: cs.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreenPage());
  }
}
