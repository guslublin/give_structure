import 'package:flutter/material.dart';
import 'package:give_structure/src/utils/shared_pref.dart';

class DriverTravelRequestController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  Function refresh;
  SharedPref _sharedPref;

  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    _sharedPref.save('isNotification', 'false');
  }


}