import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:give_structure/src/pages/client/travel_map/client_travel_map_controller.dart';

class ClientTravelMapPage extends StatefulWidget {
  const ClientTravelMapPage({Key key}) : super(key: key);

  @override
  State<ClientTravelMapPage> createState() => _ClientTravelMapPageState();
}

class _ClientTravelMapPageState extends State<ClientTravelMapPage> {
  ClientTravelMapController _con = new ClientTravelMapController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Pantalla del mapa del cliente'
        ),
      ),
    );
  }

  void refresh(){
    setState(() {});
  }
}
