// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:give_structure/src/pages/client/map/client_map_page.dart';
import 'package:give_structure/src/pages/client/travel_calification/client_travel_calification_page.dart';
import 'package:give_structure/src/pages/client/travel_info/client_travel_info_page.dart';
import 'package:give_structure/src/pages/client/travel_map/client_travel_map_page.dart';
import 'package:give_structure/src/pages/client/travel_request/client_travel_request_page.dart';
import 'package:give_structure/src/pages/driver/map/driver_map_page.dart';
import 'package:give_structure/src/pages/driver/register/driver_register_page.dart';
import 'package:give_structure/src/pages/driver/travel_calification/driver_travel_calification_page.dart';
import 'package:give_structure/src/pages/driver/travel_map/driver_travel_map_page.dart';
import 'package:give_structure/src/pages/driver/travel_request/driver_travel_request_page.dart';
import 'package:give_structure/src/pages/home/home_page.dart';
import 'package:give_structure/src/pages/login/login_page.dart';
import 'package:give_structure/src/pages/client/register/client_register_page.dart';
import 'package:give_structure/src/providers/push_notifications_provider.dart';
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
  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
    pushNotificationsProvider.initPushNotifications();
    
    pushNotificationsProvider.message.listen((data) {
      print('------- Notificación Nueva -------');
      print(data);

      navigatorKey.currentState.pushNamed('driver/travel/request', arguments: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Give Structure",
      navigatorKey: navigatorKey,
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
        'client/travel/info': (BuildContext context) => ClientTravelInfoPage(),
        'client/travel/request': (BuildContext context) => ClientTravelRequestPage(),
        'driver/travel/request': (BuildContext context) => DriverTravelRequestPage(),
        'client/travel/map': (BuildContext context) => ClientTravelMapPage(),
        'driver/travel/map': (BuildContext context) => DriverTravelMapPage(),
        'client/travel/calification' : (BuildContext context) => ClientTravelCalificationPage(),
        'driver/travel/calification' : (BuildContext context) => DriverTravelCalificationPage(),
    },
    );
  }
}
