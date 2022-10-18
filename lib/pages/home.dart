import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisba_sisfo2/config/constanta.dart' as cs;
import 'package:unisba_sisfo2/menus/main_menu.dart';
import 'package:unisba_sisfo2/models/sisfo_menu.dart';
import 'package:unisba_sisfo2/models/slider.dart';
import 'package:unisba_sisfo2/pages/seemore.dart';
import 'package:unisba_sisfo2/pages/webview.dart';

import '../models/active_user.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  ActiveUser mhs = ActiveUser();

  List<SisfoMenu> sisfoMenuList = [
    SisfoMenu(
        title: "SIBIMA",
        icon: cs.iconSibima,
        route: "https://sibima.unisba.ac.id"),
    SisfoMenu(
        title: "SIAKAD",
        icon: cs.iconSiakad,
        route: "https://siakad.unisba.ac.id"),
    SisfoMenu(
        title: "SIDPP",
        icon: cs.iconSidpp,
        route: "https://sidpp.unisba.ac.id"),
    SisfoMenu(
        title: "RPS & BAP",
        icon: cs.iconSibima,
        route: "https://rps.unisba.ac.id"),
    SisfoMenu(
        title: "Scholarship",
        icon: cs.iconScholarship,
        route: "https://www.unisba.ac.id"),
    SisfoMenu(
        title: "Pesantren",
        icon: cs.iconPesantren,
        route: "https://www.unisba.ac.id"),
    SisfoMenu(
        title: "TOEFL", icon: cs.iconToefl, route: "https://www.unisba.ac.id"),
    SisfoMenu(
        title: "Graduation",
        icon: cs.iconGraduation,
        route: "https://wisuda.unisba.ac.id"),
  ];

  List<SisfoSlider> sliderList = [];

  Future<void> getSliders() async {
    Dio dio = Dio();
    var response = await dio.get(cs.sliderUrl);
    if (response.statusCode == 200) {
      setState(() {
        for (var i in response.data) {
          sliderList.add(SisfoSlider(
            id: i['id'].toString(),
            title: i['title']['rendered'],
            image: i['jetpack_featured_media_url'],
            link: i['link'],
          ));
        }
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Unable to load News");
    }
  }

  Future<void> getActiveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? activeUser = prefs.getString(cs.spActiveUser);
    setState(() {
      mhs = ActiveUser.fromJson(jsonDecode(activeUser!));
      isLoading = false;
      Fluttertoast.showToast(msg: mhs.nama.toString());
    });
  }

  void openWebView(String title, String url) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: WebViewPage(
              title: title,
              url: url,
            )));
  }

  Future<void> logout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Sisfo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove(cs.spActiveUser);
                prefs.remove(cs.spIsLogin);
                prefs.remove(cs.spTokenKey);
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: LoginPage(),
                        type: PageTransitionType.bottomToTop));
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getActiveUser();
    getSliders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
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
          ),
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout()),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: deviceWidth,
                height: deviceHeight * 0.4,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(deviceWidth, 100))),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(mhs.foto.toString()),
                    ),
                    SizedBox(height: 10),
                    Text(mhs.npm.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      mhs.nama.toString(),
                      textAlign: TextAlign.center,
                      // maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight * 0.15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Latest News",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: SeeMorePage(),
                                  type: PageTransitionType.bottomToTop));
                        },
                        child: Text(
                          "See More",
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: deviceHeight * 0.15,
                  child: isLoading
                      ? SpinKitCubeGrid(
                          color: Colors.white,
                          size: 20,
                        )
                      : CarouselSlider(
                          options: CarouselOptions(
                            height: deviceHeight * 0.15,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.linear,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: sliderList.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Card(
                                  child: InkWell(
                                      onTap: () =>
                                          {openWebView(i.title, i.link)},
                                      child: Column(
                                        children: [
                                          Container(
                                            height: deviceHeight * 0.08,
                                            width: deviceWidth,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            child: Image.network(
                                              i.image,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(1),
                                            child: Text(
                                              i.title,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              },
                            );
                          }).toList(),
                        ))
            ],
          ),
          Positioned(
            top: deviceHeight * 0.27,
            left: 10,
            right: 10,
            child: Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: deviceWidth * 0.05,
                  children: [
                    for (var i in sisfoMenuList)
                      rowMenu(i.title, i.icon, i.route)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: MainMenu(),
    );
  }

  Widget rowMenu(String title, String icon, String route) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        GestureDetector(
            onTap: () => {
                  openWebView(title, route),
                },
            child: Image.asset(icon, width: deviceWidth * 0.17)),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: deviceWidth * 0.04)),
        SizedBox(height: 10),
      ],
    );
  }
}
