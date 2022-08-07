import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:give_structure/src/models/driver.dart';
import 'package:give_structure/src/models/travel_info.dart';
import 'package:give_structure/src/providers/auth_provider.dart';
import 'package:give_structure/src/providers/driver_provider.dart';
import 'package:give_structure/src/providers/geofire_provider.dart';
import 'package:give_structure/src/providers/push_notifications_provider.dart';
import 'package:give_structure/src/providers/travel_info_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:give_structure/src/utils/snackbar.dart' as utils;

class ClientTravelRequestController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;

  TravelInfoProvider _travelInfoProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  GeofireProvider _geofireProvider;
  PushNotificationsProvider _pushNotificationsProvider;

  List<String> nearbyDrivers = [];

  StreamSubscription<List<DocumentSnapshot>> _streamSubscription;
  StreamSubscription<DocumentSnapshot> _streamStatusSubscription;

  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;

    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _geofireProvider = new GeofireProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();

    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _createTravelInfo();
    _getNearbyDrivers();
  }

  void _checkDriverResponse(){
    Stream<DocumentSnapshot> stream = _travelInfoProvider.getByIdStream(_authProvider.getUser().uid);
    _streamStatusSubscription = stream.listen((DocumentSnapshot document) {
      TravelInfo travelInfo = TravelInfo.fromJson(document.data());
      if(travelInfo.idDriver != null && travelInfo.status == 'accepted'){
        //Navigator.pushNamedAndRemoveUntil(context, 'client/travel/map', (route) => false);
        Navigator.pushReplacementNamed(context, 'client/travel/map');
      } else if(travelInfo.status == 'no_accepted'){
        utils.Snackbar.showSnackbar(context, key, 'El conductor no aceptó la solicitud');
        Future.delayed(Duration(milliseconds: 4000), (){
          Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
        });
      }
    });
  }

  void dispose() {
    _streamSubscription?.cancel();
    _streamStatusSubscription?.cancel();
  }

  void _getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyDrivers(
        fromLatLng.latitude,
        fromLatLng.longitude,
        5);

    _streamSubscription = stream.listen((List<DocumentSnapshot> documentList) {
      for(DocumentSnapshot d in documentList){
        print('Conductor encontrado ${d.id}');
        nearbyDrivers.add(d.id);
      }
      getDriverInfo(nearbyDrivers[0]);
      _streamSubscription?.cancel();
    });
  }

  void _createTravelInfo() async {
    TravelInfo travelInfo = new TravelInfo(
      id: _authProvider.getUser().uid,
      from: from,
      to: to,
      fromLat: fromLatLng.latitude,
      fromLng: fromLatLng.longitude,
      toLat: toLatLng.latitude,
      toLng: toLatLng.longitude,
      status: 'created'
    );

    print("Dentro de Travel request controller: ${fromLatLng.latitude}, ${fromLatLng.longitude}, ${toLatLng.latitude}, ${toLatLng.longitude}");

    await _travelInfoProvider.create(travelInfo);
    _checkDriverResponse();
  }

  Future<void> getDriverInfo(idDriver) async{
    Driver driver = await _driverProvider.getById(idDriver);
    _sendNotification(driver.token);
  }

  void _sendNotification(String token){
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'idClient': _authProvider.getUser().uid,
      'origin': from,
      'destination': to
    };
    
    _pushNotificationsProvider.sendMessage(token, data, 'Solicitud de servicio', 'Un cliente solicita viaje');
  }
}