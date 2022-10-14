import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisba_sisfo2/config/constanta.dart' as cs;
import 'package:unisba_sisfo2/menus/main_menu.dart';

import '../models/active_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  ActiveUser mhs = ActiveUser();

  Future<void> getActiveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? activeUser = prefs.getString(cs.spActiveUser);
    setState(() {
      mhs = ActiveUser.fromJson(jsonDecode(activeUser!));
      isLoading = false;
      Fluttertoast.showToast(msg: mhs.nama.toString());
    });
  }

  @override
  void initState() {
    getActiveUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          cs.mainLogo,
          height: 50,
        ),
        title: const Text(
          cs.organizationName,
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          Align(
            child: Badge(
              position: BadgePosition.topEnd(top: 1, end: 2),
              badgeContent: const Text(
                '0',
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                  icon: const Icon(Icons.notifications), onPressed: () {}),
            ),
          )
        ],
      ),
      body: ListView(
        children: [],
      ),
      bottomNavigationBar: MainMenu(),
    );
  }
}
