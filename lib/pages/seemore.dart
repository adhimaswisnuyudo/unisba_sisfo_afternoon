import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unisba_sisfo2/config/constanta.dart' as cs;

import '../models/slider.dart';

class SeeMorePage extends StatefulWidget {
  const SeeMorePage({Key? key}) : super(key: key);

  @override
  _SeeMorePageState createState() => _SeeMorePageState();
}

class _SeeMorePageState extends State<SeeMorePage> {
  List<SisfoSlider> sliderList = [];
  bool isLoading = true;
  RefreshController refreshController = RefreshController();

  Future<void> getSliders() async {
    Dio dio = Dio();
    var response = await dio.get(cs.postMoreUrl);
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

  void refreshData() async {
    getSliders();
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    getSliders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('See More'),
        ),
        body: isLoading
            ? Center(
                child: SpinKitCubeGrid(
                  color: Colors.blue,
                ),
              )
            : SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                controller: refreshController,
                onRefresh: refreshData,
                onLoading: refreshData,
                child: ListView.builder(
                  itemCount: sliderList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(sliderList[index].title),
                        leading: Image.network(
                          sliderList[index].image,
                          height: 100,
                          width: 100,
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ));
  }
}
