import 'package:flutter/material.dart';
import 'package:give_structure/src/pages/client/travel_info/client_travel_info_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientTravelInfoPage extends StatefulWidget {
  const ClientTravelInfoPage({Key key}) : super(key: key);

  @override
  _ClientTravelInfoPageState createState() => _ClientTravelInfoPageState();
}

class _ClientTravelInfoPageState extends State<ClientTravelInfoPage> {
  ClientTravelInfoController _con = new ClientTravelInfoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      body: Stack(),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      onCameraMove: (position) {
        _con.initialPosition = position;
      },
      onCameraIdle: () async {
        // await _con.setLocationDraggableInfo();
      },
    );
  }
}
