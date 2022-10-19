import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/active_user.dart';
import 'package:unisba_sisfo2/config/constanta.dart' as cs;

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  ActiveUser mhs = ActiveUser();
  bool isLoading = true;

  TextEditingController npmController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController telpController = TextEditingController();

  var religionList = [
    'Islam',
    'Protestan',
    'Katholik',
    'Hindu',
    'Budha',
  ];

  var genderList = [
    {'id': 'L', 'text': "Laki - Laki"},
    {'id': 'P', 'text': "Wanita"},
  ];

  var faskesList = [
    {'id': 1, 'faskes': "Unisba"},
    {'id': 2, 'faskes': "Luar Unisba"},
  ];

  String religionSelected = "";
  String genderSelected = "";
  String faskesSelected = "";

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(cs.spTokenKey);
    var telp = telpController.text;
    var alamat = alamatController.text;
    var jk = genderSelected;
    var agama = religionSelected;
    var faskes = faskesSelected;
    Dio dio = Dio();
    try {
      var updateData = FormData.fromMap({
        'telepon': telp,
        'alamat': alamat,
        'jenis_kelamin': jk,
        'agama': agama,
        'kategori_faskes': faskes,
      });

      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.post(cs.updateProfileUrl, data: updateData);
      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          Map<String, dynamic> map =
              response.data['user'] as Map<String, dynamic>;
          ActiveUser au = ActiveUser.fromJson(map);
          await prefs.setString(cs.spActiveUser, jsonEncode(au));
        } else {
          var message = response.data['message'];
          Fluttertoast.showToast(msg: message);
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
  void initState() {
    getActiveUser();
    super.initState();
  }

  Future<void> getActiveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? activeUser = prefs.getString(cs.spActiveUser);
    setState(() {
      mhs = ActiveUser.fromJson(jsonDecode(activeUser!));
      isLoading = false;
      npmController.text = mhs.npm.toString();
      alamatController.text = mhs.alamat.toString();
      telpController.text = mhs.telepon.toString();
      religionSelected = mhs.agama.toString();
      faskesSelected = mhs.kategoriFaskesId.toString();
      genderSelected = mhs.jenisKelamin.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Update Profile"),
        ),
        body: isLoading
            ? Center(
                child: SpinKitChasingDots(
                  color: Colors.blue,
                ),
              )
            : SingleChildScrollView(
                child: Column(children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "NPM",
                            hintText: "NPM"),
                        controller: npmController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Telp",
                            hintText: "Telp"),
                        controller: telpController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Alamat",
                            hintText: "Alamat"),
                        controller: alamatController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        // value: religionSelected,
                        hint: Text(religionSelected),
                        items: religionList.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            religionSelected = value.toString();
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        // value: religionSelected,
                        hint: Text(faskesSelected),
                        items: faskesList.map((value) {
                          return DropdownMenuItem(
                            child: Text(value['faskes'].toString()),
                            value: value['id'].toString(),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            faskesSelected = value.toString();
                            Fluttertoast.showToast(msg: faskesSelected);
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        hint: Text(genderSelected), // 1
                        items: genderList.map((value) {
                          return DropdownMenuItem(
                            child: Text(value['text'].toString()),
                            value: value['id'].toString(),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            genderSelected = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: MaterialButton(
                      disabledColor: Colors.grey,
                      height: 50.0,
                      minWidth: deviceWidth,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () => {updateProfile()},
                      splashColor: Colors.white,
                    )),
              ])));
  }
}
