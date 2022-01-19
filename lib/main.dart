// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:give_structure/src/pages/client/map/client_map_page.dart';
import 'package:give_structure/src/pages/driver/map/driver_map_page.dart';
import 'package:give_structure/src/pages/driver/register/driver_register_page.dart';
import 'package:give_structure/src/pages/home/home_page.dart';
import 'package:give_structure/src/pages/login/login_page.dart';
import 'package:give_structure/src/pages/client/register/client_register_page.dart';
import 'package:give_structure/src/utils/colors.dart' as utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GiveStructure());
}

class GiveStructure extends StatefulWidget {
  const GiveStructure({Key key}) : super(key: key);

  @override
  _GiveStructureState createState() => _GiveStructureState();
}

class _GiveStructureState extends State<GiveStructure> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Give Structure",
      theme: ThemeData(
          fontFamily: 'NimbusSans',
          appBarTheme: AppBarTheme(
              elevation: 0
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: utils.Colors.giveStructureColor,
          )
      ),
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'client/register': (BuildContext context) => ClientRegisterPage(),
        'driver/register': (BuildContext context) => DriverRegisterPage(),
        'client/map': (BuildContext context) => CLientMapPage(),
        'driver/map': (BuildContext context) => DriverMapPage(),
      },
    );
  }
}
