// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:give_structure/src/pages/driver/register/driver_register_controller.dart';
import 'package:give_structure/src/utils/colors.dart' as utils;
import 'package:give_structure/src/utils/otp_widget.dart';
import 'package:give_structure/src/widgets/button_app.dart';

class DriverRegisterPage extends StatefulWidget {
  const DriverRegisterPage({Key key}) : super(key: key);

  @override
  _DriverRegisterPageState createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {

  DriverRegisterController _con = new DriverRegisterController();

  @override
  void initState(){
    super.initState();
    print('Init State');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      print('Método Schedule');
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Method Build');
    return Scaffold(
      key: _con.key,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _textRegister(),
            _textLicencePlate(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: OTPFields(
                pin1: _con.pin1Controller,
                pin2: _con.pin2Controller,
                pin3: _con.pin3Controller,
                pin4: _con.pin4Controller,
                pin5: _con.pin5Controller,
                pin6: _con.pin6Controller,
              ),
            ),
            _textFieldUsername(),
            _textFieldEmail(),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _buttonRegister(),
          ],
        ),
      ),
    );
  }


  Widget _buttonRegister(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
          onPressed: _con.register,
          color: utils.Colors.giveStructureColor,
          text: 'Registrar ahora',
          textColor: Colors.white,
          icon: Icons.arrow_forward_ios,
      ),
    );
  }

  Widget _textFieldUsername(){
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30
      ),
      child: TextField(
        controller: _con.usernameController,
        decoration: InputDecoration(
          labelText: 'Nombre de usuario',
          hintText: 'Nombre completo',
          suffixIcon: Icon(
              Icons.person_outline,
              color: utils.Colors.giveStructureColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 30
      ),
      child: TextField(
        controller: _con.emailController,
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
          hintText: 'correo@mail.com',
          suffixIcon: Icon(
            Icons.email_outlined,
            color: utils.Colors.giveStructureColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: TextField(
        obscureText: true,
        controller: _con.passwordController,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          suffixIcon: Icon(
              Icons.lock_open_outlined,
              color: utils.Colors.giveStructureColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldConfirmPassword(){
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 30,
      ),
      child: TextField(
        obscureText: true,
        controller: _con.confirmPasswordController,
        decoration: InputDecoration(
          labelText: 'Confirmar Contraseña',
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: utils.Colors.giveStructureColor,
          ),
        ),
      ),
    );
  }

  Widget _textLicencePlate(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Placa del vehículo',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 17
        ),
      ),
    );
  }

  Widget _textRegister(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15
      ),
      child: Text(
        'Registro',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25
        ),
      ),
    );
  }

  Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: utils.Colors.giveStructureColor,
        height: MediaQuery.of(context).size.height * 0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 150,
              height: 100,
            ),
            Text('Fácil y Rápido',
              style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),)
          ],
        ),
      ),
    );
  }
}
