import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:give_structure/src/widgets/button_app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  Widget build(BuildContext context){
    return Scaffold(
      key: _con.key,
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonUserInfo(),
                    Column(
                      children: [
                        _cardKmInfo('0'),
                        _cardMinInfo('0')
                      ],
                    ),
                    _buttonCenterPosition()
                  ],
                ),
                Expanded(child: Container()),
                _buttonStatus()
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _buttonStatus(){
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonApp(
        onPressed: _con.updateStatus,
        text: _con.currentStatus,
        color: _con.colorStatus,
        textColor: Colors.black,
      ),
    );
  }

  Widget _cardKmInfo(String km){
    return SafeArea(
        child: Container(
          width: 110,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            '${km ?? ''} km',
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
    );
  }

  Widget _cardMinInfo(String min){
    return SafeArea(
        child: Container(
          width: 110,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            '${min ?? ''} seg',
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
    );
  }

  Widget _buttonUserInfo(){
    return GestureDetector(
      onTap: (){},
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          color: Colors.white,
          elevation: 4.0,
          shape: CircleBorder(),
          child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.person,
                color: Colors.grey[600],
                size: 20,)
          ),
        ),
      ),
    );
  }

  Widget _buttonCenterPosition(){
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          color: Colors.white,
          elevation: 4.0,
          shape: CircleBorder(),
          child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.location_searching,
                color: Colors.grey[600],
                size: 20,)
          ),
        ),
      ),
    );
  }

  Widget _googleMapsWidget(){

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh(){
    setState(() {});
  }
}
