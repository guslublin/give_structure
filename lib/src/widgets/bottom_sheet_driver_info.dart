import 'package:flutter/material.dart';

class BottomSheetDriverInfo extends StatefulWidget {

  String imageUrl;
  String username;
  String email;
  String plate;

  BottomSheetDriverInfo({
    @required this.imageUrl,
    @required this.username,
    @required this.email,
    @required this.plate,
  });

  @override
  _BottomSheetDriverInfoState createState() => _BottomSheetDriverInfoState();
}

class _BottomSheetDriverInfoState extends State<BottomSheetDriverInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            'Tu Conductor',
            style: TextStyle(
                fontSize: 18
            ),
          ),
          SizedBox(height: 15),
          CircleAvatar(
            backgroundImage: AssetImage('assets/img/profile.jpg'),
            radius: 50,
          ),
          ListTile(
            title: Text(
              'Nombre',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.username ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text(
              'Correo',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.email ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.email),
          ),
          ListTile(
            title: Text(
              'Placa del vehiculo',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.plate ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.directions_car_rounded),
          )
        ],
      ),
    );
  }
}
