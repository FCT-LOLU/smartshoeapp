import 'package:flutter/material.dart';
import 'package:namer_app/ProfilePage.dart';
import 'package:namer_app/ShoePage.dart';
import 'package:provider/provider.dart';

import 'MyHomePage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Smart Shoe Rack',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 120, 214, 178)),
        ),
        //home: MyHomePage(),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => MyHomePage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  //define the data the app needs to function
  var season = 'Spring';

  //a suprr
  var nbShoes = 5;

  var photoUrlShoe = "";
  var nameShoe = "";
  var brandShoe = "";
  var colorsShoe = [];
  var waterproofShoe = false;
  var seasonShoe = [];
  var actualShoe = "";

  var indexMyHomePage = 0;
  var indexProfilePage = 0;

  //define the functions that change the data
  void changeIndexMyHomePage(int index) {
    indexMyHomePage = index;
    notifyListeners();
  }

  void changeIndexProfilePage(int index) {
    indexProfilePage = index;
    notifyListeners();
  }

  void changeNbShoes(int index) {
    nbShoes = index;
    notifyListeners();
  }

  void changeActualShoe(String id) {
    actualShoe = id;
    notifyListeners();
  }

  void changeBrandShoe(String brand) {
    brandShoe = brand;
    notifyListeners();
  }

  void changeWaterproofShoe(bool waterproof) {
    waterproofShoe = waterproof;
    notifyListeners();
  }

  void changeNameShoe(String name) {
    nameShoe = name;
    notifyListeners();
  }

  void changeColorsShoe(List colors) {
    colorsShoe = colors;
    notifyListeners();
  }

  void changeSeasonShoe(List season) {
    seasonShoe = season;
    notifyListeners();
  }

  void changePhotoUrlShoe(String url) {
    photoUrlShoe = url;
    notifyListeners();
  }
}
