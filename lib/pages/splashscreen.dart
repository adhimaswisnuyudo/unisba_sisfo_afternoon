import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisba_sisfo2/config/constanta.dart' as cs;
import 'package:unisba_sisfo2/pages/login.dart';

import 'home.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    checkIsLogin();
    super.initState();
  }

  Future<void> checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool(cs.spIsLogin) ?? false;
    if (isLogin == true) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: const HomePage(), type: PageTransitionType.bottomToTop));
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginPage(), type: PageTransitionType.bottomToTop));
      });
    }
  }

  void redirectPage() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: LoginPage(), type: PageTransitionType.bottomToTop));
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 0.25 * deviceHeight),
              Image.asset(cs.mainLogo,
                  width: 0.8 * deviceWidth, height: 0.8 * deviceWidth),
              const SizedBox(height: 15),
              const Text(cs.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  )),
              const SizedBox(height: 50),
              const SpinKitCubeGrid(
                color: Colors.white,
                size: 25.0,
              ),
            ],
          ),
        ));
  }
}
