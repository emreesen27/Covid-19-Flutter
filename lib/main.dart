import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_corona_app/text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Corona App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = new TextEditingController();
  SharedPreferences _shared;
  List<String> countryList = new List();
  String countryName,
      countryFlag,
      totalConfirmed,
      totalDeaths,
      totalRecovered,
      newConfirmed,
      newDeaths,
      newRecovered,
      updateDate;

  Future _getJsonData() async {
    var _response = await http.get("https://api.covid19api.com/summary");
    return jsonDecode(_response.body);
  }

  @override
  void initState() {
    super.initState();
    _initShared();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe7e7e7),
      appBar: AppBar(
        centerTitle: true,
        elevation: 8.0,
        backgroundColor: Colors.white70,
        title: Text(
          'Corona App',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: FutureBuilder(
        future: _getJsonData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final int countrySize = (snapshot.data['Countries'] as List).length;

            for (int i = 0; i < countrySize; i++) {
              countryList.add(snapshot.data['Countries'][i]['Country']);
            }

            for (int i = 0; i < countrySize; i++) {
              if (snapshot.data['Countries'][i]['Country'].toString() ==
                  countryName) {
                totalConfirmed =
                    snapshot.data['Countries'][i]['TotalConfirmed'].toString();
                totalDeaths =
                    snapshot.data['Countries'][i]['TotalDeaths'].toString();
                totalRecovered =
                    snapshot.data['Countries'][i]['TotalRecovered'].toString();
                newConfirmed =
                    snapshot.data['Countries'][i]['NewConfirmed'].toString();
                newDeaths =
                    snapshot.data['Countries'][i]['NewDeaths'].toString();
                newRecovered =
                    snapshot.data['Countries'][i]['NewRecovered'].toString();

                countryFlag =
                    snapshot.data['Countries'][i]['CountryCode'].toString();

                updateDate = snapshot.data['Countries'][i]['Date']
                    .toString()
                    .substring(0, 10);
              }
            }

            return Container(
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      color: Colors.white70,
                      elevation: 5.0,
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  "https://www.countryflags.io/$countryFlag/shiny/64.png",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            Text(
                              '$countryName'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      color: Colors.white70,
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textField(
                            desc: 'Total Confirmed :',
                            value: '$totalConfirmed',
                            color: Color(0xff3498db),
                          ),
                          textField(
                              desc: 'Total Deaths :',
                              value: '$totalDeaths',
                              color: Color(0xffd72323)),
                          textField(
                              desc: 'Total Recovered :',
                              value: '$totalRecovered',
                              color: Color(0xff30e3ca)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Card(
                      color: Colors.white70,
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textField(
                            desc: 'New Confirmed :',
                            value: '$newConfirmed',
                            color: Color(0xff3498db),
                          ),
                          textField(
                            desc: 'New Deaths :',
                            value: '$newDeaths',
                            color: Color(0xffd72323),
                          ),
                          textField(
                            desc: 'New Recovered :',
                            value: '$newRecovered',
                            color: Color(0xff30e3ca),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      height: 5.0,
                      color: Colors.black87,
                      indent: 15.0,
                      endIndent: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 3.0,
                        bottom: 3.0,
                      ),
                      child: Text(
                        'Last Update : $updateDate',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          child: Icon(Icons.search),
        ),
        onPressed: () {
          showMaterialScrollPicker(
              context: context,
              backgroundColor: Color(0xffe7e7e7),
              cancelText: "Cancel",
              confirmText: "Ok",
              title: "Pick Your Country",
              items: countryList,
              selectedItem: countryName,
              onChanged: (value) {
                setState(() {
                  countryName = value;
                  _setCountry(countryName);
                });
              });
        },
      ),
    );
  }

  _initShared() async {
    _shared = await SharedPreferences.getInstance();
    if (_shared.getString('countryName') == null)
      setState(() => countryName = 'Afghanistan');
    else
      setState(() => countryName = _shared.getString('countryName'));
  }

  _setCountry(String countryName) async {
    await _shared.setString('countryName', countryName);
  }
}
