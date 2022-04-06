import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:give_structure/src/pages/driver/travel_map/driver_travel_map_controller.dart';

class DriverTravelMapPage extends StatefulWidget {
  const DriverTravelMapPage({Key key}) : super(key: key);

  @override
  State<DriverTravelMapPage> createState() => _DriverTravelMapPageState();
}

class _DriverTravelMapPageState extends State<DriverTravelMapPage> {
  DriverTravelMapController _con = new DriverTravelMapController();


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
          'Pantalla del mapa'
        ),
      ),
    );
  }

  void refresh(){
    setState(() {});
  }
}
