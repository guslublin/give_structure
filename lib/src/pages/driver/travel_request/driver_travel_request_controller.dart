import 'package:flutter/material.dart';
import 'package:give_structure/src/models/client.dart';
import 'package:give_structure/src/providers/client_provider.dart';
import 'package:give_structure/src/utils/shared_pref.dart';

class DriverTravelRequestController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  Function refresh;
  SharedPref _sharedPref;

  String from;
  String to;
  String idClient;

  ClientProvider _clientProvider;
  Client client;

  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    _sharedPref.save('isNotification', 'false');

    _clientProvider = new ClientProvider();
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    from = arguments['data']['origin'];
    to = arguments['data']['destination'];
    idClient = arguments['data']['idClient'];

    // Con la nueva versión de push notifications es sin 'data':
    // from = arguments['origin'];
    // to = arguments['destination'];
    // idClient = arguments['idClient'];

    getClientInfo();

  }

  void getClientInfo() async {
    client = await _clientProvider.getById(idClient);
    print('Client ${client.toJson()}');
    refresh();
  }

}