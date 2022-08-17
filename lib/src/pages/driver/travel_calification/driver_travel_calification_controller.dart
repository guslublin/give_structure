import 'package:flutter/material.dart';
import 'dart:async';
import 'package:give_structure/src/models/client.dart';
import 'package:give_structure/src/providers/client_provider.dart';
import 'package:give_structure/src/providers/geofire_provider.dart';
import 'package:give_structure/src/utils/shared_pref.dart';
import 'package:give_structure/src/providers/travel_info_provider.dart';
import 'package:give_structure/src/providers/auth_provider.dart';

class DriverTravelCalificationController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  Function refresh;

  String idTravelHistory;

  Future init (BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;

    idTravelHistory = ModalRoute.of(context).settings.arguments as String;

    print('ID DEL TRAVBEL HISTORY: $idTravelHistory');

  }


}