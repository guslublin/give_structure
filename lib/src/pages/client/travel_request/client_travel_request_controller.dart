import 'package:flutter/material.dart';

class ClientTravelRequestController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;
  }
}