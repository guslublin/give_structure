import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:give_structure/src/pages/client/map/client_map_controller.dart';
import 'package:give_structure/src/widgets/button_app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CLientMapPage extends StatefulWidget {
  const CLientMapPage({Key key}) : super(key: key);

  @override
  _CLientMapPageState createState() => _CLientMapPageState();
}

class _CLientMapPageState extends State<CLientMapPage> {
  ClientMapController _con = new ClientMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('Se ejecutó el dispose');
    _con.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _con.key,
      drawer: _drawer(),
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                _buttonDrawer(),
                _cardGooglePlace(),
                _buttonChangeTo(),
                _buttonCenterPosition(),
                Expanded(child: Container()),
                _buttonRequest()
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          )
        ],
      ),
    );
  }

  Widget _buttonDrawer(){
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: _con.openDrawer,
        icon: Icon(Icons.menu, color: Colors.white,),
      ),
    );
  }


  Widget _buttonRequest(){
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonApp(
        onPressed: _con.requestDriver,
        text: 'Solicitar',
        color: Colors.amber,
        textColor: Colors.black,
      ),
    );
  }

  Widget _iconMyLocation(){
    return Image.asset('assets/img/my_location.png', width: 65, height: 65,);
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    _con.client?.username ?? 'Usuario',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                  ),
                ),
                Container(
                  child: Text(
                    _con.client?.email ?? 'Email',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 10,),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/img/profile_2.jpg'),
                  radius: 40,
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.amber
            ),
          ),
          ListTile(
            title: Text('Editar Perfil'),
            trailing: Icon(Icons.edit),
            //leading: Icon(Icons.cancel),
            onTap: (){},
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            trailing: Icon(Icons.power_settings_new),
            //leading: Icon(Icons.cancel),
            onTap: _con.signOut,
          )
        ],
      ),
    );
  }

  Widget _buttonCenterPosition(){
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 20),
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

  Widget _buttonChangeTo(){
    return GestureDetector(
      onTap: _con.changeFromTo,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          color: Colors.white,
          elevation: 4.0,
          shape: CircleBorder(),
          child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.refresh,
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
      onCameraMove: (position){
        _con.initialPosition = position;
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  Widget _cardGooglePlace(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCardLocation(
                'Desde',
                _con.from ?? 'Lugar de recogida',
                () async {
                  _con.showGoogleAutocomplete(true);
                }
              ),
              SizedBox(height: 5,),
              Container(
                width:  double.infinity,
                child: Divider(
                  color: Colors.grey,
                  height: 10,
                ),
              ),
              SizedBox(height: 5,),
              _infoCardLocation(
                  'Hasta',
                  _con.to ?? 'Lugar de destino',
                      () async {
                    _con.showGoogleAutocomplete(false);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCardLocation(String title, String value, Function function){
    return GestureDetector(
      onTap: function,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 10),
          ),
          Text(
            value,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  void refresh(){
    setState(() {});
  }
}
