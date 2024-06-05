// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'constants.dart' as k;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoaded = false;
  late num temp;
  late num press;
  late num hum;
  late num cover;
  String cityName = '';
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xffd9cf79),
                  Color(0xff5612d6),
                  Color(0xff7ef29d)
                ], begin: Alignment.bottomLeft, end: Alignment.topRight),
              ),
              child: Visibility(
                visible: isLoaded,
                replacement: const Center(child: CircularProgressIndicator()),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.09,
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: TextFormField(
                          onFieldSubmitted: (value) {
                            setState(() {
                              cityName = value;
                              getCityWether(value);
                              isLoaded = false;
                              textEditingController.clear();
                            });
                          },
                          controller: textEditingController,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Search City',
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w600),
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Icon(
                                  Icons.search_rounded,
                                  size: 25,
                                  color: Colors.white.withOpacity(.7),
                                ),
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.pin_drop,
                            color: Colors.red,
                            size: 40,
                          ),
                          Text(
                            cityName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.12,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade900,
                              offset: const Offset(1, 2),
                              blurRadius: 3,
                              spreadRadius: 1)
                        ],
                      ),
                      child: Row(
                        children: [
                          Image(
                            image: const AssetImage(
                                'assets/images/vecteezy_3d-weather-icon_27245503.png'),
                            width: MediaQuery.of(context).size.width * 0.09,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Temprature: ${temp.toStringAsFixed(2)} ℃',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.12,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade900,
                              offset: const Offset(1, 2),
                              blurRadius: 3,
                              spreadRadius: 1)
                        ],
                      ),
                      child: Row(
                        children: [
                          Image(
                            image:
                                const AssetImage('assets/images/barometer.png'),
                            width: MediaQuery.of(context).size.width * 0.09,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Pressure: ${press.toStringAsFixed(2)} hPa',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.12,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade900,
                              offset: const Offset(1, 2),
                              blurRadius: 3,
                              spreadRadius: 1)
                        ],
                      ),
                      child: Row(
                        children: [
                          Image(
                            image:
                                const AssetImage('assets/images/humidity.png'),
                            width: MediaQuery.of(context).size.width * 0.09,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Humadity: ${hum.toInt()} %',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.12,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade900,
                              offset: const Offset(1, 2),
                              blurRadius: 3,
                              spreadRadius: 1)
                        ],
                      ),
                      child: Row(
                        children: [
                          Image(
                            image: const AssetImage(
                                'assets/images/vecteezy_cloudy-illustration-design_34962377.png'),
                            width: MediaQuery.of(context).size.width * 0.09,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Cloud cover: ${cover.toInt()} %',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  getCurrentLocation() async {
    var p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true);

    if (p != null) {
      print('lat: ${p.latitude}, long:${p.longitude}');
      getCurrentCityWeather(p);
    } else {
      print('Data unavailable');
    }
  }

  getCityWether(String cityname) async {
    var client = http.Client();
    var uri = '${k.domain}q=$cityname&appid=${k.apikey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      print(data);
      UpdateUI(decodedData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print('Data not comeing');
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apikey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      print(data);
      UpdateUI(decodedData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print('Data not comeing');
    }
  }

  UpdateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        temp = 0;
        press = 0;
        hum = 0;
        cover = 0;
        cityName = 'Not Available';
      } else {
        temp = decodedData['main']['temp'] - 273;
        press = decodedData['main']['pressure'];
        hum = decodedData['main']['humidity'];
        cover = decodedData['clouds']['all'];
        cityName = decodedData['name'];
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
