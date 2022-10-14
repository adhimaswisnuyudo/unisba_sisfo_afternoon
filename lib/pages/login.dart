import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisba_sisfo2/config/constanta.dart' as cs;
import 'package:unisba_sisfo2/pages/home.dart';

import '../models/active_user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscurePassword = true;
  bool isButtonEnable = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  static Dio dio = Dio();
  bool isLoading = false;

  void setObscurePassword() {
    setState(() {
      isObscurePassword = !isObscurePassword;
    });
  }

  void checkIsButtonEnable() {
    var username = usernameController.text;
    var password = passwordController.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      setState(() {
        isButtonEnable = true;
      });
    } else {
      setState(() {
        isButtonEnable = false;
      });
    }
  }

  Future<void> loginAction() async {
    var username = usernameController.text;
    var password = passwordController.text;
    var loginData = FormData.fromMap({
      'npm': username,
      'password': password,
    });
    try {
      setState(() {
        isLoading = true;
      });
      var response = await dio.post(cs.loginUrl, data: loginData);
      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          String token = response.data['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(cs.spTokenKey, token);
          Map<String, dynamic> map =
              response.data['user'] as Map<String, dynamic>;
          ActiveUser au = ActiveUser.fromJson(map);
          prefs.setString(cs.spActiveUser, jsonEncode(au));
          prefs.setBool(cs.spIsLogin, true);
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: HomePage(), type: PageTransitionType.bottomToTop));
        } else {
          Fluttertoast.showToast(msg: response.data['message'].toString());
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: isLoading
            ? const Center(
                child: SpinKitCubeGrid(
                color: Colors.blue,
              ))
            : ListView(
                children: [
                  Container(
                    height: deviceHeight * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(deviceWidth - 80, 100),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 3,
                          )
                        ]),
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        Image.asset(
                          cs.mainLogo,
                          height: deviceHeight * 0.25,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Mobile",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "SISFO",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 40,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "UNIVERSITAS ISLAM BANDUNG",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.1),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  Card(
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                                onChanged: (value) {
                                  checkIsButtonEnable();
                                },
                                controller: usernameController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11)
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Student ID",
                                  prefixIcon: Icon(Icons.person),
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.start,
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.grey),
                                )),
                            TextField(
                              onChanged: (value) {
                                checkIsButtonEnable();
                              },
                              controller: passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                    onPressed: () => setObscurePassword(),
                                    icon: isObscurePassword
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility)),
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                floatingLabelStyle:
                                    TextStyle(color: Colors.grey),
                              ),
                              obscureText: isObscurePassword,
                            ),
                          ],
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: null,
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ))
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: MaterialButton(
                        disabledColor: Colors.grey,
                        height: 50.0,
                        minWidth: deviceWidth,
                        color: isButtonEnable ? Colors.blue : Colors.grey,
                        textColor: Colors.white,
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () => {
                          isButtonEnable ? loginAction() : null,
                        },
                        splashColor: Colors.white,
                      )),
                ],
              ));
  }
}
