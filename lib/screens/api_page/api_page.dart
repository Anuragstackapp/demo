import 'dart:convert';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo/common/method/methods.dart';
import 'package:demo/model/audio_model/audio_model.dart';
import 'package:demo/model/audiobook_model/audio_book_model.dart';
import 'package:demo/model/banner_model/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiPage extends StatefulWidget {
  const ApiPage({Key? key}) : super(key: key);

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  List l = [];
  List a = [];
  bool status = false;
  bool audioStatus = false;
  bool audioS = false;
  int pageIndex = 0;
  late Audio audio;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    CategoriesData();
    AudioData();
  }

  loadData() async {
    var url = Uri.parse('https://audio-kumbh.herokuapp.com/api/v1/banner');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');

      l = jsonDecode(response.body);

      logs("Banner Data-->${l}");
    }

    setState(() {
      status = true;
    });
  }

  CategoriesData() async {
    var url = Uri.parse(
        'https://audio-kumbh.herokuapp.com/api/v2/category/audiobook');
    var response = await http.get(url, headers: {
      "x-guest-token":
          "U2FsdGVkX1+WVxNvXEwxTQsjLZAqcCKK9qqQQ5sUlx8aPkMZ/FyEyAleosfe07phhf0gFMgxsUh2uDnDSkhDaAfn1aw6jYHBwdZ43zdLiTcZedlS9zvVfxYG67fwnb4U454oAiMV0ImECW1DZg/w3aYZGXZIiQ+fiO4XNa1y1lc0rHvjKnPkgrYkgbTdOgAfnxnxaNHiniWClKWmVne/0vO0s6Vh7HpC0lRjs0LKTwM="
    });
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      a = jsonDecode(response.body);

      logs("AudioBook -->${response.body}");
    }
    setState(() {
      audioStatus = true;
    });
  }

  AudioData() async {
    var url =
        Uri.parse('https://audio-kumbh.herokuapp.com/api/v2/homepage/category');
    var response = await http.post(url, headers: {
      "x-guest-token":
          "U2FsdGVkX1+WVxNvXEwxTQsjLZAqcCKK9qqQQ5sUlx8aPkMZ/FyEyAleosfe07phhf0gFMgxsUh2uDnDSkhDaAfn1aw6jYHBwdZ43zdLiTcZedlS9zvVfxYG67fwnb4U454oAiMV0ImECW1DZg/w3aYZGXZIiQ+fiO4XNa1y1lc0rHvjKnPkgrYkgbTdOgAfnxnxaNHiniWClKWmVne/0vO0s6Vh7HpC0lRjs0LKTwM="
    }, body: {
      "sectionfor": "audiobook"
    });
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      audio = audioFromJson(response.body);
      logs("Audio -->${response.body}");
    }

    setState(() {
      audioS = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness:
        Brightness.dark,
      ),
    );
    CarouselController carouselController = CarouselController();
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            //banner
            status
                ? (l.length > 0
                    ? CarouselSlider.builder(
                        itemCount: l.length,
                        carouselController: carouselController,
                        itemBuilder: (context, index, realIndex) {
                          Map map = l[index];
                          Banners banners = Banners.fromJson(map);

                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage("${banners.photoUrl}"),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                pageIndex = index;
                              });
                            }),
                      )
                    : Center(
                        child: Text("No Data Found"),
                      ))
                : Center(
                    child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(),
                  )),

            SizedBox(
              height: 20,
            ),
            status
                ? (l.length > 0
                    ? CarouselIndicator(
                        count: l.length,
                        index: pageIndex,
                        color: Colors.black,
                        activeColor: Colors.yellow,
                      )
                    : Center(
                        child: Text(""),
                      ))
                : Center(child: Text("Wait..")),
            SizedBox(
              height: 25,
            ),

            //catigory
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Categories",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )),

            audioStatus
                ? (a.length > 0
                    ? Container(
                        height: 150,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: a.length,
                          itemBuilder: (context, index) {
                            AudioBooks audiobooks =
                                AudioBooks.fromJson(a[index]);

                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, bottom: 10),
                                  child: Container(
                                    height: 150,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${audiobooks.photoUrl}")),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 35, top: 35),
                                  child: Text("${audiobooks.name}",
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white)),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text("No Data Found"),
                      ))
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            //AudioBooks
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("AudioBooks",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )),

            audioS
                ? (audio.data!.homeCategoryList!.first.idList!.length > 0
                    ? Container(
                        height: 280,
                        width: double.infinity,
                        child: ListView.separated(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, bottom: 10, right: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: audio
                              .data!.homeCategoryList!.first.idList!.length,
                          itemBuilder: (context, index) {
                            // AudioBooks audiobooks = AudioBooks.fromJson(a[index]);

                            return Column(
                              children: [
                                Container(
                                  height: 200,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${audio.data!.homeCategoryList!.first.idList![index].audioBookDpUrl}"),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                SizedBox(
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "${audio.data!.homeCategoryList!.first.idList![index].name}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),maxLines: 1,),
                                    )),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 10,
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text("No Data Found"),
                      ))
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      )),
    );
  }
}
